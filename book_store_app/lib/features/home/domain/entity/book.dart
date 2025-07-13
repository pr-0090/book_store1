import 'package:equatable/equatable.dart';

class BookEntity extends Equatable {
  final String? id;
  final String title;
  final String author;
  final String genre;
  final String publisher;
  final int publicationYear;
  final double price;
  final String coverImage;
  final String? description;
  final int pageCount; // ✅ New field
  final double weightGrams; // ✅ New field

  const BookEntity({
    this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.publisher,
    required this.publicationYear,
    required this.price,
    required this.coverImage,
    this.description,
    required this.pageCount, // ✅ Add to constructor
    required this.weightGrams, // ✅ Add to constructor
  });

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
    pageCount,
    weightGrams,
  ];
}
