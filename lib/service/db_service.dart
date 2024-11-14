import 'package:flutter/foundation.dart'; // Import for kIsWeb
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:path_provider/path_provider.dart'; // Only for mobile

class DatabaseService {
  Database? _db;
  final StoreRef<int, Map<String, dynamic>> _offlineStore = intMapStoreFactory.store('offlineMessages');
  final StoreRef<String, Map<String, dynamic>> _store = stringMapStoreFactory.store('app_data');

  DatabaseService() {
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    if (_db != null) return;

    if (kIsWeb) {
      var databaseFactory = databaseFactoryWeb;
      _db = await databaseFactory.openDatabase('app_db.db');
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final dbPath = '${directory.path}/app_db.db';
      var databaseFactory = databaseFactoryIo;
      _db = await databaseFactory.openDatabase(dbPath);
    }
  }

  Future<void> storeData(Map<String, dynamic> value) async {
    await _initializeDatabase();
    await _store.record('data').put(_db!, value);
  }

  Future<void> storeDummyData(String data) async {
    await _initializeDatabase();
    await _store.record('dummy').put(_db!, {"data": data});
  }

  // Store offline data with unique integer keys
  Future<void> storeOfflineData(String message) async {
    await _initializeDatabase();
    await _offlineStore.add(_db!, {'message': message});
  }

  // Retrieve all offline messages
  Future<List<String>> getAllMessages() async {
    await _initializeDatabase();
    final records = await _offlineStore.find(_db!);
    return records.map((record) => record.value['message'] as String).toList();
  }

  Future<void> deleteOfflineData() async {
    await _initializeDatabase();
    await _store.record('offlineMessages').delete(_db!);
  }
  Future<Map<String, dynamic>?> getDummyData() async {
    await _initializeDatabase();
    return await _store.record('dummy').get(_db!);
  }

  Future<void> deleteDummyData() async {
    await _initializeDatabase();
    await _store.record('dummy').delete(_db!);
    print("Successfully Deleted");
  }

  Future<void> getData(Map<String, dynamic> value) async {
    await _initializeDatabase();
    await _store.record('data').put(_db!, value);
  }

  Future<void> storeLastActiveTime(DateTime time) async {
    await _initializeDatabase();
    await _store.record('last_active').put(_db!, {'time': time.toIso8601String()});
  }

  Future<DateTime?> getLastActiveTime() async {
    await _initializeDatabase();
    final record = await _store.record('last_active').get(_db!);
    if (record != null && record['time'] != null) {
      return DateTime.parse(record['time'] as String);
    }
    return null;
  }

  Database get database => _db!;
}
