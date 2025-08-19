class GooglePlaceModel {
  final Map<String, dynamic> photos;
  final String name;
  final double rating;
  final Map<String, dynamic> types;
  final bool isOpen;
  final String address;
  final double latitude;
  final double longitude;
  final String placeId;

  const GooglePlaceModel({
    required this.photos,
    required this.name,
    required this.rating,
    required this.types,
    required this.isOpen,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.placeId,
  });
}
