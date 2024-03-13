import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/product_model.dart';
import '../provider/cart_provider.dart';
import '../services/api_services.dart';
import 'cart_screen.dart';

class ProductScreen extends StatefulWidget {
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final APIServices apiServices = APIServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Screen'),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
              ),
              Positioned(
                right: 5,
                top: 5,
                child: Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    int itemCount = cartProvider.cartItems.length;
                    return CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        itemCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: apiServices.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No products available');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return Card(
                  color: Colors.black,
                  child: ListTile(
                    leading: Image.network(product.image, width: 50, fit: BoxFit.cover,),
                    title: Text(product.title, style: TextStyle(color: Colors.white),),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.white),),
                    trailing: MaterialButton(
                      color: Colors.blue,
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false).addToCart(product);
                        print('Product added to cart: ${product.title}');
                      },
                      child: Text('Add to Cart', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
