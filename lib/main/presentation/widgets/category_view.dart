import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:halal_life/constants.dart';
import 'package:halal_life/main/presentation/models/place_view_model.dart';
import 'package:halal_life/main/presentation/notifiers/place_notifier.dart';
import 'package:halal_life/main/presentation/pages/search_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryView extends HookConsumerWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placesSet = ref.read(allPlacesProvider);
    final placesList = useMemoized(() => placesSet.toList(), [placesSet]);
    final categorizedPlaces = useMemoized(() {
      List<PlaceViewModel> restaurants = [];
      List<PlaceViewModel> cafes = [];
      List<PlaceViewModel> stores = [];
      List<PlaceViewModel> bakeries = [];
      List<PlaceViewModel> others = [];

      for (var pl in placesList) {
        String type = pl.types[0].split(",")[0].replaceAll("[", "");
        if (type == "restaurant") {
          restaurants.add(pl);
        } else if (type == "cafe") {
          cafes.add(pl);
        } else if (type == "store" ||
            type == "supermarket" ||
            type == "grocery_or_supermarket") {
          stores.add(pl);
        } else if (type == "bakery") {
          bakeries.add(pl);
        } else {
          others.add(pl);
        }
      }

      return {
        "restaurants": restaurants,
        "cafes": cafes,
        "stores": stores,
        "bakeries": bakeries,
        "others": others,
      };
    }, [placesList]);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(' Kategoriler', style: mainHeaderStyle),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _CategoryButton(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SearchPage(initialFilter: "Restaurant"),
                      ),
                    ),
                    icon: '🍽️',
                    label: 'Restoranlar',
                    count: categorizedPlaces['restaurants']?.length ?? 0,
                  ),
                  _CategoryButton(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SearchPage(initialFilter: "Cafe"),
                      ),
                    ),
                    icon: '☕',
                    label: 'Kafeler',
                    count: categorizedPlaces['cafes']?.length ?? 0,
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _CategoryButton(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SearchPage(initialFilter: "Store"),
                      ),
                    ),
                    icon: '🛒',
                    label: 'Marketler',
                    count: categorizedPlaces['stores']?.length ?? 0,
                  ),
                  _CategoryButton(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SearchPage(initialFilter: "Bakery"),
                      ),
                    ),
                    icon: '🥖',
                    label: 'Fırınlar',
                    count: categorizedPlaces['bakeries']?.length ?? 0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String icon;
  final String label;
  final int count;
  final Function onTap;

  const _CategoryButton({
    required this.icon,
    required this.label,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => onTap.call(),
        child: AspectRatio(
          aspectRatio: 1.5,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: BoxConstraints(minWidth: 80),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(icon, style: TextStyle(fontSize: 32)),
                  Gap(4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: mint,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "$count işletme",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: darkMint,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
