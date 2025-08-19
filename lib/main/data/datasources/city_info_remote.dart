import 'dart:io';
import 'package:cloudflare_r2/cloudflare_r2.dart';
import 'package:csv/csv.dart';
import 'package:halal_life/main/data/models/city_info_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final cityInfoDataSourceProvider = Provider<CityInfoDataSource>((ref) {
  return CityInfoRemoteDataSource();
});

abstract interface class CityInfoDataSource {
  Future<void> initDb();
  Future<List<CityInfoModel>> searchCity(String query);
}

class CityInfoRemoteDataSource implements CityInfoDataSource {
  late final Database db;

  @override
  Future<void> initDb() async {
    final dbPath = await getDatabasesPath();
    final dbFile = File('$dbPath/cities.db');

    db = await openDatabase(
      dbFile.path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE cities (
          geoname_id TEXT PRIMARY KEY,
          name TEXT,
          alternate_names TEXT,
          latitude REAL,
          longitude REAL,
          country_code TEXT
        )
      ''');
      },
    );

    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM cities',
    );
    final count = Sqflite.firstIntValue(countResult) ?? 0;

    if (count == 0) {
      final csvFile = await _getLocalCsvFile();

      if (!await csvFile.exists()) {
        await _downloadCsv(csvFile);
      }

      await _loadCsvToDb(csvFile);
    }
  }

  Future<File> _getLocalCsvFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/cities.csv');
  }

  Future<void> _downloadCsv(File file) async {
    final bytes = await CloudFlareR2.getObject(
      bucket: 'cities',
      objectName: 'all_cities.csv',
    );

    if (bytes.isEmpty) {
      throw Exception("Download failed: empty file from R2");
    }

    await file.writeAsBytes(bytes, flush: true);
  }

  Future<void> _loadCsvToDb(File file) async {
    try {
      final content = await file.readAsString();
      final rows = const CsvToListConverter(
        eol: '\n',
        fieldDelimiter: ',',
        shouldParseNumbers: false,
      ).convert(content);
      final batch = db.batch();

      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];
        batch.insert('cities', {
          'geoname_id': row[0].toString(),
          'name': row[1],
          'alternate_names': row[2],
          'latitude': row[3],
          'longitude': row[4],
          'country_code': row[5],
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception("Failed to load CSV to DB: $e");
    }
  }

  @override
  Future<List<CityInfoModel>> searchCity(String query) async {
    final results = await db.rawQuery(
      '''
    SELECT * FROM cities
    WHERE name LIKE ? OR alternate_names LIKE ?
    ORDER BY
      CASE
        WHEN name = ? THEN 0
        WHEN name LIKE ? THEN 1
        ELSE 2
      END,
      name ASC
  ''',
      ['%$query%', '%$query%', query, '$query%'],
    );

    return results.map((row) => CityInfoModel.fromMap(row)).toList();
  }
}
