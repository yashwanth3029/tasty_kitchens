import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:tasty_kitchens/screens/login_screen.dart';
import 'package:tasty_kitchens/screens/home_screen.dart';
import 'package:tasty_kitchens/providers/cart_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => CartProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasty Kitchens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData( 
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasData && snapshot.data == true) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') != null;
  }
}
