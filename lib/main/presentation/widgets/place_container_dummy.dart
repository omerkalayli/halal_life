import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PlaceContainerDummy extends StatelessWidget {
  const PlaceContainerDummy({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(height: 18, color: Colors.grey[300]),
                    ),
                    SizedBox(width: 8),
                    Container(width: 18, height: 18, color: Colors.grey[300]),
                  ],
                ),
                Gap(8),
                Container(height: 14, width: 120, color: Colors.grey[300]),
                Gap(4),
                Container(height: 14, width: 80, color: Colors.grey[300]),
                Gap(4),
                Row(
                  children: [
                    Container(height: 20, width: 60, color: Colors.grey[300]),
                    Spacer(),
                    Container(height: 14, width: 40, color: Colors.grey[300]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
