import 'package:halal_life/main/data/datasources/supabase_db_remote.dart';
import 'package:halal_life/main/data/models/supabase_place_model.dart';
import 'package:halal_life/main/data/repository_impl/supabase_db_repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

final supabaseRepositoryProvider = Provider<SupabaseDbRepository>((ref) {
  final dataSource = ref.watch(supabaseDataSourceProvider);
  return SupabaseDbRepositoryImpl(dataSource);
});

abstract interface class SupabaseDbRepository {
  Future<SupabasePlaceModel?> getPlaceById(String id);
  Future<void> addPlaces(List<Map<String, dynamic>> places);
  Future<void> addPlace(Map<String, dynamic> place);
  Future<void> updatePlace(SupabasePlaceModel place);
  Future<void> deletePlace(String id);
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
  Future<List<SupabasePlaceModel>> getAllPlaces();
  Future<bool> isCenterAlreadyQueried(LatLng center, double radius);
  Future<void> insertQueryCenter(LatLng center, double radius);
}
