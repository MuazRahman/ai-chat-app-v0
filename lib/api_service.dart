import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

import 'message_model.dart';

class ApiService {
  static const String _apiKey = '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';
  static const String _apiUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _aIModel = 'meta-llama/llama-4-maverick-17b-128e-instruct'; // Model may occur issue. Change it when needed by selecting another model and the model will found view code

  final Logger _logger = Logger();

  Future<String> getResponseFromHistory({
    required List<Message> userMessages,
    required List<Map<String, String>> systemPrompt,
  }) async {
    // Convert your chat history to the API format
    final messagesForApi = [
      ...systemPrompt, // 👈 add system prompt at the top
      ...userMessages.map((message) {
        return {
          'role': message.isMe ? 'user' : 'assistant',
          'content': message.text,
        };
      }),
    ];

    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'messages': messagesForApi,
        'model': _aIModel,
      }),
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      _logger.i('Status Code => ${response.statusCode}');
      _logger.i('Response Data => $decodedBody');
      final jsonData = jsonDecode(decodedBody);
      return jsonData['choices'][0]['message']['content'];
    } else {
      _logger.e('Status Code => ${response.statusCode}');
      _logger.e('Error Body => ${response.body}');
      return 'Failed to get response.😟 Try again letter!';
    }
  }
}