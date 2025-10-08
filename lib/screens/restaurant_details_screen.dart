import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tasty_kitchens/models/restaurant.dart';
import 'package:tasty_kitchens/providers/cart_provider.dart';
import 'package:tasty_kitchens/screens/cart_screen.dart';
import 'package:tasty_kitchens/services/restaurant_api_service.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final String restaurantId;

  RestaurantDetailsScreen({required this.restaurantId});

  @override
  _RestaurantDetailsScreenState createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  final RestaurantApiService _apiService = RestaurantApiService();
  late Future<Restaurant> _restaurantDetailsFuture;

  @override
  void initState() {
    super.initState();
    _restaurantDetailsFuture = _apiService.fetchRestaurantDetails(
      widget.restaurantId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restaurant Details')),
      body: FutureBuilder<Restaurant>(
        future: _restaurantDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load restaurant details: ${snapshot.error}',
              ),
            );
          } else if (snapshot.hasData) {
            final restaurant = snapshot.data!;
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        restaurant.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              restaurant.cuisine,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.solidStar,
                                  color: Colors.yellow,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(restaurant.userRating.rating.toString()),
                                SizedBox(width: 4),
                                Text(
                                  '(${restaurant.userRating.totalReviews} ratings)',
                                ),
                                Spacer(),
                                Text('Cost for Two: ₹${restaurant.costForTwo}'),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Food Items',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: restaurant.foodItems.length,
                              itemBuilder: (context, index) {
                                final foodItem = restaurant.foodItems[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    leading: Image.network(
                                      foodItem.imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(foodItem.name),
                                    subtitle: Text('₹${foodItem.cost}'),
                                    trailing: Consumer<CartProvider>(
                                      builder: (context, cart, child) {
                                        final cartItem = cart.cartItems
                                            .firstWhere(
                                              (item) =>
                                                  item.foodItem.id ==
                                                  foodItem.id,
                                              orElse: () => CartItem(
                                                foodItem: foodItem,
                                                quantity: 0,
                                              ),
                                            );
                                        if (cartItem.quantity > 0) {
                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.remove),
                                                onPressed: () =>
                                                    cart.decrementQuantity(
                                                      foodItem.id,
                                                    ),
                                              ),
                                              Text(
                                                cartItem.quantity.toString(),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () =>
                                                    cart.incrementQuantity(
                                                      foodItem.id,
                                                    ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return ElevatedButton(
                                            onPressed: () =>
                                                cart.addItem(foodItem),
                                            child: Text('ADD'),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    if (cart.cartItems.isNotEmpty) {
                      return Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(16),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CartScreen(),
                                ),
                              );
                            },
                            child: Text('Go to Cart'),
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ],
            );
          } else {
            return Center(child: Text('No restaurant details available.'));
          }
        },
      ),
    );
  }
}
