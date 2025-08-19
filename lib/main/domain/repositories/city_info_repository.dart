import 'package:halal_life/main/data/datasources/city_info_remote.dart';
import 'package:halal_life/main/data/models/city_info_model.dart';
import 'package:halal_life/main/data/repository_impl/city_info_repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final cityInfoRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(cityInfoDataSourceProvider);
  return CityInfoRepositoryImpl(dataSource);
});

abstract interface class CityInfoRepository {
  Future<void> initDb();
  Future<List<CityInfoModel>> searchCity(String query);
}
