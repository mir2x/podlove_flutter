import 'dart:convert';

import 'package:dio/dio.dart';

TermResposeModel privacyResposeModelFromJson(String str) =>
    TermResposeModel.fromJson(json.decode(str));

class TermResposeModel {
  bool success;
  String message;
  Data? data;

  TermResposeModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TermResposeModel.fromJson(Response<dynamic> json) {
    final dataJson = json.data['data'];
    return TermResposeModel(
      success: json.data['success'],
      message: json.data['message'],
      data: dataJson is Map<String, dynamic> && dataJson.isNotEmpty
          ? Data.fromJson(dataJson)
          : null,
    );
  }
}

class Data {
  String text;

  Data({
    required this.text,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        text: json["text"],
      );
}
