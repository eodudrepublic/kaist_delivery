import 'package:flutter/material.dart';
import 'package:kaist_delivery/view/tab1/widget/restaurant_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../../common/widget/custom_appbar.dart';
import '../../controller/tab1/restaurant_controller.dart';

class RestaurantView extends StatelessWidget {
  RestaurantView({super.key});

  // HomeBinding에서 Get.lazyPut으로 초기화한 RestaurantController를 사용
  final RestaurantController controller = Get.find();

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

  // 영업 상태 확인 및 정렬 -> 영업 중인 가게가 먼저 오도록 정렬
  List<dynamic> _sortRestaurants(List<dynamic> restaurants) {
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
        if (!isOpenA && isOpenB) return 1; // B만 영업
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

        return ListView.builder(
          itemCount: sortedList.length,
          itemBuilder: (context, index) {
            final restaurant = sortedList[index];
            return RestaurantCard(
              restaurant: restaurant,
              onCall: _call,
            );
          },
        );
      }),
    );
  }
}
