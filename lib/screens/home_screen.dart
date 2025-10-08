import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasty_kitchens/models/restaurant.dart';
import 'package:tasty_kitchens/screens/login_screen.dart';
import 'package:tasty_kitchens/screens/restaurant_details_screen.dart';
import 'package:tasty_kitchens/services/restaurant_api_service.dart';
import 'package:tasty_kitchens/widgets/footer.dart';
import 'package:tasty_kitchens/screens/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RestaurantApiService _apiService = RestaurantApiService();
  late Future<List<String>> _carouselImagesFuture;
  late Future<List<Restaurant>> _restaurantsFuture;
  final int _limit = 9;
  int _activePage = 1;
  int _totalItems = 0;
  String _sortBy = 'Lowest';

  @override
  void initState() {
    super.initState();
    _carouselImagesFuture = _apiService.fetchCarouselImages();
    _restaurantsFuture = _fetchRestaurants();
  }

  Future<List<Restaurant>> _fetchRestaurants() async {
    final response = await _apiService.fetchRestaurants(
      offset: (_activePage - 1) * _limit,
      limit: _limit,
      sortBy: _sortBy,
    );

    final restaurantsJson = response['restaurants'] as List;
    setState(() {
      _totalItems = response['total'];
    });

    return restaurantsJson.map((json) => Restaurant.fromJson(json)).toList();
  }

  void _nextPage() {
    if (_activePage < (_totalItems / _limit).ceil()) {
      setState(() {
        _activePage++;
        _restaurantsFuture = _fetchRestaurants();
      });
    }
  }

  void _previousPage() {
    if (_activePage > 1) {
      setState(() {
        _activePage--;
        _restaurantsFuture = _fetchRestaurants();
      });
    }
  }

  void _onSortChange(String? newValue) {
    if (newValue != null) {
      setState(() {
        _sortBy = newValue;
        _activePage = 1;
        _restaurantsFuture = _fetchRestaurants();
      });
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/ccbp-logo-img.png',
              height: 30,
              semanticLabel: 'website logo',
            ),
            SizedBox(width: 8),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Home', style: TextStyle(color: Colors.orange)),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
            child: Text('Cart', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: _logout,
            child: Text('Logout', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<String>>(
              future: _carouselImagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load offers.'));
                } else if (snapshot.hasData) {
                  return CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                    ),
                    items: snapshot.data!.map((imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              semanticLabel: 'offer',
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Popular Restaurants',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Select your favorite restaurant special dish and make your day happy.',
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.sort),
                          SizedBox(width: 8),
                          DropdownButton<String>(
                            value: _sortBy,
                            items: <String>['Lowest', 'Highest'].map((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text('Sort By: $value'),
                              );
                            }).toList(),
                            onChanged: _onSortChange,
                          ),
                        ],
                      ),
                    ],
                  ),
                  FutureBuilder<List<Restaurant>>(
                    future: _restaurantsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Failed to load restaurants.'),
                        );
                      } else if (snapshot.hasData) {
                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final restaurant = snapshot.data![index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RestaurantDetailsScreen(
                                                restaurantId: restaurant.id,
                                              ),
                                        ),
                                      );
                                    },
                                    leading: Image.network(
                                      restaurant.imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      semanticLabel: 'restaurant',
                                    ),
                                    title: Text(restaurant.name),
                                    subtitle: Text(
                                      '${restaurant.cuisine}\n\₹${restaurant.costForTwo} for two',
                                    ),
                                    trailing: Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.solidStar,
                                              color: Colors.yellow,
                                              size: 12,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              restaurant.userRating.rating
                                                  .toString(),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${restaurant.userRating.totalReviews} Ratings',
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: _previousPage,
                                  icon: Icon(Icons.arrow_back_ios),
                                ),
                                Text(
                                  '$_activePage of ${(_totalItems / _limit).ceil()}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  onPressed: _nextPage,
                                  icon: Icon(Icons.arrow_forward_ios),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Center(child: Text('No restaurants available.'));
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Footer(),
          ],
        ),
      ),
    );
  }
}
