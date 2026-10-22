import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Productdetailsscreen extends StatelessWidget {
  const Productdetailsscreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Details')),

      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('product ID: $productId'),
          ElevatedButton(
            onPressed: () {
              context.pop();
            },
            child: Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
