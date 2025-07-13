// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_books_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllBooksDto _$GetAllBooksDtoFromJson(Map<String, dynamic> json) =>
    GetAllBooksDto(
      success: json['success'] as bool,
      count: (json['count'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => BookApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllBooksDtoToJson(GetAllBooksDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };
