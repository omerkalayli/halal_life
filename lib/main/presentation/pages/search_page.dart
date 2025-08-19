import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:halal_life/constants.dart';
import 'package:halal_life/main/country_codes.dart';
import 'package:halal_life/main/data/models/city_info_model.dart';
import 'package:halal_life/main/location_helper.dart';
import 'package:halal_life/main/presentation/models/place_view_model.dart';
import 'package:halal_life/main/presentation/notifiers/city_notifier.dart';
import 'package:halal_life/main/presentation/notifiers/place_notifier.dart';
import 'package:halal_life/main/presentation/widgets/cloudflare_image.dart';
import 'package:halal_life/main/presentation/widgets/main_search_bar.dart';
import 'package:halal_life/main/presentation/widgets/multi_select_dropdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({this.initialFilter, super.key});

  final String? initialFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useSearchController();

    final placesSet = ref.watch(allPlacesProvider);
    final placesList = useMemoized(() => placesSet.toList(), [placesSet]);
    final List<String> placeTypeNames = [
      "Restaurant",
      "Cafe",
      "Store",
      "Bakery",
      "Food Spot",
    ];
    final selectedItems = useState<List<String>>([initialFilter ?? ""]);
    final isLoading = useState(false);
    final userPosition = useState<LatLng?>(ref.read(userPositionProvider));
    final query = useState('');
    final asyncCities = useState<List<CityInfoModel>?>([]);

    final listedPlaces = useState<List<PlaceViewModel>>([]);
    Timer? debounceTimer;

    List<Widget> _buildResults() {
      if (asyncCities.value == null) {
        return [];
      }

      final filteredPlaces = listedPlaces.value.where((place) {
        return place.name.toLowerCase().contains(query.value.toLowerCase()) ||
            place.cuisine.toLowerCase().contains(query.value.toLowerCase());
      }).toList();

      final combinedList = [
        ...?asyncCities.value?.take(3).map((c) => {'type': 'city', 'data': c}),
        ...filteredPlaces.take(100).map((p) => {'type': 'place', 'data': p}),
      ];

      if (combinedList.isEmpty) {
        return [const ListTile(title: Text("Sonuç bulunamadı"))];
      }

      return combinedList.map((item) {
        if (item['type'] == 'city') {
          final city = item['data'] as CityInfoModel;
          return Container(
            color: appBackgroundColor,
            child: ListTile(
              leading: const Icon(Icons.location_city),
              title: Text(city.name),
              subtitle: Text(getCountryName(city.countryCode)),
              onTap: () {
                ref.read(userPositionProvider.notifier).state = LatLng(
                  city.latitude,
                  city.longitude,
                );
                searchController.clear();
              },
            ),
          );
        } else {
          final place = item['data'] as PlaceViewModel;
          return Container(
            color: appBackgroundColor,
            child: ListTile(
              leading: CloudFlareDiskCachedImage(
                type: place.types[0].split(",")[0].replaceAll("[", ""),
                placeId: place.placeId,
                photoReference: place.photoReference,
              ),
              title: Text(place.name),
              subtitle: Text(place.cuisine),
              onTap: () {
                searchController.clear();
              },
            ),
          );
        }
      }).toList();
    }

    final items = useState<List<Widget>>([]);

    void onSearchChanged() {
      debounceTimer?.cancel();
      final text = searchController.text;
      query.value = text;

      if (text.isEmpty) {
        asyncCities.value = [];
        return;
      }

      debounceTimer = Timer(const Duration(milliseconds: 500), () async {
        asyncCities.value = null;
        final cityNotifier = ref.read(cityNotifierProvider.notifier);
        final cities = await cityNotifier.searchCity(text);
        asyncCities.value = cities;
        items.value = _buildResults();
      });
    }

    useEffect(() {
      searchController.addListener(onSearchChanged);
      return () {
        searchController.removeListener(onSearchChanged);
      };
    }, [searchController]);

    useEffect(() {
      onSearchChanged();
      return null;
    }, [listedPlaces.value]);

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

          // 🔹 sadece ilk 20’yi al
          listedPlaces.value = sortedPlaces.take(20).toList();

          // 🔹 ekranda direkt gözüksün
          items.value = _buildResults();
        }

        isLoading.value = false;
      });
      return null;
    }, [userPosition.value, placesList, selectedItems.value.hashCode]);

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: mainAppBarPadding.copyWith(
              top: MediaQuery.of(context).padding.top,
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: double.infinity,
            decoration: BoxDecoration(gradient: mainAppBarGradient),
            child: Stack(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                Center(
                  child: Text(
                    "Genel Arama",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(12),
            child: TextField(
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onEditingComplete: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },

              cursorColor: Colors.black,
              controller: searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintText: "Şehir, bölge veya işletme ara...",
                border: OutlineInputBorder(),
                filled: true,
                prefixIcon: asyncCities.value == null || isLoading.value
                    ? Container(
                        padding: EdgeInsets.all(12),
                        width: 12,
                        height: 12,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: mint,
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 24,
                        height: 24,
                        child: Center(
                          child: Icon(Icons.search, color: darkMint, size: 24),
                        ),
                      ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: lightMint, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: darkMint, width: 2),
                ),
                fillColor: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
              child: MultiSelectDropdown(
                items: placeTypeNames,
                selectedItems: selectedItems.value,
                onSelectionChanged: (val) {
                  selectedItems.value = List.from(val);
                },
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: items.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
