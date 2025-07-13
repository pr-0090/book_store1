// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookApiModel _$BookApiModelFromJson(Map<String, dynamic> json) => BookApiModel(
  id: json['_id'] as String?,
  title: json['title'] as String,
  author: json['author'] as String,
  genre: json['genre'] as String,
  publisher: json['publisher'] as String,
  publicationYear: (json['publicationYear'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
  coverImage: json['coverImage'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$BookApiModelToJson(BookApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'genre': instance.genre,
      'publisher': instance.publisher,
      'publicationYear': instance.publicationYear,
      'price': instance.price,
      'coverImage': instance.coverImage,
      'description': instance.description,
    };
