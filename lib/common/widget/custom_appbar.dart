import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// 왼쪽 아이콘 이미지 경로
  /// 기본값: 'assets/icon/main_icon.png'
  final String? leftIconPath;

  /// 왼쪽 아이콘 터치 시 동작
  /// 기본값: 없음
  final VoidCallback? onLeftIconTap;

  /// 가운데 제목
  /// 기본값: 없음
  /// 제공되지 않으면 보이지 않음
  final String? titleText;

  /// 가운데 임의의 위젯
  /// 기본값: 없음
  final Widget? centerWidget;

  /// 오른쪽 아이콘 이미지 경로
  /// 기본값: 없음
  /// 제공되지 않으면 보이지 않음
  final String? rightIconPath;

  /// 오른쪽 아이콘 터치 시 동작
  /// 기본값: 없음
  final VoidCallback? onRightIconTap;

  const CustomAppBar({
    super.key,
    this.leftIconPath,
    this.onLeftIconTap,
    this.titleText,
    this.centerWidget,
    this.rightIconPath,
    this.onRightIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.mainThemeColor,
      // 가운데 영역
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1-1. 왼쪽 아이콘 (기본 아이콘)
          GestureDetector(
            onTap: onLeftIconTap, // 1-2. 왼쪽 아이콘 터치 시 동작
            child: Image.asset(
              leftIconPath ?? 'assets/icon/main_icon.png',
              height: 32.sp,
              width: 32.sp,
            ),
          ),
          SizedBox(width: 8.sp),
          // 2-2. 가운데 위젯
          if (centerWidget != null)
            Expanded(
                child: Container(
                    padding: EdgeInsets.only(left: 15.sp),
                    alignment: Alignment.centerRight,
                    child: centerWidget!))
          // 2-1. 가운데 제목
          else if (titleText != null)
            Text(
              titleText!,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
      centerTitle: false,
      elevation: 0,
      // 3-1. 오른쪽 아이콘
      actions: [
        if (rightIconPath != null)
          GestureDetector(
            onTap: onRightIconTap, // 3-2. 오른쪽 아이콘 터치 시 동작
            child: Padding(
              padding: EdgeInsets.only(right: 10.sp),
              child: Image.asset(
                rightIconPath!,
                height: 32.sp,
                width: 32.sp,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
