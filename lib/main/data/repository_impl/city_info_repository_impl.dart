import 'package:halal_life/main/data/datasources/city_info_remote.dart';
import 'package:halal_life/main/data/models/city_info_model.dart';
import 'package:halal_life/main/domain/repositories/city_info_repository.dart';

class CityInfoRepositoryImpl implements CityInfoRepository {
  final CityInfoDataSource dataSource;

  CityInfoRepositoryImpl(this.dataSource);

  @override
  Future<void> initDb() async {
    await dataSource.initDb();
  }

  @override
  Future<List<CityInfoModel>> searchCity(String query) async {
    return await dataSource.searchCity(query);
  }
}
