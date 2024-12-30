import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaist_delivery/common/widget/custom_appbar.dart';
import '../../controller/tab3/pick_controller.dart';

class PickView extends StatelessWidget {
  const PickView({super.key});

  @override
  Widget build(BuildContext context) {
    final PickController controller = Get.put(PickController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        titleText: '오늘의 Pick',
        rightIconPath: 'assets/icon/search_icon.png',
        onRightIconTap: () {
          // TODO : Get.toNamed('/search');
          // tab1, tab2, tab3에서 모두 search 페이지로 넘어가도록
        },
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 상단 설명
              Text(
                '나의 Pick 리스트에서 랜덤으로\n오늘의 메뉴를 추천해드립니다:D',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // "메뉴 추천 받기" 버튼
              ElevatedButton(
                onPressed: () => controller.getRandomPick(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  minimumSize: const Size(150, 50),
                ),
                child: const Text('메뉴 추천 받기'),
              ),
              const SizedBox(height: 24),

              // 오늘의 Pick 표시
              const Text(
                '오늘의 Pick은 ~??',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // 추천된 메뉴가 없으면 안내 문구, 있으면 해당 메뉴 이름
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                color: Colors.amber,
                child: Text(
                  controller.selectedPick.value.isNotEmpty
                      ? controller.selectedPick.value
                      : '여기에 추천 메뉴가 표시됩니다.',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // "나의 Pick" 헤더
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '나의 Pick',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 리스트 영역
              Expanded(
                child: ListView.builder(
                  itemCount: controller.pickList.length,
                  itemBuilder: (context, index) {
                    final pick = controller.pickList[index];
                    return Container(
                      color: Colors.grey.shade300,
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        pick.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
