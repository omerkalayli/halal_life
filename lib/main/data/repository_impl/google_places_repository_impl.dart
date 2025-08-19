import 'package:halal_life/main/data/datasources/google_places_remote.dart';
import 'package:halal_life/main/data/models/google_place_model.dart';
import 'package:halal_life/main/domain/repositories/google_places_repository.dart';

class GooglePlacesRepositoryImpl implements GooglePlacesRepository {
  final GooglePlacesDataSource? _dataSource;

  GooglePlacesRepositoryImpl(this._dataSource);

  T _checkDataSource<T>(T Function(GooglePlacesDataSource ds) action) {
    if (_dataSource == null) {
      throw Exception('DataSource is null');
    }
    return action(_dataSource);
  }

  @override
  Future<List<GooglePlaceModel>> getPlacesFromCoordinates(
    double latitude,
    double longitude,
    double radius,
  ) {
    return _checkDataSource(
      (ds) => ds.getPlacesFromCoordinates(latitude, longitude, radius),
    );
  }

  @override
  Future<List<GooglePlaceModel>> getPlacesFromCityAndDistrict(
    String city,
    String district,
  ) {
    return _checkDataSource(
      (ds) => ds.getPlacesFromCityAndDistrict(city, district),
    );
  }

  @override
  Future<String?> uploadGooglePhotoWorkflow(
    String photoReference,
    String placeId,
  ) {
    return _checkDataSource(
      (ds) => ds.uploadGooglePhotoWorkflow(photoReference, placeId),
    );
  }
}
