import 'package:halal_life/main/data/models/city_info_model.dart';
import 'package:halal_life/main/domain/repositories/city_info_repository.dart';
import 'package:halal_life/main/presentation/states/city_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'city_notifier.g.dart';

@Riverpod(keepAlive: true)
class CityNotifier extends _$CityNotifier {
  late final CityInfoRepository _cityInfoRepository;

  @override
  Future<CityState> build() async {
    _cityInfoRepository = ref.watch(cityInfoRepositoryProvider);
    return const CityState.initial();
  }

  Future<List<CityInfoModel>> searchCity(String query) async {
    try {
      final cities = await _cityInfoRepository.searchCity(query);
      return cities;
    } catch (e) {
      return [];
    }
  }

  Future<void> initDb() async {
    try {
      await _cityInfoRepository.initDb();
    } catch (e) {
      return;
    }
  }
}
