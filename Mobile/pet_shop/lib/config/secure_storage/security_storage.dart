import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_shop/models/Account/user_model.dart';

class SecurityStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  writeSecureData(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<bool> readSecureData(String key) async {
    String? value = await storage.read(key: key);
    if (value != null) {
      print('Data read from secure storage: $value');
      return true;
    } else {
      print('No data found!');
      return false;
    }
  }

  Future<String> getSecureData(String key) async {
    String? value = await storage.read(key: key);
    if (value != null) {
      print('Data read from secure storage: $value');
      return value;
    } else {
      print('No data found!');
      return 'none';
    }
  }

  Future<bool> deleteSecureData(String key) async {
    await storage.delete(key: key);
    return true;
  }
}
