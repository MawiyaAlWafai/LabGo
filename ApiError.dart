class ApiError {
  late String _error;

  ApiError({required String error}) {
    this._error = error;
  }

  String get error => _error;
  set error(String error) => _error = error;

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(error: json['statusCode'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this._error;
    return data;
  }
}
