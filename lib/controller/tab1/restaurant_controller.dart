import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../model/restaurant.dart';

class RestaurantController extends GetxController {
  // 전체 레스토랑 목록
  var restaurantList = <Restaurant>[].obs;

  // 검색된 레스토랑 목록
  var filteredList = <Restaurant>[].obs;

  // 로딩 상태
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadRestaurants();
  }

  // JSON에서 레스토랑 데이터를 로드하는 메서드
  Future<void> loadRestaurants() async {
    try {
      isLoading(true);
      // assets에서 JSON 문자열 로드
      final String jsonString =
          await rootBundle.loadString('assets/data/data.json');

      // JSON 데이터 디코드
      final List<dynamic> jsonResponse = json.decode(jsonString);

      // JSON을 Restaurant 모델로 매핑
      var loadedRestaurants =
          jsonResponse.map((json) => Restaurant.fromJson(json)).toList();

      // 옵저버블 리스트 업데이트
      restaurantList.assignAll(loadedRestaurants);

      // 검색 리스트도 전체 레스토랑 목록으로 초기화
      filteredList.assignAll(loadedRestaurants);
    } catch (e) {
      Get.snackbar('에러', '레스토랑 데이터를 불러오지 못했습니다.');
    } finally {
      isLoading(false);
    }
  }

  // 검색 메서드
  void searchRestaurants(String query) {
    if (query.isEmpty) {
      // 검색어가 없으면 전체 목록 표시
      filteredList.assignAll(restaurantList);
    } else {
      // 검색어가 있으면 레스토랑 이름에 검색어가 포함된 항목만 필터링
      filteredList.assignAll(
        restaurantList.where((restaurant) =>
            restaurant.name.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  // 검색 결과 초기화
  void clearSearchResults() {
    filteredList.assignAll(restaurantList);
  }
}
