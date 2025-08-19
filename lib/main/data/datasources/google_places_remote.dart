import 'dart:convert';
import 'dart:typed_data';
import 'package:cloudflare_r2/cloudflare_r2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:halal_life/main/data/models/google_place_model.dart';

final googlePlacesDataSourceProvider = Provider<GooglePlacesDataSource>(
  (ref) => GooglePlacesRemote(),
);

final String googleApiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
final String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
final String supabaseKey = dotenv.env['SUPABASE_KEY'] ?? '';
final String cloudflareAccountId = dotenv.env['CLOUDFLARE_ACCOUNT_ID'] ?? '';
final String cloudflareJurisdiction = 'eu-west-1';
final String bucketName = dotenv.env['BUCKET_NAME'] ?? '';

abstract interface class GooglePlacesDataSource {
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

class GooglePlacesRemote implements GooglePlacesDataSource {
  Future<Uint8List> fetchGooglePhoto(
    String photoReference,
    String googleApiKey,
  ) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$googleApiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Google fotoğrafı alınamadı: ${response.statusCode}');
    }
  }

  // Upload to Cloudflare R2
  Future<void> uploadPhotoToR2(
    String bucketName,
    String objectName,
    Uint8List photoBytes,
  ) async {
    try {
      await CloudFlareR2.putObject(
        bucket: bucketName,
        objectName: objectName,
        objectBytes: photoBytes,
        contentType: 'image/jpeg',
      );
    } catch (e) {
      print('Cannot upload photo: $e');
    }
  }

  @override
  Future<String?> uploadGooglePhotoWorkflow(
    String photoReference,
    String placeId,
  ) async {
    try {
      final photoBytes = await fetchGooglePhoto(photoReference, googleApiKey);

      final objectName = '${placeId}_$photoReference.jpg';
      await uploadPhotoToR2(bucketName, objectName, photoBytes);

      final r2Url =
          'https://$cloudflareAccountId.$cloudflareJurisdiction.r2.cloudflarestorage.com/$bucketName/$objectName';

      return r2Url;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  @override
  Future<List<GooglePlaceModel>> getPlacesFromCoordinates(
    double latitude,
    double longitude,
    double radius,
  ) async {
    try {
      final List<GooglePlaceModel> allPlaces = [];
      String? nextPageToken;
      int attempt = 0;

      do {
        final query = 'halal restaurant, cafe, market';
        final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/textsearch/json'
          '?query=${Uri.encodeComponent(query)}'
          '&location=$latitude,$longitude'
          '&radius=$radius'
          '&key=$googleApiKey'
          '${nextPageToken != null ? '&pagetoken=$nextPageToken' : ''}',
        );

        final response = await http.get(url);
        if (response.statusCode != 200) {
          throw Exception(
            'Google API isteği başarısız: ${response.statusCode}',
          );
        }

        final data = json.decode(response.body);
        final results = data['results'] as List;
        nextPageToken = data['next_page_token'];

        allPlaces.addAll(
          results.map((place) {
            Map<String, dynamic> photos = {};
            if (place['photos'] != null && place['photos'].isNotEmpty) {
              photos = {'photos': place['photos']};
            }

            Map<String, dynamic> types = {};
            if (place['types'] != null && place['types'].isNotEmpty) {
              types = {'types': place['types']};
            }

            return GooglePlaceModel(
              placeId: place['place_id'],
              name: place['name'],
              address: place['formatted_address'],
              latitude: place['geometry']['location']['lat'],
              longitude: place['geometry']['location']['lng'],
              photos: photos,
              rating: place['rating']?.toDouble() ?? 0.0,
              types: types,
              isOpen: place['opening_hours']?['open_now'] ?? false,
            );
          }).toList(),
        );

        if (nextPageToken != null) {
          await Future.delayed(const Duration(seconds: 2));
        }

        attempt++;
      } while (nextPageToken != null && attempt < 3);

      return allPlaces;
    } catch (e) {
      print('Error while fetching places from Google API: $e');
      return [];
    }
  }

  @override
  Future<List<GooglePlaceModel>> getPlacesFromCityAndDistrict(
    String city,
    String district,
  ) async {
    try {
      final List<GooglePlaceModel> allPlaces = [];
      String? nextPageToken;
      int attempt = 0;

      do {
        final query = 'halal restaurant, cafe, market in $city, $district';
        final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/textsearch/json'
          '?query=${Uri.encodeComponent(query)}'
          '&key=$googleApiKey'
          '${nextPageToken != null ? '&pagetoken=$nextPageToken' : ''}',
        );

        final response = await http.get(url);
        if (response.statusCode != 200) {
          throw Exception('Google API request failed: ${response.statusCode}');
        }

        final data = json.decode(response.body);
        final results = data['results'] as List;
        nextPageToken = data['next_page_token'];

        allPlaces.addAll(
          results.map((place) {
            Map<String, dynamic> photos = {};
            if (place['photos'] != null && place['photos'].isNotEmpty) {
              photos = {'photos': place['photos']};
            }

            Map<String, dynamic> types = {};
            if (place['types'] != null && place['types'].isNotEmpty) {
              types = {'types': place['types']};
            }

            return GooglePlaceModel(
              placeId: place['place_id'],
              name: place['name'],
              address: place['formatted_address'],
              latitude: place['geometry']['location']['lat'],
              longitude: place['geometry']['location']['lng'],
              photos: photos,
              rating: place['rating']?.toDouble() ?? 0.0,
              types: types,
              isOpen: place['opening_hours']?['open_now'] ?? false,
            );
          }).toList(),
        );

        if (nextPageToken != null) {
          await Future.delayed(const Duration(seconds: 2));
        }

        attempt++;
      } while (nextPageToken != null && attempt < 3);

      return allPlaces;
    } catch (e) {
      print('Error while fetching places from Google API: $e');
      return [];
    }
  }
}
