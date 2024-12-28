import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantCard extends StatelessWidget {
  final dynamic restaurant;
  final Function(String) onCall;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
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
            Row(
              children: [
                Icon(Icons.phone, size: 16.sp, color: Colors.grey),
                SizedBox(width: 5.w),
                Text(
                  restaurant.phone,
                  style: TextStyle(fontSize: 14.sp),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    onCall(restaurant.phone);
                  },
                  child: Text(
                    '전화연결',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ],
            ),
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
      ),
    );
  }
}
