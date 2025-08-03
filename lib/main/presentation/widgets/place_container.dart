import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:halal_life/constants.dart';
import 'package:halal_life/main/presentation/models/place.dart';
import 'package:halal_life/main/presentation/widgets/rating_stars.dart';

class PlaceContainer extends StatelessWidget {
  final Place place;

  const PlaceContainer({required this.place, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              place.image,
              height: 90, // TODO: make this responsive.
              width: 90,
              fit: BoxFit.cover,
            ),
          ),
          Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      place.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: darkMint,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
                    Icon(
                      place.isLiked
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: mint,
                    ),
                  ],
                ),
                Text(
                  "${place.cuisine} • ${place.type} • ${place.distance.toString()} km",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: darkMint,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gap(4),
                RatingStars(rating: place.rating),
                Gap(4),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color:
                            place.isOpen
                                ? Colors.greenAccent.shade100
                                : Colors.redAccent.shade100,
                      ),
                      child: Center(
                        child: Text(
                          place.isOpen ? "Açık" : "Kapalı",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: place.isOpen ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ),
                    Gap(4),
                    Text(
                      "${place.closeTime.hour.toString().padLeft(2, '0')}:${place.closeTime.minute.toString().padLeft(2, '0')}'e kadar",
                      style: TextStyle(
                        color: mint,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Row(
                        children: [
                          Text(
                            place.likeCount.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: darkMint,
                            ),
                          ),
                          Gap(4),
                          Icon(
                            place.isLiked
                                ? Icons.thumb_up_rounded
                                : Icons.thumb_up_alt_outlined,
                            color: darkMint,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
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
