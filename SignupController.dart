import 'dart:convert';
import 'dart:io';
import 'package:labgo_flutter_app/model/User.dart';
import 'package:http/http.dart' as http;
import 'package:labgo_flutter_app/view/SignupPage.dart';
import '../ApiConfig.dart';
import '../ApiError.dart';
import '../ApiResponse.dart';

class SignupController {
  SignupPage signupPage;
  SignupController({required this.signupPage});

  Future<ApiResponse> signupUser(
      String username, String password, String email) async {
    ApiResponse _apiResponse = new ApiResponse();

    try {
      final _authority = ApiConfig.baseUrl;
      final _path = "user_controller.php/signup";
      final _params = {
        "username": username,
        "password": password,
        "email": email
      };
      final url = Uri.parse(_authority + _path);
      final response = await http.post(url, body: _params);
      final status = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = status['statusCode'];

      switch (statusCode) {
        case 201:
          Map<String, dynamic> data = json.decode(response.body);
          _apiResponse.Data = User.fromJson(data);
          break;
        case 409:
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
