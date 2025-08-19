import 'package:halal_life/main/data/models/supabase_place_model.dart';
import 'package:halal_life/main/domain/repositories/google_places_repository.dart';
import 'package:halal_life/main/domain/repositories/supabase_db_repository.dart';
import 'package:halal_life/main/presentation/models/place_view_model.dart';
import 'package:halal_life/main/presentation/states/place_state.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'place_notifier.g.dart';

class PlacesNotifier extends StateNotifier<Set<PlaceViewModel>> {
  PlacesNotifier() : super({});

  void addPlace(PlaceViewModel place) {
    final newSet = {...state};
    newSet.add(place);
    state = newSet;
  }

  void addPlaces(List<PlaceViewModel> places) {
    final newSet = {...state};
    newSet.addAll(places);
    state = newSet;
  }

  void updatePlace(PlaceViewModel updatedPlace) {
    final newSet = state.map((p) {
      if (p.placeId == updatedPlace.placeId) {
        return updatedPlace;
      }
      return p;
    }).toSet(); // map() Iterable döndürdüğü için tekrar Set’e çeviriyoruz
    state = newSet;
  }

  void clear() {
    state = {};
  }
}

final double radius = 3000;

final userPositionProvider = StateProvider<LatLng?>((ref) {
  return null;
});

final allPlacesProvider =
    StateNotifierProvider<PlacesNotifier, Set<PlaceViewModel>>((ref) {
      return PlacesNotifier();
    });

final allCoordsProvider = StateProvider<List<LatLng?>>((ref) {
  return [];
});

@Riverpod(keepAlive: true)
class PlaceNotifier extends _$PlaceNotifier {
  late final GooglePlacesRepository _googlePlacesRepository;
  late final SupabaseDbRepository _supabaseDbRepository;

  @override
  Future<PlaceState> build() async {
    _googlePlacesRepository = ref.watch(googlePlacesRepositoryProvider);
    _supabaseDbRepository = ref.watch(supabaseRepositoryProvider);
    return const PlaceState.initial();
  }

  Future<List<PlaceViewModel>> fetchPlacesFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final center = LatLng(latitude, longitude);

      final isQueried = await _supabaseDbRepository.isCenterAlreadyQueried(
        center,
        radius / 2,
      );

      if (!isQueried) {
        await _supabaseDbRepository.insertQueryCenter(center, radius);
        ref.read(allCoordsProvider.notifier).update((state) {
          state.add(center);
          return state;
        });

        final googlePlaces = await _googlePlacesRepository
            .getPlacesFromCoordinates(latitude, longitude, radius);

        final List<PlaceViewModel> places = [];
        for (final place in googlePlaces) {
          final supabasePlace = SupabasePlaceModel.fromGooglePlace(place);
          PlaceViewModel placeViewModel = PlaceViewModel.fromModel(
            supabasePlace,
            ref.read(userPositionProvider),
          );

          ref.read(allPlacesProvider.notifier).addPlace(placeViewModel);
          await _supabaseDbRepository.addPlace(supabasePlace.toMap());

          final photoReference = place.photos["photos"]?[0]?["photo_reference"];
          if (photoReference != null) {
            uploadGooglePhotoWorkflow(photoReference, place.placeId).then((
              photoUrl,
            ) async {
              supabasePlace.setPhotoUrl(photoUrl);
              final updatedViewModel = PlaceViewModel.fromModel(
                supabasePlace,
                ref.read(userPositionProvider),
              );
              ref
                  .read(allPlacesProvider.notifier)
                  .updatePlace(updatedViewModel);
              Future.delayed(const Duration(seconds: 3), () async {
                await _supabaseDbRepository.updatePlace(supabasePlace);
              });
            });
          }
        }

        return places;
      }

      final supabasePlaces = await _supabaseDbRepository
          .getPlacesFromCoordinates(latitude, longitude, radius);

      final places = supabasePlaces
          .map(
            (s) => PlaceViewModel.fromModel(s, ref.read(userPositionProvider)),
          )
          .toList();

      ref.read(allPlacesProvider.notifier).addPlaces(places);

      return places;
    } catch (e, st) {
      print('fetchPlacesFromCoordinates error: $e\n$st');
      return [];
    }
  }

  Future<List<PlaceViewModel>> fetchPlacesFromCityAndDistrict(
    String city,
    String district,
  ) async {
    try {
      final supabasePlaces = await _supabaseDbRepository
          .getPlacesFromCityAndDistrict(city, district, radius);

      List<PlaceViewModel> places;

      if (supabasePlaces.isEmpty) {
        final googlePlaces = await _googlePlacesRepository
            .getPlacesFromCityAndDistrict(city, district);

        places = googlePlaces.map((place) {
          final supabasePlace = SupabasePlaceModel.fromGooglePlace(place);
          return PlaceViewModel.fromModel(
            supabasePlace,
            ref.read(userPositionProvider),
          );
        }).toList();

        List<Map<String, dynamic>> placesMap = googlePlaces
            .map((p) => SupabasePlaceModel.fromGooglePlace(p).toMap())
            .toList();

        await _supabaseDbRepository.addPlaces(placesMap);
      } else {
        places = supabasePlaces
            .map(
              (s) =>
                  PlaceViewModel.fromModel(s, ref.read(userPositionProvider)),
            )
            .toList();
      }

      ref.read(allPlacesProvider.notifier).addPlaces(places);

      return places;
    } catch (e) {
      return [];
    }
  }

  Future<List<PlaceViewModel>> fetchAllPlaces() async {
    try {
      final supabasePlaces = await _supabaseDbRepository.getAllPlaces();

      if (supabasePlaces.isEmpty) {
        return [];
      } else {
        List<PlaceViewModel> places = supabasePlaces
            .map(
              (s) =>
                  PlaceViewModel.fromModel(s, ref.read(userPositionProvider)),
            )
            .toList();

        ref.read(allPlacesProvider.notifier).addPlaces(places);

        return places;
      }
    } catch (e) {
      return [];
    }
  }

  Future<String?> uploadGooglePhotoWorkflow(
    String photoReference,
    String placeId,
  ) async {
    try {
      return await _googlePlacesRepository.uploadGooglePhotoWorkflow(
        photoReference,
        placeId,
      );
    } catch (e) {
      print('uploadGooglePhotoWorkflow error: $e');
      return null;
    }
  }
}
