import 'package:autovendi/cart_view_model.dart';
import 'package:autovendi/domain/model/model.dart';
import 'package:flutter/material.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  CartViewModel _cartViewModel = CartViewModel();
  late Wishlist wishlist;

  @override
  void initState() {
   _cartViewModel.getCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Cart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey,
      ),
      body: StreamBuilder<Wishlist>(
        stream: _cartViewModel.outputWishlistStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            wishlist = snapshot.data!;
            return ListView.builder(
              itemBuilder: (context, index) {
                final product = wishlist.products[index + 1]; // Start from the second element
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Price: ${product.price.toString()}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Quantity: ${product.quantity}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_shopping_cart),
                      onPressed: () {
                        // Implement removal from cart functionality
                      },
                    ),
                  ),
                );
              },
              itemCount: wishlist.products.length - 1, // Adjusted itemCount
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },

      ),
    );
  }
}
