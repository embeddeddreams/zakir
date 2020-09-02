import 'package:shared_preferences/shared_preferences.dart';
import 'package:zakir/constants.dart';

class StorageService {
  /// SharedPreferences instansını oluşturur.
  Future<SharedPreferences> getInstanceAsync() async {
    return await SharedPreferences.getInstance();
  }

  /// Aydıt belleğindeki uygulama ile ilgili bilgileri temizler.
  Future<void> clearStorageAsync() async {
    SharedPreferences instances = await getInstanceAsync();
    instances.clear();
    // setIntro(true);
  }

  ///Kullanıcı Token'ının var olup olmadığını kontrol eder.
  Future<bool> userTokenDoesExist() async {
    String token = await getTokenAsync();
    return token != null;
  }

  ///Bellekten Kullanıcı Token bilgilerini alır.
  Future<String> getTokenAsync() async {
    SharedPreferences instances = await getInstanceAsync();
    String stringValue = instances.getString(Keys.USER_TOKEN);
    return stringValue;
  }

  ///Belleğe Kullanıcı Token bilgilerini atar.
  Future<void> setTokenAsync(String token) async {
    SharedPreferences instances = await getInstanceAsync();
    instances.setString(Keys.USER_TOKEN, token);
  }

  ///Bellekten Kullanıcı FirebaseToken bilgilerini alır.
  Future<String> getFirebaseTokenAsync() async {
    SharedPreferences instances = await getInstanceAsync();
    String stringValue = instances.getString(Keys.USER_FIREBASE_TOKEN);
    return stringValue;
  }

  ///Belleğe Kullanıcı FirebaseToken bilgilerini atar.
  Future<void> setFirebaseTokenAsync(String token) async {
    SharedPreferences instances = await getInstanceAsync();
    instances.setString(Keys.USER_FIREBASE_TOKEN, token);
  }  

  ///Kullanıcıya splash ekran bilgisini atar.
  Future<void> setUpdatePopupShowed(bool showed) async {
    SharedPreferences instance = await getInstanceAsync();
    instance.setBool(Keys.SHOW_VERSION_UPDATE, showed);
  }

  ///Bellekten Kullanıcı splash ekran bilgisini alır.
  Future<bool> getUpdatePopupShowed() async {
    SharedPreferences instances = await getInstanceAsync();
    bool boolValue = instances.getBool(Keys.SHOW_VERSION_UPDATE);
    return boolValue;
  }
}
