import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:halal_life/constants.dart';
import 'package:halal_life/main/location_helper.dart';
import 'package:halal_life/main/presentation/models/place_view_model.dart';
import 'package:halal_life/main/presentation/notifiers/place_notifier.dart';
import 'package:halal_life/main/presentation/widgets/multi_select_dropdown.dart';
import 'package:halal_life/main/presentation/widgets/place_container.dart';
import 'package:halal_life/main/presentation/widgets/place_container_dummy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NearbyPlacesListView extends HookConsumerWidget {
  const NearbyPlacesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placesSet = ref.read(allPlacesProvider);
    final placesList = useMemoized(() => placesSet.toList(), [placesSet]);
    final nearbyPlacesList = useState<List<PlaceViewModel>>([]);
    final userPosition = useState<LatLng?>(ref.read(userPositionProvider));
    final List<String> placeTypeNames = [
      "Restaurant",
      "Cafe",
      "Store",
      "Bakery",
      "Food Spot",
    ];
    final selectedItems = useState<List<String>>(["All", ...placeTypeNames]);
    final isLoading = useState(false);
    useEffect(() {
      isLoading.value = true;
      Future.microtask(() async {
        userPosition.value = await getLocation();

        if (userPosition.value != null) {
          final List<PlaceViewModel> sortedPlaces = List.from(
            placesList.where((pl) {
              String type = pl.types[0].split(",")[0].replaceAll("[", "");
              String typeName = "";
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

              return selectedItems.value.contains(typeName);
            }),
          );
          sortedPlaces.sort((a, b) {
            final distanceA = Distance().as(
              LengthUnit.Meter,
              userPosition.value!,
              LatLng(a.latitude, a.longitude),
            );
            final distanceB = Distance().as(
              LengthUnit.Meter,
              userPosition.value!,
              LatLng(b.latitude, b.longitude),
            );
            return distanceA.compareTo(distanceB);
          });

          nearbyPlacesList.value = sortedPlaces.take(10).toList();
        }
        isLoading.value = false;
      });
      return null;
    }, [userPosition.value, placesList, selectedItems.value.hashCode]);

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
                    MultiSelectDropdown(
                      items: placeTypeNames,
                      selectedItems: selectedItems.value,
                      onSelectionChanged: (val) {
                        selectedItems.value = List.from(val);
                      },
                    ),
                  ],
                ),
                Gap(16),
                isLoading.value
                    ? Skeletonizer(
                        child: Column(
                          children: [
                            ...List.generate(10, (index) {
                              return PlaceContainerDummy();
                            }),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          ...List.generate(nearbyPlacesList.value.length, (
                            index,
                          ) {
                            final place = nearbyPlacesList.value[index];
                            place.distance = Distance().as(
                              LengthUnit.Meter,
                              userPosition.value!,
                              LatLng(place.latitude, place.longitude),
                            );
                            return PlaceContainer(place: place);
                          }),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
