import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/app_colors.dart';
import '../../controller/tab3/search_controller.dart';
import '../tab1/widget/restaurant_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});

  final RestaurantSearchController controller =
      Get.put(RestaurantSearchController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // 검색창
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 25.sp),
            decoration: BoxDecoration(
              color: AppColors.searchBackgroundColor,
              border: Border.all(
                color: AppColors.searchIconColor,
                width: 1.5.sp,
              ),
              borderRadius: BorderRadius.circular(22.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // 그림자 색상과 투명도
                  spreadRadius: 0.5, // 그림자 확산 정도
                  blurRadius: 5, // 그림자 흐림 정도
                  offset: const Offset(0, 3), // 그림자의 위치 (x: 오른쪽, y: 아래쪽)
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 20.sp,
                      ),
                    ),
                    cursorColor: AppColors.searchIconColor,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // TODO : 해당 아이콘 버튼 안 눌러도 키보드에서 완료 누르면 검색되도록 기능 추가?
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: AppColors.searchIconColor,
                    size: 40.sp,
                  ),
                  onPressed: () {
                    controller.searchRestaurants(searchController.text);
                  },
                ),
              ],
            ),
          ),
          // 검색 결과 리스트
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredList.isEmpty) {
                return const Center(child: Text('검색 결과가 없습니다.'));
              }

              return ListView.builder(
                itemCount: controller.filteredList.length,
                itemBuilder: (context, index) {
                  final restaurant = controller.filteredList[index];
                  return RestaurantCard(
                    restaurant: restaurant,
                    onCall: (phoneNumber) {
                      // 전화 걸기 기능
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: phoneNumber,
                      );
                      try {
                        launchUrl(launchUri);
                      } catch (e) {
                        Get.snackbar('오류', '전화 연결 실패: $e');
                      }
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
