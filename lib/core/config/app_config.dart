import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  /// 👇 Чтение из .env — безопасно и удобно
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  static final String consumerKey = dotenv.env['CONSUMER_KEY'] ?? '';
  static final String consumerSecret = dotenv.env['CONSUMER_SECRET'] ?? '';
}
