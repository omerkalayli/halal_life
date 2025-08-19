class CityInfoModel {
  final String geonameId;
  final String name;
  final String alternateNames;
  final double latitude;
  final double longitude;
  final String countryCode;

  CityInfoModel({
    required this.geonameId,
    required this.name,
    required this.alternateNames,
    required this.latitude,
    required this.longitude,
    required this.countryCode,
  });

  factory CityInfoModel.fromMap(Map<String, dynamic> map) {
    return CityInfoModel(
      geonameId: map['geoname_id'].toString(),
      name: map['name'],
      alternateNames: map['alternate_names'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      countryCode: map['country_code'],
    );
  }
}
