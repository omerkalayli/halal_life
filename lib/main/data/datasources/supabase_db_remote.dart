import 'package:halal_life/main/data/models/supabase_place_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geocoding/geocoding.dart';

final supabaseDataSourceProvider = Provider<SupabaseDataSource>((ref) {
  return SupabaseDbRemote();
});

abstract interface class SupabaseDataSource {
  Future<SupabasePlaceModel?> getPlaceById(String id);
  Future<void> addPlaces(List<Map<String, dynamic>> places);
  Future<void> addPlace(Map<String, dynamic> place);
  Future<void> updatePlace(SupabasePlaceModel place);
  Future<void> deletePlace(String id);
  Future<List<SupabasePlaceModel>> getAllPlaces();
  Future<List<SupabasePlaceModel>> getPlacesFromCoordinates(
    double latitude,
    double longitude,
    double radius,
  );
  Future<List<SupabasePlaceModel>> getPlacesFromCityAndDistrict(
    String city,
    String district,
    double radius,
  );
  Future<bool> isCenterAlreadyQueried(LatLng center, double minDistance);
  Future<void> insertQueryCenter(LatLng center, double radius);
}

class SupabaseDbRemote implements SupabaseDataSource {
  @override
  Future<SupabasePlaceModel?> getPlaceById(String id) async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('places')
          .select()
          .eq('id', id)
          .single();

      return SupabasePlaceModel.fromJson(response);
    } catch (e) {
      print('Error while fetching place by ID from supabase: $e');
      return null;
    }
  }

  @override
  Future<void> addPlaces(List<Map<String, dynamic>> places) async {
    try {
      final supabase = Supabase.instance.client;

      await supabase.from('places').insert(places);
    } catch (e) {
      print('Error while adding a place to supabase: $e');
    }
  }

  @override
  Future<void> updatePlace(SupabasePlaceModel place) async {
    try {
      final supabase = Supabase.instance.client;
      await supabase
          .from('places')
          .update({
            'name': place.name,
            'address': place.address,
            'latitude': place.latitude,
            'longitude': place.longitude,
            'city': place.city,
            'photo_url': place.photoUrl,
            'rating': place.rating,
            'types': place.types,
            'is_open': place.isOpen,
            'photo_reference': place.photoReference,
          })
          .eq('id', place.placeId)
          .select();
    } catch (e) {
      print('Error while updating a place in supabase: $e');
    }
  }

  @override
  Future<void> deletePlace(String id) async {
    try {
      final supabase = Supabase.instance.client;

      await supabase.from('places').delete().eq('id', id);
    } catch (e) {
      print('Error while deleting a place from supabase: $e');
    }
  }

  @override
  Future<bool> isCenterAlreadyQueried(
    LatLng center,
    double checkRadiusMeters,
  ) async {
    final supabase = Supabase.instance.client;

    final response = await supabase.from('query_centers').select();

    final Distance distance = Distance();
    final currentCenter = LatLng(center.latitude, center.longitude);

    for (final row in response) {
      final centerLat = (row['latitude'] as num).toDouble();
      final centerLng = (row['longitude'] as num).toDouble();
      final centerPoint = LatLng(centerLat, centerLng);

      final meters = distance(currentCenter, centerPoint);

      if (meters <= checkRadiusMeters) {
        return true;
      }
    }

    return false;
  }

  @override
  Future<void> insertQueryCenter(LatLng center, double radius) async {
    final supabase = Supabase.instance.client;

    await supabase.from('query_centers').insert({
      'latitude': center.latitude,
      'longitude': center.longitude,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<List<SupabasePlaceModel>> getPlacesFromCoordinates(
    double latitude,
    double longitude,
    double radius,
  ) async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('places')
          .select()
          .order('created_at', ascending: false);

      final Distance distance = Distance();
      final userLocation = LatLng(latitude, longitude);

      return List<Map<String, dynamic>>.from(
        response,
      ).map((json) => SupabasePlaceModel.fromJson(json)).where((place) {
        final placeLocation = LatLng(place.latitude, place.longitude);
        final meters = distance(userLocation, placeLocation);
        return meters <= radius;
      }).toList();
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  @override
  Future<List<SupabasePlaceModel>> getPlacesFromCityAndDistrict(
    String city,
    String district,
    double radius,
  ) async {
    try {
      List<Location> locations = await locationFromAddress('$district, $city');

      LatLng? location;

      if (locations.isNotEmpty) {
        final loc = locations.first;
        location = LatLng(loc.latitude, loc.longitude);
      }
      return await getPlacesFromCoordinates(
        location?.latitude ?? 0.0,
        location?.longitude ?? 0.0,
        radius,
      );
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  @override
  Future<List<SupabasePlaceModel>> getAllPlaces() async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('places')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map(
            (item) => SupabasePlaceModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  @override
  Future<void> addPlace(Map<String, dynamic> place) async {
    try {
      final supabase = Supabase.instance.client;

      await supabase.from('places').insert(place);
    } catch (e) {
      print('Error while adding a place to supabase: $e');
    }
  }
}
