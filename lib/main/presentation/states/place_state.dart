import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:halal_life/main/presentation/models/place_view_model.dart';

part 'place_state.freezed.dart';

@freezed
class PlaceState with _$PlaceState {
  const factory PlaceState.initial() = _Initial;
  const factory PlaceState.loading() = _Loading;
  const factory PlaceState.success({required List<PlaceViewModel> places}) =
      _Success;
  const factory PlaceState.error(String message) = _Error;
}
