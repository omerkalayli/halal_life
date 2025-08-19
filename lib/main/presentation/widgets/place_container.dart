import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:halal_life/constants.dart';

import 'package:halal_life/main/presentation/models/place_view_model.dart';
import 'package:halal_life/main/presentation/widgets/cloudflare_image.dart';
import 'package:halal_life/main/presentation/widgets/rating_stars.dart';

class PlaceContainer extends StatelessWidget {
  final PlaceViewModel place;

  const PlaceContainer({required this.place, super.key});

  @override
  Widget build(BuildContext context) {
    String typeName = "";
    String type = place.types[0].split(",")[0].replaceAll("[", "");
    if (type == "restaurant") {
      typeName = "Restaurant";
    } else if (type == "cafe") {
      typeName = "Cafe";
    } else if (type == "store" ||
        type == "supermarket" ||
        type == "grocery_or_supermarket") {
      typeName = "Store";
    } else if (type == "bakery") {
      typeName = "Bakery";
    } else {
      typeName = "Food Spot";
    }
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
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CloudFlareDiskCachedImage(
                placeId: place.placeId,
                photoReference: place.photoReference,
                type: place.types[0].split(",")[0].replaceAll("[", ""),
              ),
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
                      child: Text(
                        place.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: darkMint,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      place.isLiked
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: mint,
                    ),
                  ],
                ),
                Text(
                  "$typeName • ${(place.distance / 1000).toStringAsFixed(1).toString()} km",
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
                        color: place.isOpen
                            ? const Color.fromARGB(255, 201, 251, 215)
                            : Colors.red[100],
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
