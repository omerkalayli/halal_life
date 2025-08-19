import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:halal_life/main/location_helper.dart';
import 'package:halal_life/main/presentation/notifiers/place_notifier.dart';
import 'package:latlong2/latlong.dart';
import 'package:halal_life/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LocationSelectionBar extends HookConsumerWidget {
  LocationSelectionBar({super.key});

  final Distance distance = Distance();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = useMemoized(() => MapController());
    final isMapOpen = useState(false);
    final userPosition = ref.watch(userPositionProvider);
    final userAddress = useState<String>('Konum yükleniyor...');
    final debounceTimer = useState<Timer?>(null);
    final placesSet = ref.watch(allPlacesProvider);
    final placesList = useMemoized(() => placesSet.toList(), [placesSet]);
    final allCoords = ref.watch(allCoordsProvider);
    final lastQueryCenter = useState<LatLng?>(null);
    final animatedMarkers = useState<Set<String>>({});
    final previousPlacesList = useState<List<dynamic>>([]);
    final isLoading = useState(false);
    final isInitial = useState(true);

    useEffect(() {
      if (isMapOpen.value && userPosition != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Move işlemi
          mapController.move(userPosition, mapController.camera.zoom);

          // Async işlemleri ayrı fonksiyonda çalıştır
          () async {
            final center = userPosition;
            if (lastQueryCenter.value == null ||
                distance.as(LengthUnit.Meter, lastQueryCenter.value!, center) >
                    3000) {
              lastQueryCenter.value = center;
              isLoading.value = true;
              await ref
                  .read(placeNotifierProvider.notifier)
                  .fetchPlacesFromCoordinates(
                    center.latitude,
                    center.longitude,
                  );
              isLoading.value = false;
            }
          }();
        });
      }
      return null;
    }, [userPosition, isMapOpen.value]);

    // Kullanıcı konumu değiştiğinde adresi güncelle
    useEffect(() {
      if (userPosition != null) {
        if (!isInitial.value) {
          isMapOpen.value = true;
        }
        isInitial.value = false;
        final pos = latLngToPosition(userPosition);
        getAddressFromLatLng(pos).then((address) {
          userAddress.value = address;
        });
      }
      return null;
    }, [userPosition]);

    // İlk açılışta cihaz konumunu al
    useEffect(() {
      determinePosition(ref).then((pos) async {
        if (userPosition == null) {
          ref.read(userPositionProvider.notifier).state = LatLng(
            pos.latitude,
            pos.longitude,
          );
          final address = await getAddressFromLatLng(pos);
          userAddress.value = address;
        }
      });
      return null;
    }, []);

    // Yeni yerler için animasyonlu marker ekle
    useEffect(() {
      final oldList = previousPlacesList.value;
      final newList = placesList;

      for (var place in newList) {
        if (!oldList.contains(place)) {
          animatedMarkers.value = {...animatedMarkers.value, place.placeId};
          Future.delayed(const Duration(seconds: 2), () {
            animatedMarkers.value = {
              ...animatedMarkers.value..remove(place.placeId),
            };
          });
        }
      }

      previousPlacesList.value = List.from(newList);
      return null;
    }, [placesList]);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Text("📍", style: TextStyle(fontSize: 18)),
                    Gap(8),
                    Text(
                      userAddress.value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: mint,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    isMapOpen.value = !isMapOpen.value;
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 12,
                      top: 4,
                      bottom: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: mint,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isMapOpen.value ? Icons.close : Icons.map,
                          color: Colors.white,
                          size: 18,
                        ),
                        Gap(4),
                        Text(
                          isMapOpen.value ? "Kapat" : "Harita",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Gap(8),
            isMapOpen.value && userPosition != null
                ? SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: userPosition,
                        initialZoom: 13,
                        onMapReady: () {
                          // Harita render edildiğinde move işlemini güvenle çağır
                          if (userPosition != null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              mapController.move(
                                userPosition,
                                mapController.camera.zoom,
                              );
                            });
                          }
                        },
                        onPositionChanged: (position, hasGesture) {
                          if (!hasGesture) return;

                          debounceTimer.value?.cancel();
                          debounceTimer.value = Timer(
                            const Duration(milliseconds: 500),
                            () async {
                              final center = position.center;
                              if (lastQueryCenter.value == null ||
                                  distance.as(
                                        LengthUnit.Meter,
                                        lastQueryCenter.value!,
                                        center,
                                      ) >
                                      3000) {
                                lastQueryCenter.value = center;
                                isLoading.value = true;
                                await ref
                                    .read(placeNotifierProvider.notifier)
                                    .fetchPlacesFromCoordinates(
                                      center.latitude,
                                      center.longitude,
                                    );
                                isLoading.value = false;
                              }
                            },
                          );
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://cartodb-basemaps-{s}.global.ssl.fastly.net/rastertiles/voyager/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c', 'd'],
                          userAgentPackageName: 'com.example.halal_life',
                        ),
                        CircleLayer(
                          circles: [
                            ...allCoords.map((coord) {
                              return CircleMarker(
                                point: coord!,
                                color: Colors.blue.withValues(alpha: 0.3),
                                borderStrokeWidth: 2,
                                borderColor: Colors.blue,
                                radius: 3000,
                                useRadiusInMeter: true,
                              );
                            }),
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: userPosition,
                              width: isLoading.value ? 24 : 80,
                              height: isLoading.value ? 24 : 80,
                              child: isLoading.value
                                  ? CircularProgressIndicator()
                                  : const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                            ),
                            ...placesList.map((place) {
                              final isAnimated = animatedMarkers.value.contains(
                                place.placeId,
                              );

                              String type = place.types[0]
                                  .split(",")[0]
                                  .replaceAll("[", "");
                              IconData iconData = Icons.location_on;
                              if (type == "restaurant") {
                                iconData = Icons.restaurant_menu_rounded;
                              } else if (type == "cafe") {
                                iconData = Icons.local_cafe;
                              } else if (type == "store" ||
                                  type == "supermarket" ||
                                  type == "grocery_or_supermarket") {
                                iconData = Icons.store;
                              } else if (type == "bakery") {
                                iconData = Icons.bakery_dining;
                              } else {
                                iconData = Icons.place;
                              }
                              return Marker(
                                point: LatLng(place.latitude, place.longitude),
                                width: 40,
                                height: 40,
                                child: AnimatedOpacity(
                                  opacity: isAnimated ? 1.0 : 1.0,
                                  duration: const Duration(milliseconds: 500),
                                  child: AnimatedScale(
                                    scale: isAnimated ? 0.0 : 1.0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOutBack,
                                    child: Icon(
                                      iconData,
                                      color: Colors.blue,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
