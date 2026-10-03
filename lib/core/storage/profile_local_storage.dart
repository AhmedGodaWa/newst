import 'package:hive_flutter/hive_flutter.dart';

class ProfileLocalStorage {
  static const String _boxName = 'profile_box';
  static const String _imagePathKey = 'profile_image_path';
  static const String _countryKey = 'country';

  Future<Box> _openBox() {
    return Hive.openBox(_boxName);
  }

  Future<void> saveImagePath(String path) async {
    final box = await _openBox();
    await box.put(_imagePathKey, path);
  }

  Future<String?> getImagePath() async {
    final box = await _openBox();
    return box.get(_imagePathKey) as String?;
  }

  Future<void> clearImagePath() async {
    final box = await _openBox();
    await box.delete(_imagePathKey);
  }

  Future<void> saveCountry(String country) async {
    final box = await _openBox();
    await box.put(_countryKey, country);
  }

  Future<String?> getCountry() async {
    final box = await _openBox();
    return box.get(_countryKey) as String?;
  }

  Future<void> clearCountry() async {
    final box = await _openBox();
    await box.delete(_countryKey);
  }
}
