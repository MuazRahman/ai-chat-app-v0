import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

class ApiService {
  static const String _apiKey = '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';
  static const String _apiUrl = 'https://api.groq.com/openai/v1/chat/completions';

  Future<String> getResponse(String message) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'messages': [
          {'role': 'user', 'content': message}
        ],
        'model': 'meta-llama/llama-4-scout-17b-16e-instruct'
      }),
    );

    Logger logger = Logger();
    if (response.statusCode == 200) {
      logger.i('Status Code => ${response.statusCode}');
      logger.i('Response Data => ${response.body}');
      final decodedBody = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(decodedBody);
      return jsonData['choices'][0]['message']['content'];
    } else {
      logger.i('Status Code => ${response.statusCode}');
      return 'Failed to get response';
    }
  }
}