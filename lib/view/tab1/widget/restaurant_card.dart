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
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: ListTile(
        tileColor: Colors.white,
        leading: ClipRRect(
          child: Container(
            width: 0.2.sw, height: 0.2.sw,
            child: Image.asset(
              'assets/image/' + restaurant.name + '.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          restaurant.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0.01.sh,),
                Row(
                  children: [
                    Icon(Icons.phone, size: 16.sp, color: Colors.grey),
                    SizedBox(width: 5.w),
                    Text(
                      restaurant.phone,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 0.01.sh,),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16.sp, color: Colors.grey),
                    Text(
                      '${restaurant.openTime} - ${restaurant.closeTime}',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
              ],
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
      ),
    );
  }
}
