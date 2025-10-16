import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tasty_kitchens/models/restaurant.dart';
import 'package:tasty_kitchens/providers/cart_provider.dart';
import 'package:tasty_kitchens/widgets/footer.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/empty-cart.png',
                    width: 200,
                    semanticLabel: 'empty cart',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No Orders Yet!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('Your cart is empty. Add something from the menu.'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      ); // 
                    },
                    child: Text('Order Now'),
                  ),
                ],
              ),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart.cartItems[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: ListTile(
                          leading: Image.network(
                            cartItem.foodItem.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(cartItem.foodItem.name),
                          subtitle: Text('₹${cartItem.foodItem.cost}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => cart.decrementQuantity(
                                  cartItem.foodItem.id,
                                ),
                                icon: Icon(Icons.remove),
                              ),
                              Text(cartItem.quantity.toString()),
                              IconButton(
                                onPressed: () => cart.incrementQuantity(
                                  cartItem.foodItem.id,
                                ),
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order Total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${cart.totalCost.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  child: Text('Place Order'),
                ),
                SizedBox(height: 16),
              ],
            );
          }
        },
      ),
    );
  }
}
