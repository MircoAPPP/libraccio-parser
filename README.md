# Libraccio Extractor

A Flutter library for extracting book data from [libraccio.it](https://www.libraccio.it/) product pages.

This library parses the JSON-LD structured data embedded in libraccio.it book pages and provides a convenient Dart API to access book information including title, author, ISBN, description, cover image, price, and availability.

[![Pub](https://img.shields.io/pub/v/libraccio_extractor)](https://pub.dev/packages/libraccio_extractor)
[![License](https://img.shields.io/github/license/yourusername/libraccio_extractor)](https://github.com/yourusername/libraccio_extractor/blob/main/LICENSE)

## Features

- Extracts book data from libraccio.it product pages
- Parses JSON-LD structured data (schema.org Book/Product)
- Provides Dart models for all book properties
- Includes a widget for displaying book cover images
- Handles network requests and HTML parsing
- Automatic handling of ISBN-based lookups
- Manages HTML redirects from libraccio.it

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  libraccio_extractor: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
import 'package:libraccio_extractor/libraccio_extractor.dart';

// Extract book data by ISBN
final book = await LibraccioParser.extractBookDataByIsbn('9788806266738');

if (book != null) {
  print('Title: ${book.name}');
  print('Author: ${book.author?.name}');
  print('Price: ${book.offers?.price} ${book.offers?.priceCurrency}');
}
```

### Using the BookCoverWidget

```dart
import 'package:libraccio_extractor/book_cover_widget.dart';

BookCoverWidget(
  imageUrl: book.image,
  width: 120,
  height: 160,
  fit: BoxFit.cover,
)
```

## API Reference

### LibraccioParser

The main class for extracting book data from libraccio.it.

#### Methods

##### `extractBookData(String url) → Future<Book?>`

Extracts book data from a libraccio.it product page URL.

- `url`: The full URL of the libraccio.it product page
- Returns: A `Book` object if successful, `null` otherwise

##### `extractBookDataByIsbn(String isbn) → Future<Book?>`

Extracts book data by ISBN from libraccio.it. This method automatically constructs the URL and handles redirects.

- `isbn`: The ISBN of the book to look up
- Returns: A `Book` object if successful, `null` otherwise

##### `parseBookFromHtml(String htmlContent) → Book?`

Parses book data from HTML content containing JSON-LD script tags.

- `htmlContent`: The HTML content to parse
- Returns: A `Book` object if successful, `null` otherwise

### Book Model

Represents a book with all its properties extracted from libraccio.it.

#### Properties

- `type`: List of types (e.g., ["Book", "Product"])
- `context`: JSON-LD context
- `name`: Title of the book
- `isbn`: ISBN of the book
- `description`: Description of the book
- `image`: URL of the book cover image
- `offers`: Offer information (see Offer model)
- `author`: Author information (see Author model)

### Offer Model

Represents the offer information for a book.

#### Properties

- `type`: Type of the offer
- `context`: JSON-LD context
- `availability`: Availability status
- `price`: Price of the book
- `priceCurrency`: Currency of the price (e.g., "EUR")

### Author Model

Represents the author of a book.

#### Properties

- `type`: Type of the author
- `context`: JSON-LD context
- `name`: Name of the author

### BookCoverWidget

A Flutter widget to display a book cover image with loading and error states.

#### Properties

- `imageUrl`: URL of the book cover image
- `width`: Width of the widget (default: 120)
- `height`: Height of the widget (default: 160)
- `fit`: How to fit the image (default: BoxFit.cover)

## Example

See the `example` directory for a complete Flutter app demonstrating the usage of this library.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

Then run:

```bash
flutter pub get
```

## Usage

Import the library:

```dart
import 'package:libraccio_extractor/libraccio_extractor.dart';
```

Extract book data by ISBN (recommended approach):

```dart
final book = await LibraccioParser.extractBookDataByIsbn('9788806266738');

if (book != null) {
  print('Title: ${book.name}');
  print('Author: ${book.author?.name}');
  print('ISBN: ${book.isbn}');
  print('Price: €${book.offers?.price}');
  print('Availability: ${book.offers?.availability}');
}
```

Alternatively, extract book data from a libraccio.it URL:

```dart
final book = await LibraccioParser.extractBookData(
  'https://www.libraccio.it/libro/9788806266738/davide-longo/la-donna-della-mansarda.html',
);
```

Display a book cover image:

```dart
BookCoverWidget(
  imageUrl: book.image,
  width: 120,
  height: 160,
)
```

Parse book data from HTML content directly:

```dart
final book = LibraccioParser.parseBookFromHtml(htmlContent);
```

## Data Models

The library provides the following data models:

- `Book`: Main book data including title, author, ISBN, description, etc.
- `Offer`: Pricing and availability information
- `Author`: Author information

## Dependencies

This library depends on:

- `http`: For making network requests
- `html`: For parsing HTML content
- `json_annotation`: For JSON serialization
- `cached_network_image`: For efficient image loading and caching

## Example App

See the `example/` directory for a complete Flutter app demonstrating usage.

## License

MIT
