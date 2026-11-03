import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_proj/product_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final String imagePath;
  final int price;
  final int quantity;

  const Product({
    required this.name,
    required this.imagePath,
    required this.price,
    required this.quantity
  });
}

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final users = FirebaseAuth.instance.currentUser;
  final Stream <QuerySnapshot> usersStream = FirebaseFirestore.instance.collection('products').snapshots();
  final List<Product> products = [
    const Product(name: 'Product 1', imagePath: 'images/shampoo.jpg',price: 100,quantity: 2),
    const Product(name: 'Product 2', imagePath: 'images/ball.jpg',price: 200,quantity: 5),
  ];
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
  }

  void _filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) =>
          product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
    void _showProductDetails(Product product) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProductDetailsPage(product: product),
      ));
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () => _showProductDetails(product),
                  child: Card(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      product.imagePath,
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search products',
                border: InputBorder.none,
              ),
              onChanged: _filterProducts,
            ),
          ),
        ],
      ),
    );
  }

}
