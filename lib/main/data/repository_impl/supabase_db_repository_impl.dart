import 'package:halal_life/main/data/datasources/supabase_db_remote.dart';
import 'package:halal_life/main/data/models/supabase_place_model.dart';
import 'package:halal_life/main/domain/repositories/supabase_db_repository.dart';
import 'package:latlong2/latlong.dart';

class SupabaseDbRepositoryImpl implements SupabaseDbRepository {
  final SupabaseDataSource? _dataSource;

  SupabaseDbRepositoryImpl(this._dataSource);

  // Yardımcı fonksiyon
  T _withDataSource<T>(T Function(SupabaseDataSource ds) action) {
    if (_dataSource == null) {
      throw Exception('DataSource is null');
    }
    return action(_dataSource);
  }

  @override
  Future<SupabasePlaceModel?> getPlaceById(String id) {
    return _withDataSource((ds) => ds.getPlaceById(id));
  }

  @override
  Future<void> addPlaces(List<Map<String, dynamic>> places) {
    return _withDataSource((ds) => ds.addPlaces(places));
  }

  @override
  Future<void> updatePlace(SupabasePlaceModel place) {
    return _withDataSource((ds) => ds.updatePlace(place));
  }

  @override
  Future<void> deletePlace(String id) {
    return _withDataSource((ds) => ds.deletePlace(id));
  }

  @override
  Future<List<SupabasePlaceModel>> getPlacesFromCoordinates(
    double latitude,
    double longitude,
    double radius,
  ) {
    return _withDataSource(
      (ds) => ds.getPlacesFromCoordinates(latitude, longitude, radius),
    );
  }

  @override
  Future<List<SupabasePlaceModel>> getPlacesFromCityAndDistrict(
    String city,
    String district,
    double radius,
  ) {
    return _withDataSource(
      (ds) => ds.getPlacesFromCityAndDistrict(city, district, radius),
    );
  }

  @override
  Future<List<SupabasePlaceModel>> getAllPlaces() {
    return _withDataSource((ds) => ds.getAllPlaces());
  }

  @override
  Future<bool> isCenterAlreadyQueried(LatLng center, double radius) {
    return _withDataSource((ds) => ds.isCenterAlreadyQueried(center, radius));
  }

  @override
  Future<void> insertQueryCenter(LatLng center, double radius) {
    return _withDataSource((ds) => ds.insertQueryCenter(center, radius));
  }

  @override
  Future<void> addPlace(Map<String, dynamic> place) {
    return _withDataSource((ds) => ds.addPlace(place));
  }
}
