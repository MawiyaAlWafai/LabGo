import 'dart:convert';
import 'dart:io';
import 'package:labgo_flutter_app/model/User.dart';
import 'package:labgo_flutter_app/view/LoginPage.dart';
import 'package:http/http.dart' as http;
import '../ApiConfig.dart';
import '../ApiError.dart';
import '../ApiResponse.dart';

class LoginController {
  LoginPage loginPage;
  LoginController({required this.loginPage});

  Future<ApiResponse> authenticateUser(String username, String password) async {
    ApiResponse _apiResponse = new ApiResponse();

    try {
      final _authority = ApiConfig.baseUrl;
      final _path = "user_controller.php/login";
      final _params = {"username": username, "password": password};
      final url = Uri.parse(_authority + _path);
      final response = await http.post(url, body: _params);
      final status = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = status['statusCode'];

      switch (statusCode) {
        case 200:
          Map<String, dynamic> data = json.decode(response.body);
          _apiResponse.Data = User.fromJson(data);
          break;
        case 400:
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
        default:
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } on SocketException {
      _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
    }
    return _apiResponse;
  }
}
