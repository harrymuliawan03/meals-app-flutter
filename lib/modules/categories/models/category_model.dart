import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.color = const Color(0xFFFFFFFF),
  });

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'slug')
  final String slug;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  @JsonKey(name: 'color')
  final Color color;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  static Color _colorFromJson(String colorString) {
    colorString = colorString.replaceFirst('#', '');
    if (colorString.length == 6) {
      colorString = 'FF' + colorString; // Add alpha value if missing
    }
    return Color(int.parse(colorString, radix: 16));
  }

  static String _colorToJson(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }
}
