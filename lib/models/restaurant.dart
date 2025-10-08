import 'package:tasty_kitchens/models/food_item.dart';

class UserRating {
  final double rating;
  final int totalReviews;

  UserRating({
    required this.rating,
    required this.totalReviews,
  });

  factory UserRating.fromJson(Map<String, dynamic> json) {
    return UserRating(
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] as int? ?? 0,
    );
  }
}

class Restaurant {
  final String id;
  final String name;
  final String imageUrl;
  final String cuisine;
  final int costForTwo;
  final UserRating userRating;
  final List<FoodItem> foodItems;

  Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.cuisine,
    required this.costForTwo,
    required this.userRating,
    required this.foodItems,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? foodItemsJson = json['food_items'];
    List<FoodItem> foodItems = foodItemsJson != null
        ? foodItemsJson.map((item) => FoodItem.fromJson(item)).toList()
        : [];

    return Restaurant(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'N/A',
      imageUrl: json['image_url'] as String? ?? '',
      cuisine: json['cuisine'] as String? ?? 'N/A',
      costForTwo: json['cost_for_two'] as int? ?? 0,
      userRating: UserRating.fromJson(json['user_rating'] ?? {}),
      foodItems: foodItems,
    );
  }
}
