import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:halal_life/constants.dart';

class LocationSelectionBar extends StatelessWidget {
  const LocationSelectionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                const Text("📍", style: TextStyle(fontSize: 18)),
                Gap(8),
                const Text(
                  "Amsterdam, Hollanda",
                  style: TextStyle(fontWeight: FontWeight.w500, color: mint),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                // 🗺️ Harita butonuna basıldığında yapılacaklar
              },
              style: TextButton.styleFrom(
                backgroundColor: mint,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w500),
              ),
              child: const Text("🗺️ Harita"),
            ),
          ],
        ),
      ),
    );
  }
}
