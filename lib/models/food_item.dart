// TODO Implement this library.
import 'package:flutter/material.dart';

class FoodItem {
  final String id;
  final String name;
  final int cost;
  final String imageUrl;

  FoodItem({
    required this.id,
    required this.name,
    required this.cost,
    required this.imageUrl,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'N/A',
      cost: json['cost'] as int? ?? 0,
      imageUrl: json['image_url'] as String? ?? '',
    );
  }
}
