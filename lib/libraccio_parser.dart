import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'book.dart';

class LibraccioParser {
  /// Extracts book data from a libraccio.it product page URL
  static Future<Book?> extractBookData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return parseBookFromHtml(response.body);
      }
      return null;
    } catch (e) {
      // Handle error appropriately in your app
      print('Error fetching book data: $e');
      return null;
    }
  }

  /// Extracts book data by ISBN from libraccio.it
  /// This method will automatically construct the URL and handle redirects
  static Future<Book?> extractBookDataByIsbn(String isbn) async {
    try {
      // Construct the URL with the ISBN
      final url = 'https://www.libraccio.it/libro/$isbn/';
      print('Fetching book data for ISBN: $isbn from URL: $url');
      
      // Make the request with redirect following
      final client = http.Client();
      try {
        final request = http.Request('GET', Uri.parse(url));
        final response = await client.send(request);
        
        // Get the final URL after redirects
        final finalUrl = response.request!.url.toString();
        print('Response status code: ${response.statusCode}');
        print('Final URL after redirects: $finalUrl');
        
        // Get the response body
        final responseBody = await response.stream.bytesToString();
        print('Response body length: ${responseBody.length}');
        
        if (response.statusCode == 200) {
          print('Successfully fetched page, parsing book data...');
          final book = parseBookFromHtml(responseBody);
          if (book != null) {
            print('Successfully parsed book data: ${book.name}');
          } else {
            print('Failed to parse book data from HTML');
          }
          return book;
        }
        
        // If we got a redirect page, try to extract the redirect URL and fetch again
        if (responseBody.contains('Object moved') && responseBody.contains('href="')) {
          print('Detected HTML redirect page, extracting redirect URL...');
          final redirectMatch = RegExp(r'href="([^"]+)"').firstMatch(responseBody);
          if (redirectMatch != null) {
            final redirectUrl = redirectMatch.group(1)!;
            final fullRedirectUrl = redirectUrl.startsWith('http') ? redirectUrl : 'https://www.libraccio.it$redirectUrl';
            print('Redirecting to: $fullRedirectUrl');
            
            final redirectResponse = await http.get(Uri.parse(fullRedirectUrl));
            print('Redirect response status code: ${redirectResponse.statusCode}');
            if (redirectResponse.statusCode == 200) {
              print('Successfully fetched redirected page, parsing book data...');
              final book = parseBookFromHtml(redirectResponse.body);
              if (book != null) {
                print('Successfully parsed book data from redirected page: ${book.name}');
              } else {
                print('Failed to parse book data from redirected HTML');
              }
              return book;
            }
          } else {
            print('Could not extract redirect URL from HTML');
          }
        }
        
        print('Failed to fetch book data');
        return null;
      } finally {
        client.close();
      }
    } catch (e, stackTrace) {
      // Handle error appropriately in your app
      print('Error fetching book data by ISBN: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Parses book data from HTML content containing JSON-LD script tags
  static Book? parseBookFromHtml(String htmlContent) {
    try {
      final document = html_parser.parse(htmlContent);
      final scriptTags = document.querySelectorAll('script[type="application/ld+json"]');
      
      for (var script in scriptTags) {
        final jsonContent = script.innerHtml.trim();
        if (jsonContent.isNotEmpty) {
          try {
            final jsonData = json.decode(jsonContent);
            
            // Check if this JSON-LD is for a Book/Product
            if (_isBookData(jsonData)) {
              return Book.fromJson(jsonData);
            }
          } catch (e) {
            // Skip invalid JSON
            continue;
          }
        }
      }
      return null;
    } catch (e) {
      // Handle parsing error
      print('Error parsing HTML: $e');
      return null;
    }
  }

  /// Checks if the JSON data represents a Book/Product
  static bool _isBookData(Map<String, dynamic> jsonData) {
    final type = jsonData['@type'];
    if (type == null) return false;
    
    if (type is String) {
      return type == 'Book' || type == 'Product';
    } else if (type is List) {
      return type.contains('Book') || type.contains('Product');
    }
    
    return false;
  }
}
