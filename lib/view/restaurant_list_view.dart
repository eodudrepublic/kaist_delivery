import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/restaurant_controller.dart';

class RestaurantListView extends StatelessWidget {
  RestaurantListView({super.key});

  // GetX를 사용하여 컨트롤러 초기화
  final RestaurantController controller = Get.put(RestaurantController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('레스토랑 목록'),
      ),
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
            return ListTile(
              title: Text(restaurant.name),
              subtitle: Text(restaurant.address),
              trailing: Text(restaurant.phone),
            );
          },
        );
      }),
    );
  }
}
