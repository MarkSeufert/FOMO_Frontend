import '../model/user.dart';
import '../networking/api_provider.dart';

class UserAPI {
  static ApiProvider _apiProvider = ApiProvider();

  static Future<User> getUser(String email, SignInType signInType) async {
    Map<String, dynamic> param = {"email": email};
    final response = await _apiProvider.get("getUser", param);
    User user = User.fromJson(response, signInType: signInType);
    return user;
  }

  static Future<User> createUser(
      String username, String email, SignInType signInType) async {
    Map<String, dynamic> param = {"email": email, "name": username};
    final response = await _apiProvider.post("createUser", param);
    User user = User.fromJson(response, signInType: signInType);
    return user;
  }
}
