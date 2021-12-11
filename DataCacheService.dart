import 'package:labgo_flutter_app/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataCacheService {
  final SharedPreferences sharedPrefrences;
  DataCacheService({required this.sharedPrefrences});

  Map<String, dynamic> getData() {
    Map<String, dynamic> values = {};

    final id = sharedPrefrences.getString('id');
    final username = sharedPrefrences.getString('username');
    final email = sharedPrefrences.getString('email');
    final role = sharedPrefrences.getString('role');
    final image = sharedPrefrences.getString('image');

    if (id != null && username != null && email != null && role != null) {
      values['id'] = id;
      values['username'] = username;
      values['email'] = email;
      values['role'] = role;
      values['image'] = image;
    }

    return values;
  }

  Future<void> setData(User userData) async {
    await sharedPrefrences.setString(
      'id',
      userData.getId,
    );

    await sharedPrefrences.setString(
      'username',
      userData.getUsername,
    );

    await sharedPrefrences.setString(
      'email',
      userData.getEmail,
    );

    await sharedPrefrences.setString(
      'role',
      userData.getRole,
    );

    await sharedPrefrences.setString(
      'image',
      userData.getImage,
    );
  }
}
