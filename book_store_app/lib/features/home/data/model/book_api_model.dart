import 'package:book_store/features/home/domain/entity/book.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_api_model.g.dart';

@JsonSerializable()
class BookApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String author;
  final String genre;
  final String publisher;
  final int publicationYear;
  final double price;
  final String coverImage; // file path or URL
  final String? description;

  const BookApiModel({
    this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.publisher,
    required this.publicationYear,
    required this.price,
    required this.coverImage,
    this.description,
  });

  factory BookApiModel.fromJson(Map<String, dynamic> json) =>
      _$BookApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookApiModelToJson(this);

  BookEntity toEntity() {
    return BookEntity(
      id: id,
      title: title,
      author: author,
      genre: genre,
      publisher: publisher,
      publicationYear: publicationYear,
      price: price,
      coverImage: coverImage,
      description: description,
    );
  }

  factory BookApiModel.fromEntity(BookEntity entity) {
    return BookApiModel(
      id: entity.id,
      title: entity.title,
      author: entity.author,
      genre: entity.genre,
      publisher: entity.publisher,
      publicationYear: entity.publicationYear,
      price: entity.price,
      coverImage: entity.coverImage,
      description: entity.description,
    );
  }

  static List<BookEntity> toEntityList(List<BookApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
    id,
    title,
    author,
    genre,
    publisher,
    publicationYear,
    price,
    coverImage,
    description,
  ];
}
