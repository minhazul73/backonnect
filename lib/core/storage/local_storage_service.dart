import 'package:get_storage/get_storage.dart';

class LocalStorageService {
  final GetStorage _box = GetStorage();

  Future<void> write<T>(String key, T value) async {
    await _box.write(key, value);
  }

  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  Future<void> clear() async {
    await _box.erase();
  }

  bool hasData(String key) {
    return _box.hasData(key);
  }
}
