import 'package:freezed_annotation/freezed_annotation.dart';

part 'city_state.freezed.dart';

@freezed
class CityState with _$CityState {
  const factory CityState.initial() = _Initial;
  const factory CityState.loading() = _Loading;
  const factory CityState.success() = _Success;
  const factory CityState.error(String message) = _Error;
}
