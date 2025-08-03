/// A Flutter library for extracting book data from libraccio.it
///
/// This library provides utilities to parse book information from
/// libraccio.it product pages, including title, author, ISBN, description,
/// cover image, price, and availability.
///
/// Example usage:
/// ```dart
/// final book = await LibraccioParser.extractBookData(
///   'https://www.libraccio.it/libro/9788806266738/davide-longo/la-donna-della-mansarda.html',
/// );
/// 
/// if (book != null) {
///   print('Book title: ${book.name}');
///   print('Author: ${book.author?.name}');
///   print('Price: €${book.offers?.price}');
/// }
/// ```

library libraccio_extractor;

export 'book.dart';
export 'libraccio_parser.dart';
export 'book_cover_widget.dart';
