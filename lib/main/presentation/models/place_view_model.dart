import 'package:latlong2/latlong.dart';
import 'package:halal_life/main/data/models/supabase_place_model.dart';

class PlaceViewModel {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? photoUrl;
  final double rating;
  final String cuisine;
  double distance;
  final DateTime? closeTime;
  final List<String> types;
  final bool isOpen;
  final bool isLiked;
  final int likeCount;
  final String city;
  final String placeId;
  final String photoReference;

  PlaceViewModel({
    required this.name,
    required this.address,
    required this.latitude,
    required this.placeId,
    required this.longitude,
    required this.photoUrl,
    this.rating = 0.0,
    this.cuisine = '',
    this.distance = 0.0,
    this.closeTime,
    this.types = const [],
    this.isOpen = false,
    this.isLiked = false,
    this.likeCount = 0,
    this.photoReference = '',
    this.city = '',
  });

  factory PlaceViewModel.fromModel(
    SupabasePlaceModel model,
    LatLng? userPosition,
  ) {
    final types = model.types.isNotEmpty
        ? model.types.values.map((type) => type.toString()).toList()
        : [];

    double calculatedDistance = 0.0;
    if (userPosition != null) {
      final distanceCalc = Distance();
      calculatedDistance = distanceCalc.as(
        LengthUnit.Meter,
        userPosition,
        LatLng(model.latitude, model.longitude),
      );
    }

    return PlaceViewModel(
      placeId: model.placeId,
      name: model.name,
      address: model.address,
      latitude: model.latitude,
      longitude: model.longitude,
      rating: model.rating,
      photoUrl: model.photoUrl,
      distance: calculatedDistance,
      types: types.cast<String>(),
      isOpen: model.isOpen,
      isLiked: false,
      likeCount: 0,
      city: model.city,
      photoReference: model.photoReference,
    );
  }
}
