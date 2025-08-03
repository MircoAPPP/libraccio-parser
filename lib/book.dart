import 'package:json_annotation/json_annotation.dart';

part 'book.g.dart';

@JsonSerializable()
class Book {
  final List<String>? type;
  final String? context;
  final String? name;
  final String? isbn;
  final String? description;
  final String? image;
  final Offer? offers;
  final Author? author;

  Book({
    this.type,
    this.context,
    this.name,
    this.isbn,
    this.description,
    this.image,
    this.offers,
    this.author,
  });

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
  Map<String, dynamic> toJson() => _$BookToJson(this);
}

@JsonSerializable()
class Offer {
  final String? type;
  final String? context;
  final String? availability;
  final String? price;
  final String? priceCurrency;

  Offer({
    this.type,
    this.context,
    this.availability,
    this.price,
    this.priceCurrency,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
  Map<String, dynamic> toJson() => _$OfferToJson(this);
}

@JsonSerializable()
class Author {
  final String? type;
  final String? context;
  final String? name;

  Author({
    this.type,
    this.context,
    this.name,
  });

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}
