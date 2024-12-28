import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../model/restaurant.dart';

class RestaurantSearchController extends GetxController {
  var restaurantList = <Restaurant>[].obs; // 전체 레스토랑 데이터
  var filteredList = <Restaurant>[].obs; // 검색 결과를 저장
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadRestaurants();
  }

  Future<void> loadRestaurants() async {
    try {
      isLoading(true);
      final String jsonString =
          await rootBundle.loadString('assets/data/data.json');
      final List<dynamic> jsonResponse = json.decode(jsonString);
      var loadedRestaurants =
          jsonResponse.map((json) => Restaurant.fromJson(json)).toList();
      restaurantList.assignAll(loadedRestaurants);
      filteredList.assignAll(loadedRestaurants); // 초기에는 모든 데이터 표시
    } catch (e) {
      Get.snackbar('에러', '레스토랑 데이터를 불러오지 못했습니다.');
    } finally {
      isLoading(false);
    }
  }

  void searchRestaurants(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(restaurantList);
    } else {
      filteredList.assignAll(
        restaurantList.where((restaurant) =>
            restaurant.name.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }
}
