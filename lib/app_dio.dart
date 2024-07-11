import 'package:dio/dio.dart';
import 'package:news/shared.dart';


class AppDio {
  static late Dio _dio;

  static Future<void> init() async {
    BaseOptions baseOptions = BaseOptions(
        baseUrl: "https://newsapi.org/v2/top-headlines");
    _dio = Dio(baseOptions);
  }


  static Future<Response<dynamic>> get({
    required String category,
    required String currentCountry,
  }) {
    return _dio.get(
      "",
      queryParameters: {
        "country": currentCountry,
        "category": category,
        "apiKey": "",
      },
    );
  }

 }