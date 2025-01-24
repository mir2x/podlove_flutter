import 'dart:convert';
import 'package:dio/dio.dart';

VerifyCodeResponseModel verifyCodeResponseModelFromJson(String str) =>
    VerifyCodeResponseModel.fromJson(json.decode(str));

class VerifyCodeResponseModel {
  final int statusCode;
  final bool success;
  final String message;
  final Data? data;

  VerifyCodeResponseModel({
    required this.statusCode,
    required this.success,
    required this.message,
    this.data,
  });

  factory VerifyCodeResponseModel.fromJson(Response<dynamic> json) {
    final dataJson = json.data['data'];
    return VerifyCodeResponseModel(
      statusCode: json.statusCode!,
      success: json.data['success'],
      message: json.data['message'],
      data: dataJson is Map<String, dynamic> && dataJson.isNotEmpty
          ? Data.fromJson(dataJson)
          : null,
    );
  }
}

class Data {
  final String accessToken;

  Data({
    required this.accessToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json["accessToken"],
      );
}
