import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:labgo_flutter_app/model/Activation.dart';
import '../ApiConfig.dart';
import '../ApiError.dart';
import '../ApiResponse.dart';

class ForgotPasswordController {
  Future<ApiResponse> forgotPassword(String email) async {
    ApiResponse _apiResponse = new ApiResponse();

    try {
      final _authority = ApiConfig.baseUrl;
      final _path = "user_controller.php/reset_password";
      final _params = {"email": email};
      final url = Uri.parse(_authority + _path);
      final response = await http.post(url, body: _params);
      final status = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = status['statusCode'];

      switch (statusCode) {
        case 200:
          Map<String, dynamic> data = json.decode(response.body);
          _apiResponse.Data = Activation.fromJson(data);
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

  Future<ApiResponse> updatePassword(String email, String newPassword) async {
    ApiResponse _apiResponse = new ApiResponse();

    try {
      final _authority = ApiConfig.baseUrl;
      final _path = "user_controller.php/new_password";
      final _params = {"email": email, "new_password": newPassword};
      final url = Uri.parse(_authority + _path);
      final response = await http.post(url, body: _params);
      final status = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = status['statusCode'];

      switch (statusCode) {
        case 200:
          Map<String, dynamic> data = json.decode(response.body);
          _apiResponse.Data = data['statusCode'];
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
