import 'package:flutter/material.dart';
import 'package:kaist_delivery/view/tab1/widget/restaurant_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../../common/widget/custom_appbar.dart';
import '../../controller/tab1/restaurant_controller.dart';

class RestaurantView extends StatefulWidget {
  const RestaurantView({super.key});

  @override
  _RestaurantViewState createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
  // HomeBinding에서 Get.lazyPut으로 초기화한 RestaurantController를 사용
  final RestaurantController controller = Get.find();

  /// 스와이프해서 카테고리 이동
  PageController _pageController = PageController();
  ScrollController _scrollController = ScrollController();

  // 선택된 카테고리 인덱스 -> 0은 전체
  int _selectedCategoryIndex = 0;

  /// 카테고리별 필터링 함수
  List<Restaurant> _filterRestaurantsByCategory(List<Restaurant> restaurants) {
    if (_selectedCategoryIndex == 0) {
      return restaurants; // "전체" 카테고리일 경우 모든 식당을 보여줌
    }
    // 카테고리에 따라 필터링
    List<String> categories = [
      '', // "전체"
      '한식',
      '중식',
      '분식',
      '일식',
      '야식',
      '아시안',
    ];

    String selectedCategory = categories[_selectedCategoryIndex];

    return restaurants.where((restaurant) {
      return restaurant.category == selectedCategory; // 카테고리별 필터링
    }).toList();
  }

  //call 기능
  Future<void> _call(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    //print(launchUri);           //전화번호 맞는지 확인
    if (!await launchUrl(launchUri)) {
      throw '전화번호가 없습니다.';
    }
  }

  /// 영업 상태 확인 및 정렬 -> 영업 중인 가게가 먼저 오도록 정렬
  List<Restaurant> _sortRestaurants(List<dynamic> restaurants) {
    DateTime now = DateTime.now();

    return List.from(restaurants)
      ..sort((a, b) {
        // a의 영업 상태 계산
        DateTime openA = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(a.openTime.split(':')[0]),
          int.parse(a.openTime.split(':')[1]),
        );
        DateTime closeA = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(a.closeTime.split(':')[0]),
          int.parse(a.closeTime.split(':')[1]),
        );
        // close 시간이 다음날 새벽인 경우
        if (closeA.isBefore(openA)) {
          closeA = closeA.add(const Duration(days: 1));
        }

        bool isOpenA = now.isAfter(openA) && now.isBefore(closeA);

        // b의 영업 상태 계산
        DateTime openB = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(b.openTime.split(':')[0]),
          int.parse(b.openTime.split(':')[1]),
        );
        DateTime closeB = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(b.closeTime.split(':')[0]),
          int.parse(b.closeTime.split(':')[1]),
        );
        // close 시간이 다음날 새벽인 경우
        if (closeB.isBefore(openB)) {
          closeB = closeB.add(const Duration(days: 1));
        }

        bool isOpenB = now.isAfter(openB) && now.isBefore(closeB);

        // 정렬 기준
        if (isOpenA && !isOpenB) return -1; // A만 영업
        if (!isOpenA && isOpenB) return 1;  // B만 영업
        return 0; // 둘 다 열려있거나 닫혀있음
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        titleText: 'K-밥심',
        rightIconPath: 'assets/icon/search_icon.png',
        onRightIconTap: () {
          // TODO : Get.toNamed('/search');
          // tab1, tab2, tab3에서 모두 search 페이지로 넘어가도록
        },
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.restaurantList.isEmpty) {
          return const Center(child: Text('레스토랑이 없습니다.'));
        }

        // 레스토랑 리스트 정렬 -> 영업시간 아닌 식당은 아래에 위치하도록
        final sortedList = _sortRestaurants(controller.restaurantList);
        final filteredList = _filterRestaurantsByCategory(sortedList);

        return Column(
          children: [
            // 상단 카테고리
            Padding(
              padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // 수평 방향으로 스크롤되는 카테고리 버튼
                  controller: _scrollController,
                  child: Row(
                    children: [
                      _categoryButton('전체', 0),
                      _categoryButton('한식', 1),
                      _categoryButton('중식', 2),
                      _categoryButton('분식', 3),
                      _categoryButton('일식', 4),
                      _categoryButton('야식', 5),
                      _categoryButton('아시안', 6),
                    ],
                  ),
                ),
              ),

            // NotificationListener로 전체 화면에서 스와이프 감지
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    // 페이지를 스와이프 시 카테고리 인덱스 업데이트
                    int index = (_pageController.page ?? 0).round();
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  }
                  return true;
                },
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                    // 페이지 스와이프 시 상단 카테고리 바도 함께 이동
                    double scrollPosition = index * 100.w;
                    // 스크롤 위치를 3번째 버튼부터 시작하도록 설정
                    if (index >= 3) {
                      scrollPosition = (index-2)* 100.w; // 3번째 버튼을 고정
                    }
                    else{
                      scrollPosition=0;
                    }

                    _scrollController.animateTo(
                      scrollPosition, // 각 버튼의 너비에 맞춰 이동 (간격 조정)
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    );
                  },
                  children: [
                    _categoryPage('전체', filteredList),
                    _categoryPage('한식', filteredList),
                    _categoryPage('중식', filteredList),
                    _categoryPage('분식', filteredList),
                    _categoryPage('일식', filteredList),
                    _categoryPage('야식', filteredList),
                    _categoryPage('아시안', filteredList),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // 카테고리 페이지
  Widget _categoryPage(String category, List<Restaurant> filteredList) {
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final restaurant = filteredList[index];
        return RestaurantCard(
          restaurant: restaurant,
          onCall: _call,
        );
      },
    );
  }

  // 카테고리 버튼
  Widget _categoryButton(String category, int index) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategoryIndex = index;
            _pageController.jumpToPage(index); // 버튼을 눌렀을 때 PageView로 이동
            double scrollPosition = index * 100.w;
            // 3번째 버튼부터는 스크롤 위치가 고정되도록 처리
            if (index >= 3) {
              scrollPosition = (index-2)* 100.w;
            }
            else{
              scrollPosition =0;
            }
            _scrollController.animateTo(
              scrollPosition, // 각 버튼의 너비에 맞춰 이동 (간격 조정)
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _selectedCategoryIndex == index
                  ? Colors.black
                  : Colors.grey,
              width: 1,
            ),
            color: _selectedCategoryIndex == index
                ? AppColors.mainThemeColor
                : Colors.white,
          ),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 15,
              color: _selectedCategoryIndex == index
                  ? Colors.black
                  : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
