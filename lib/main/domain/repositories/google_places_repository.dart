import 'package:halal_life/main/data/datasources/google_places_remote.dart';
import 'package:halal_life/main/data/models/google_place_model.dart';
import 'package:halal_life/main/data/repository_impl/google_places_repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final googlePlacesRepositoryProvider = Provider<GooglePlacesRepository>((ref) {
  final dataSource = ref.watch(googlePlacesDataSourceProvider);
  return GooglePlacesRepositoryImpl(dataSource);
});

abstract interface class GooglePlacesRepository {
  Future<List<GooglePlaceModel>> getPlacesFromCoordinates(
    double latitude,
    double longitude,
    double radius,
  );

  Future<List<GooglePlaceModel>> getPlacesFromCityAndDistrict(
    String city,
    String district,
  );

  Future<String?> uploadGooglePhotoWorkflow(
    String photoReference,
    String placeId,
  );
}
