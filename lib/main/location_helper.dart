import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:halal_life/main/presentation/notifiers/place_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

Position latLngToPosition(LatLng latLng) {
  return Position(
    latitude: latLng.latitude,
    longitude: latLng.longitude,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    headingAccuracy: 0.0,
    altitudeAccuracy: 0.0,
  );
}

Future<LatLng> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Konum servisleri kapalı.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Konum izinleri reddedildi.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Konum izinleri kalıcı olarak reddedildi.');
  }

  Position position = await Geolocator.getCurrentPosition();

  return LatLng(position.latitude, position.longitude);
}

Future<Position> determinePosition(WidgetRef ref) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Konum servisleri kapalı.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Konum izinleri reddedildi.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Konum izinleri kalıcı olarak reddedildi.');
  }

  Position position = await Geolocator.getCurrentPosition();

  ref.read(userPositionProvider.notifier).state = LatLng(
    position.latitude,
    position.longitude,
  );

  return position;
}

Future<String> getAddressFromLatLng(Position position) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      if (place.locality?.isEmpty ?? true) {
        return '${place.administrativeArea}, ${place.country}';
      }
      return '${place.locality}, ${place.country}';
    }
  } catch (e) {
    print(e);
  }
  return 'Bilinmeyen Konum';
}
