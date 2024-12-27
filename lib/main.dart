import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaist_delivery/view/tab1/restaurant_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '레스토랑 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RestaurantListView(),
    );
  }
}
