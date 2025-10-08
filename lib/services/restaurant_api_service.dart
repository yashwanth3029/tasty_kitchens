import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasty_kitchens/models/restaurant.dart';

class RestaurantApiService {
  final String _baseUrl = 'https://apis.ccbp.in';

  Future<http.Response> _get(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  Future<List<String>> fetchCarouselImages() async {
    final response = await _get('$_baseUrl/restaurants-list/offers');
    final data = jsonDecode(response.body);
    final List<dynamic> offersJson = data['offers'];
    return offersJson.map((offer) => offer['image_url'] as String).toList();
  }

  Future<Map<String, dynamic>> fetchRestaurants({
    required int offset,
    required int limit,
    required String sortBy,
  }) async {
    final url =
        '$_baseUrl/restaurants-list?offset=$offset&limit=$limit&sort_by_rating=$sortBy';
    final response = await _get(url);
    return jsonDecode(response.body);
  }

  Future<Restaurant> fetchRestaurantDetails(String restaurantId) async {
    final url = '$_baseUrl/restaurants-list/$restaurantId';
    final response = await _get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Restaurant.fromJson(data);
    } else {
      throw Exception('Failed to load restaurant details');
    }
  }
}
