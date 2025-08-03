// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) => Book(
  type: (json['type'] as List<dynamic>?)?.map((e) => e as String).toList(),
  context: json['context'] as String?,
  name: json['name'] as String?,
  isbn: json['isbn'] as String?,
  description: json['description'] as String?,
  image: json['image'] as String?,
  offers: json['offers'] == null
      ? null
      : Offer.fromJson(json['offers'] as Map<String, dynamic>),
  author: json['author'] == null
      ? null
      : Author.fromJson(json['author'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
  'type': instance.type,
  'context': instance.context,
  'name': instance.name,
  'isbn': instance.isbn,
  'description': instance.description,
  'image': instance.image,
  'offers': instance.offers,
  'author': instance.author,
};

Offer _$OfferFromJson(Map<String, dynamic> json) => Offer(
  type: json['type'] as String?,
  context: json['context'] as String?,
  availability: json['availability'] as String?,
  price: json['price'] as String?,
  priceCurrency: json['priceCurrency'] as String?,
);

Map<String, dynamic> _$OfferToJson(Offer instance) => <String, dynamic>{
  'type': instance.type,
  'context': instance.context,
  'availability': instance.availability,
  'price': instance.price,
  'priceCurrency': instance.priceCurrency,
};

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
  type: json['type'] as String?,
  context: json['context'] as String?,
  name: json['name'] as String?,
);

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
  'type': instance.type,
  'context': instance.context,
  'name': instance.name,
};
