import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../../controller/tab1/restaurant_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantListView extends StatelessWidget {
  RestaurantListView({super.key});

  // GetX를 사용하여 컨트롤러 초기화
  final RestaurantController controller = Get.put(RestaurantController());

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.restaurantList.isEmpty) {
          return const Center(child: Text('레스토랑이 없습니다.'));
        }

        return ListView.builder(
          itemCount: controller.restaurantList.length,
          itemBuilder: (context, index) {
            final restaurant = controller.restaurantList[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              child: ListTile(
                leading: Image.asset(
                  'assets/image/' + restaurant.name + '.jpg',
                  width: 80.w,
                  height: 80.h,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  restaurant.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 16.sp, color: Colors.grey),
                        SizedBox(width: 5.w),
                        Text(
                          restaurant.phone,
                          style: TextStyle(fontSize: 14.sp),
                        ), //전화 번호 표시

                        Spacer(),
                        TextButton(
                          onPressed: () {
                            _call(restaurant.phone);
                          },
                          child: Text(
                            '전화연결',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ) //전화 연결 버튼
                      ],
                    ),
                    //SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16.sp, color: Colors.grey),
                        SizedBox(width: 5.w),
                        Text(
                          '${restaurant.openTime} - ${restaurant.closeTime}',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                // trailing: Text(restaurant.phone), // 기존 전화번호 표시 제거
              ),
            );
          },
        );
      }),
    );
  }
}
