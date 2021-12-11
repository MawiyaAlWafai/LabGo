import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:labgo_flutter_app/model/Experiment.dart';
import 'package:labgo_flutter_app/model/Lab.dart';
import 'package:labgo_flutter_app/model/Quiz.dart';
import 'package:labgo_flutter_app/model/Video.dart';
import 'package:labgo_flutter_app/view/ExperimentsPage.dart';
import '../ApiConfig.dart';
import '../ApiError.dart';
import '../ApiResponse.dart';

class ExperimentsController {
  var experimentsPage;
  ExperimentsController({required this.experimentsPage});

  Future<ApiResponse> getExperiments(String userId) async {
    ApiResponse _apiResponse = new ApiResponse();

    try {
      final _authority = ApiConfig.authorityBaseUrl;
      final _path = "/controller/experiments_controller.php/experiments";
      final _params = {"user_id": userId};
      final url = Uri.http(_authority, _path, _params);
      final response = await http.get(url);
      final status = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = status['statusCode'];

      switch (statusCode) {
        case 200:
          Map<String, dynamic> data = json.decode(response.body);
          List<Experiment> listData = [];
          for (int index = 0; index < data['data'].length; index++) {
            listData.add(Experiment.fromJson(data['data'][index]));
          }
          _apiResponse.listData = listData;
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

  Future<ApiResponse> getExperimentsWithProgress(String userId) async {
    ApiResponse _apiResponse = new ApiResponse();

    try {
      final _authority = ApiConfig.authorityBaseUrl;
      final _path = "/controller/experiments_controller.php/user_progress";
      final _params = {"user_id": userId};
      final url = Uri.http(_authority, _path, _params);
      final response = await http.get(url);
      final status = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = status['statusCode'];

      switch (statusCode) {
        case 200:
          Map<String, dynamic> data = json.decode(response.body);
          List<Experiment> listData = [];
          for (int index = 0; index < data['data'].length; index++) {
            listData.add(Experiment.fromJson(data['data'][index]));
          }
          _apiResponse.listData = listData;
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

  Future<ApiResponse> getExperimentVideo(String experimentId) async {
    ApiResponse _apiResponse = new ApiResponse();

    try {
      final _authority = ApiConfig.authorityBaseUrl;
      final _path = "/controller/experiments_controller.php/video";
      final _params = {"experiment_id": experimentId};
      final url = Uri.http(_authority, _path, _params);
      final response = await http.get(url);
      final status = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = status['statusCode'];

      switch (statusCode) {
        case 200:
          Map<String, dynamic> data = json.decode(response.body);
          List<Video> listData = [];
          for (int index = 0; index < data['data'].length; index++) {
            listData.add(Video.fromJson(data['data'][index]));
          }
          _apiResponse.listData = listData;
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

  Future<ApiResponse> getExperimentTools(String experimentId) async {
    ApiResponse _apiResponse = new ApiResponse();

    try {
      final _authority = ApiConfig.authorityBaseUrl;
      final _path = "/controller/experiments_controller.php/tools_steps";
      final _params = {"experiment_id": experimentId};
      final url = Uri.http(_authority, _path, _params);
      final response = await http.get(url);
      final status = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = status['statusCode'];

      switch (statusCode) {
        case 200:
          Map<String, dynamic> data = json.decode(response.body);
          List<Lab> listData = [];
          for (int index = 0; index < data['data'].length; index++) {
            listData.add(Lab.fromJson(data['data'][index]));
          }
          _apiResponse.listData = listData;
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

  Future<ApiResponse> getExperimentQuizWithChoices(String experimentId) async {
    ApiResponse _apiResponse = new ApiResponse();

    try {
      final _authority = ApiConfig.authorityBaseUrl;
      final _path = "/controller/quiz_controller.php/quiz";
      final _params = {"experiment_id": experimentId};
      final url = Uri.http(_authority, _path, _params);
      final response = await http.get(url);
      final status = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = status['statusCode'];

      switch (statusCode) {
        case 200:
          Map<String, dynamic> data = json.decode(response.body);
          List<Quiz> listData = [];
          for (int index = 0; index < data['data'].length; index++) {
            listData.add(Quiz.fromJson(data['data'][index]));
          }
          _apiResponse.listData = listData;
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

  Future<ApiResponse> updateExperimentProgress(
      String userId, String experimentId, int currentToolOrder,
      [double currentQuizProgress = 0.0]) async {
    ApiResponse _apiResponse = new ApiResponse();

    try {
      final _authority = ApiConfig.baseUrl;
      final _path = "experiments_controller.php/update_progress";
      final _params = {
        "user_id": userId,
        "experiment_id": experimentId,
        "currentToolOrder": currentToolOrder.toString(),
        "currentQuizProgress": currentQuizProgress.toString(),
      };
      final url = Uri.parse(_authority + _path);
      final response = await http.post(url, body: _params);
      final status = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = status['statusCode'];

      switch (statusCode) {
        case 200:
          _apiResponse.Data = [];
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

  Future<ApiResponse> updateExperimentStatus(
      String experimentId, int experimentStatus) async {
    ApiResponse _apiResponse = new ApiResponse();

    try {
      final _authority = ApiConfig.baseUrl;
      final _path = "experiments_controller.php/update_status";
      final _params = {
        "experiment_id": experimentId,
        "experiment_status": experimentStatus.toString(),
      };
      final url = Uri.parse(_authority + _path);
      final response = await http.post(url, body: _params);
      final status = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = status['statusCode'];

      switch (statusCode) {
        case 200:
          _apiResponse.Data = [];
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

  Future<ApiResponse> addExperimentQuestion(String experimentId,
      String question, String choice1, String choice2, String choice3) async {
    ApiResponse _apiResponse = new ApiResponse();

    try {
      final _authority = ApiConfig.baseUrl;
      final _path = "quiz_controller.php/add_question";
      final _params = {
        "experiment_id": experimentId,
        "question": question,
        "choice1": choice1,
        "choice2": choice2,
        "choice3": choice3,
      };
      final url = Uri.parse(_authority + _path);
      final response = await http.post(url, body: _params);
      final status = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = status['statusCode'];

      switch (statusCode) {
        case 200:
          _apiResponse.Data = [];
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

  Future<ApiResponse> deleteExperimentQuestion(
      String experimentId, int questionId) async {
    ApiResponse _apiResponse = new ApiResponse();

    try {
      final _authority = ApiConfig.baseUrl;
      final _path = "quiz_controller.php/delete_question";
      final _params = {
        "experiment_id": experimentId,
        "question_id": questionId.toString(),
      };
      final url = Uri.parse(_authority + _path);
      final response = await http.post(url, body: _params);
      final status = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = status['statusCode'];

      switch (statusCode) {
        case 200:
          _apiResponse.Data = [];
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

  Future<ApiResponse> updateExperimentQuestion(
      String experimentId,
      String questionId,
      String question,
      String choice1,
      String choice2,
      String choice3,
      String choice1Id,
      String choice2Id,
      String choice3Id,
      int correctChoiceId) async {
    ApiResponse _apiResponse = new ApiResponse();

    try {
      final _authority = ApiConfig.baseUrl;
      final _path = "quiz_controller.php/update_question";
      final _params = {
        "experiment_id": experimentId,
        "question_id": questionId,
        "question": question,
        "choice1": choice1,
        "choice2": choice2,
        "choice3": choice3,
        "choice1_id": choice1Id,
        "choice2_id": choice2Id,
        "choice3_id": choice3Id,
        "correct_choice_id": correctChoiceId.toString(),
      };
      final url = Uri.parse(_authority + _path);
      final response = await http.post(url, body: _params);
      final status = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = status['statusCode'];

      switch (statusCode) {
        case 200:
          _apiResponse.Data = [];
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

  Future<ApiResponse> deleteExperimentVideo(String experimentId) async {
    ApiResponse _apiResponse = new ApiResponse();

    try {
      final _authority = ApiConfig.baseUrl;
      final _path = "experiments_controller.php/delete_video";
      final _params = {
        "experiment_id": experimentId,
      };
      final url = Uri.parse(_authority + _path);
      final response = await http.post(url, body: _params);
      final status = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = status['statusCode'];

      switch (statusCode) {
        case 200:
          _apiResponse.Data = [];
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

  Future<ApiResponse> addExperimentVideo(
      String experimentId, String videoUrl, String videoDescription) async {
    ApiResponse _apiResponse = new ApiResponse();

    try {
      final _authority = ApiConfig.baseUrl;
      final _path = "experiments_controller.php/add_video";
      final _params = {
        "experiment_id": experimentId,
        "video_url": videoUrl,
        "video_description": videoDescription,
      };
      final url = Uri.parse(_authority + _path);
      final response = await http.post(url, body: _params);
      final status = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = status['statusCode'];

      switch (statusCode) {
        case 200:
          _apiResponse.Data = [];
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
