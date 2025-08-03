import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:halal_life/constants.dart';

class CuisineListView extends StatelessWidget {
  const CuisineListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(' Dünya Mutfakları', style: mainHeaderStyle),
          ),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(bottom: 8),
              children: List.generate(worldCuisines.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            worldCuisines[index].flag,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const Gap(8),
                          Text(
                            worldCuisines[index].name,
                            style: const TextStyle(
                              fontSize: 14,
                              color: darkMint,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
