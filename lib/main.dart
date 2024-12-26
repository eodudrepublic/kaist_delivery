import 'package:flutter/material.dart';
import 'package:kaist_delivery/restaurant_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RestaurantList(),
    );
  }
}
