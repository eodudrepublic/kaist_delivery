import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;

class RestaurantList extends StatefulWidget {
  const RestaurantList({super.key});

  @override
  _RestaurantListState createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final jsonString =
        await rootBundle.rootBundle.loadString('assets/data/data.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      _data = jsonData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant List'),
      ),
      body: _data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final restaurant = _data[index];
                return ListTile(
                  title: Text(restaurant['Name']),
                  subtitle: Text(restaurant['Address']),
                  trailing: Text(restaurant['Phone']),
                );
              },
            ),
    );
  }
}
