import 'package:halal_life/main/data/models/google_place_model.dart';

class SupabasePlaceModel {
  String? photoUrl;
  final String name;
  final double rating;
  final Map<String, dynamic> types;
  final bool isOpen;
  final String address;
  final double latitude;
  final double longitude;
  final String city;
  final String placeId;
  final String photoReference;

  SupabasePlaceModel({
    required this.name,
    required this.rating,
    required this.types,
    required this.isOpen,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.placeId,
    required this.photoReference,
    this.photoUrl,
  });

  factory SupabasePlaceModel.fromJson(Map<String, dynamic> json) {
    return SupabasePlaceModel(
      photoUrl: json['photo_url'] ?? '',
      name: json['name'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      types: json['types'] ?? {},
      isOpen: json['is_open'] ?? false,
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      city: json['city'] ?? '',
      placeId: json['id'] ?? '',
      photoReference: json['photo_reference'] ?? '',
    );
  }

  factory SupabasePlaceModel.fromGooglePlace(GooglePlaceModel model) {
    List<String> parts = model.address.split(',');
    String photoReference = model.photos.isNotEmpty
        ? model.photos["photos"][0]["photo_reference"]
        : '';
    parts = parts.map((e) => e.trim()).toList();

    String city = parts.length > 1 ? parts[parts.length - 2] : '';

    return SupabasePlaceModel(
      photoUrl: null,
      name: model.name,
      rating: model.rating,
      types: model.types,
      isOpen: model.isOpen,
      address: model.address,
      latitude: model.latitude,
      longitude: model.longitude,
      city: city,
      placeId: model.placeId,
      photoReference: photoReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'photo_url': photoUrl,
      'name': name,
      'rating': rating,
      'types': types,
      'is_open': isOpen,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'id': placeId,
      'photo_reference': photoReference,
    };
  }

  void setPhotoUrl(String? url) {
    photoUrl = url;
  }
}
