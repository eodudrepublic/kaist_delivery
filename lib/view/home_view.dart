import 'package:flutter/material.dart';
import 'package:kaist_delivery/view/tab1/restaurant_list_view.dart';
import 'package:kaist_delivery/view/tab2/content_view.dart';
import '../common/widget/custom_appbar.dart';
import '../common/widget/custom_bnb.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 1;

  // TODO : tab3 만들어서 페이지 연결하기
  final List<Widget> _pages = [
    ContentView(),
    RestaurantListView(),
    const Center(child: Text('Search Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
