import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:halal_life/constants.dart';
import 'package:halal_life/main/country_codes.dart';
import 'package:halal_life/main/data/models/city_info_model.dart';
import 'package:halal_life/main/presentation/models/place_view_model.dart';
import 'package:halal_life/main/presentation/notifiers/city_notifier.dart';
import 'package:halal_life/main/presentation/notifiers/place_notifier.dart';
import 'package:halal_life/main/presentation/widgets/cloudflare_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

class MainSearchBar extends HookConsumerWidget {
  const MainSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final asyncCities = useState<List<CityInfoModel>?>([]);
    final query = useState('');
    final _layerLink = useMemoized(() => LayerLink(), []);
    final overlayEntry = useState<OverlayEntry?>(null);
    Timer? debounceTimer;

    final placesSet = ref.watch(allPlacesProvider);
    final placesList = useMemoized(() => placesSet.toList(), [placesSet]);

    void hideOverlay() {
      overlayEntry.value?.remove();
      overlayEntry.value = null;
    }

    List<Widget> _buildResults() {
      if (asyncCities.value == null) {
        return [];
      }

      final filteredPlaces = placesList.where((place) {
        return place.name.toLowerCase().contains(query.value.toLowerCase()) ||
            place.cuisine.toLowerCase().contains(query.value.toLowerCase());
      }).toList();

      final combinedList = [
        ...?asyncCities.value?.take(3).map((c) => {'type': 'city', 'data': c}),
        ...filteredPlaces.take(10).map((p) => {'type': 'place', 'data': p}),
      ];

      if (combinedList.isEmpty) {
        return [const ListTile(title: Text("Sonuç bulunamadı"))];
      }

      return combinedList.map((item) {
        if (item['type'] == 'city') {
          final city = item['data'] as CityInfoModel;
          return ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(city.name),
            subtitle: Text(getCountryName(city.countryCode)),
            onTap: () {
              ref.read(userPositionProvider.notifier).state = LatLng(
                city.latitude,
                city.longitude,
              );
              searchController.clear();
              hideOverlay();
            },
          );
        } else {
          final place = item['data'] as PlaceViewModel;
          return ListTile(
            leading: CloudFlareDiskCachedImage(
              type: place.types[0].split(",")[0].replaceAll("[", ""),
              placeId: place.placeId,
              photoReference: place.photoReference,
            ),
            title: Text(place.name),
            subtitle: Text(place.cuisine),
            onTap: () {
              searchController.clear();
              hideOverlay();
            },
          );
        }
      }).toList();
    }

    void showOverlay() {
      hideOverlay();
      overlayEntry.value = OverlayEntry(
        builder: (context) => Positioned(
          width: MediaQuery.of(context).size.width - 32,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 48),
            child: Material(
              clipBehavior: Clip.antiAlias,
              color: Colors.blue,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final items = _buildResults();
                      return ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children: items,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(overlayEntry.value!);
    }

    void onSearchChanged() {
      debounceTimer?.cancel();
      final text = searchController.text;
      query.value = text;

      if (text.isEmpty) {
        asyncCities.value = [];
        hideOverlay();
        return;
      }

      debounceTimer = Timer(const Duration(milliseconds: 500), () async {
        asyncCities.value = null;
        final cityNotifier = ref.read(cityNotifierProvider.notifier);
        final cities = await cityNotifier.searchCity(text);
        asyncCities.value = cities;
        showOverlay();
      });
    }

    // Debounce listener
    useEffect(() {
      searchController.addListener(onSearchChanged);
      return () => searchController.removeListener(onSearchChanged);
    }, [searchController]);

    final focusNode = useFocusNode();
    final isFocused = useState(false);

    useEffect(() {
      void listener() => isFocused.value = focusNode.hasFocus;
      focusNode.addListener(listener);
      return () => focusNode.removeListener(listener);
    }, [focusNode]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: TextField(
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
            Future.delayed(const Duration(milliseconds: 300), () {
              hideOverlay();
            });
          },
          onEditingComplete: () {
            FocusManager.instance.primaryFocus?.unfocus();
            hideOverlay();
          },

          focusNode: focusNode,
          cursorColor: Colors.black,
          controller: searchController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: "Şehir, bölge veya işletme ara...",
            border: OutlineInputBorder(),
            filled: true,
            prefixIcon: asyncCities.value == null
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
    );
  }
}
