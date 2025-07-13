import 'package:book_store/features/home/data/model/book_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_books_dto.g.dart';

@JsonSerializable()
class GetAllBooksDto {
  final bool success;
  final int? count; // nullable count
  final List<BookApiModel> data;

  const GetAllBooksDto({required this.success, this.count, required this.data});

  factory GetAllBooksDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllBooksDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllBooksDtoToJson(this);
}
