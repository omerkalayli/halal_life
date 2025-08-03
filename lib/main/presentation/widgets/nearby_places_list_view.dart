import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:halal_life/constants.dart';
import 'package:halal_life/main/presentation/models/place.dart';
import 'package:halal_life/main/presentation/widgets/place_container.dart';

class NearbyPlacesListView extends StatelessWidget {
  const NearbyPlacesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(' Yakınındaki İşletmeler', style: mainHeaderStyle),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: lightMint.withValues(alpha: .3),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          Gap(2),
                          Text(
                            'Filtrele',
                            style: TextStyle(
                              color: darkMint,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Gap(2),
                          Icon(Icons.filter_alt, color: mint, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(16),
                PlaceContainer(
                  place: Place(
                    image:
                        'https://plus.unsplash.com/premium_photo-1664970900025-1e3099ca757a?q=80&w=1287&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    name: 'Cafe Mocha',
                    rating: 4.5,
                    cuisine: 'İtalyan',
                    distance: 1.2,
                    closeTime: DateTime.now().add(Duration(hours: 3)),
                    type: 'cafe',
                    isOpen: true,
                    isLiked: false,
                    likeCount: 128,
                  ),
                ),
              ],
            ),
          ),
        ),
        Gap(16),
      ],
    );
  }
}
