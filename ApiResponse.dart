import 'package:flutter/material.dart';

class ApiResponse {
  Object? _data;
  List<Object>? _listData;
  Object? _apiError;

  Object? get getData {
    return _data;
  }

  set Data(Object data) => _data = data;

  List<Object>? get getListData {
    return _listData;
  }

  set listData(List<Object> listData) => _listData = listData;

  Object get ApiError => _apiError as Object;
  set ApiError(Object error) => _apiError = error;
}
