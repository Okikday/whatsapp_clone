import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';




//General API URL
final String apiURL = dotenv.env['API_URL'] ?? "";
final Dio dio = Dio();