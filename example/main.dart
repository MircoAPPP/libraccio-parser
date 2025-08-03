import 'package:flutter/material.dart';
import 'package:libraccio_extractor/libraccio_extractor.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({Key? key}) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  Book? _book;
  bool _isLoading = false;
  String _errorMessage = '';
  final TextEditingController _isbnController = TextEditingController();

  Future<void> _fetchBookDataByIsbn() async {
    final isbn = _isbnController.text.trim();
    if (isbn.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an ISBN';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final book = await LibraccioParser.extractBookDataByIsbn(isbn);
      setState(() {
        _book = book;
        _isLoading = false;
        
        if (book == null) {
          _errorMessage = 'No book found for ISBN: $isbn';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching book data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Libraccio Book Extractor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _isbnController,
                    decoration: const InputDecoration(
                      labelText: 'Enter ISBN',
                      hintText: 'e.g., 9788806266738',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _fetchBookDataByIsbn,
                  child: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage.isNotEmpty && _book == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_errorMessage),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchBookDataByIsbn,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _book == null
                          ? const Center(child: Text('Enter an ISBN to search for a book'))
                          : _buildBookDetails(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookCoverWidget(
                imageUrl: _book!.image,
                width: 120,
                height: 160,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _book!.name ?? 'Unknown Title',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _book!.author?.name ?? 'Unknown Author',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_book!.isbn != null)
                      Text('ISBN: ${_book!.isbn}'),
                    const SizedBox(height: 8),
                    if (_book!.offers != null)
                      Row(
                        children: [
                          Text(
                            '€${_book!.offers!.price}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (_book!.offers!.availability != null)
                            Text(
                              _book!.offers!.availability!
                                  .split('/')
                                  .last
                                  .replaceAll('InStock', 'In Stock')
                                  .replaceAll('OutOfStock', 'Out of Stock'),
                              style: TextStyle(
                                color: _book!.offers!.availability!
                                        .contains('InStock')
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_book!.description != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  _parseHtmlString(_book!.description!),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _parseHtmlString(String htmlString) {
    // Simple HTML tag removal - in a real app, you might want to use
    // a proper HTML parser like flutter_html
    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');
  }

  @override
  void dispose() {
    _isbnController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Libraccio Extractor Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BookDetailScreen(),
    );
  }
}
