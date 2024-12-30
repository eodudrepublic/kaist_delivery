import 'dart:convert';
import 'package:flutter/material.dart'; // PageController, ScrollController, Curves를 사용하기 위한 임포트
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // launchUrl을 사용하기 위해 임포트
import '../../model/restaurant.dart';

class RestaurantController extends GetxController {
  // 전체 레스토랑 목록
  var restaurantList = <Restaurant>[].obs;

  // 검색된 레스토랑 목록
  var filteredList = <Restaurant>[].obs;

  // 로딩 상태
  var isLoading = true.obs;

  // 카테고리 관련
  var selectedCategoryIndex = 0.obs;
  final List<String> categories = [
    '전체', '한식', '중식', '분식', '일식', '야식', '아시안',
  ];

  // 페이지 관련
  late PageController pageController;
  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    // controller 초기화 시점에서 페이지와 스크롤 컨트롤러를 초기화
    pageController = PageController();
    scrollController = ScrollController();
    loadRestaurants(); // 레스토랑 로드
  }

  // JSON에서 레스토랑 데이터를 로드하는 메서드
  Future<void> loadRestaurants() async {
    try {
      isLoading(true);
      final String jsonString =
          await rootBundle.loadString('assets/data/data.json');
      final List<dynamic> jsonResponse = json.decode(jsonString);
      var loadedRestaurants =
          jsonResponse.map((json) => Restaurant.fromJson(json)).toList();

      restaurantList.assignAll(loadedRestaurants);
      filteredList.assignAll(loadedRestaurants);
    } catch (e) {
      Get.snackbar('에러', '레스토랑 데이터를 불러오지 못했습니다.');
    } finally {
      isLoading(false);
    }
  }

  // 카테고리 필터링 함수
  void filterRestaurantsByCategory() {
    if (selectedCategoryIndex.value == 0) {
      filteredList.assignAll(restaurantList);
    } else {
      String selectedCategory = categories[selectedCategoryIndex.value];
      filteredList.assignAll(
        restaurantList
            .where((restaurant) => restaurant.category == selectedCategory)
            .toList(),
      );
    }
  }

  // 영업 상태 확인 및 정렬
  void sortRestaurants() {
    DateTime now = DateTime.now();

    List<Restaurant> sortedList = List.from(restaurantList);
    sortedList.sort((a, b) {
      //A 운영 시간
      DateTime openA = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(a.openTime.split(':')[0]),
          int.parse(a.openTime.split(':')[1]));
      DateTime closeA = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(a.closeTime.split(':')[0]),
          int.parse(a.closeTime.split(':')[1]));
      //새벽까지 운영하는 경우 고려
      if (closeA.isBefore(openA)) closeA = closeA.add(const Duration(days: 1));
      bool isOpenA = now.isAfter(openA) && now.isBefore(closeA);
      //B 가게 운영 시간
      DateTime openB = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(b.openTime.split(':')[0]),
          int.parse(b.openTime.split(':')[1]));
      DateTime closeB = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(b.closeTime.split(':')[0]),
          int.parse(b.closeTime.split(':')[1]));
      if (closeB.isBefore(openB)) closeB = closeB.add(const Duration(days: 1));
      bool isOpenB = now.isAfter(openB) && now.isBefore(closeB);

      //정렬 기준
      if (isOpenA && !isOpenB) return -1; // A만 영업
      if (!isOpenA && isOpenB) return 1; // B만 영업
      return 0; // 둘 다 열려있거나 닫혀있음
    });

    //초기엔 모든 식당 보여짐.
    restaurantList.assignAll(sortedList);
    filteredList.assignAll(sortedList);
  }

  // 전화 걸기 기능
  Future<void> call(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(launchUri)) {
      throw '전화번호가 없습니다.';
    }
  }

  // 네이버 지도 연결 기능
  Future<void> navermap(String name) async {
    final Uri launchUri = Uri.parse('nmap://search?query=$name&appname=immersion_camp.week1.app.kaist_delivery');
    if (!await launchUrl(launchUri)) {
      throw '장소가 없습니다.';
    }
  }

  // 페이지 이동 관련
  void changeCategory(int index) {
    selectedCategoryIndex.value = index;
    pageController.jumpToPage(index);
    // 3번째 카테고리까지는 스와이프 되지 않고, 4번째부터 스와이프 되도록.
    double scrollPosition = index * 100.0;
    if (index >= 3) {
      scrollPosition = (index - 2) * 100.0;
    } else {
      scrollPosition = 0;
    }
    scrollController.animateTo(scrollPosition,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  // 검색 기능 구현
  void searchRestaurants(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(restaurantList); // 검색어가 없으면 전체 목록 표시
    } else {
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
