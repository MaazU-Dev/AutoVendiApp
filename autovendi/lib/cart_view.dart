import 'package:autovendi/cart_view_model.dart';
import 'package:autovendi/domain/model/model.dart';
import 'package:autovendi/resources/color_manager.dart';
import 'package:autovendi/resources/values_manager.dart';
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
                final product = wishlist
                    .products[index + 1]; // Start from the second element
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      onPressed: () async {
                        bool checker =
                            await _cartViewModel.deleteProduct(product);


                        setState(() {});

                        if (checker) {
                          _showSnackBar(context, "Removed from cart");
                        } else {
                          _showSnackBar(context, "Not removed from cart");
                        }
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

  _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Center(
          child: Text(
            message,
            style: TextStyle(
              color: ColorManager.white,
              fontSize: AppSize.size18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            right: 20,
            left: 20),
        duration: const Duration(seconds: 2),
        dismissDirection: DismissDirection.down,
        backgroundColor: ColorManager.grey2,
      ),
    );
  }
}
