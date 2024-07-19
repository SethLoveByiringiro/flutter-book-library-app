import 'package:book_library_app/services/mobile_storage_service.dart';
import 'package:book_library_app/services/storage_service.dart';
import 'package:book_library_app/services/web_storage_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  late StorageService _storageService;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal() {
    _storageService = kIsWeb ? WebStorageService() : MobileStorageService();
  }

  StorageService get storageService => _storageService;
}
