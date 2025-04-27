import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

import 'message_model.dart';

class ApiService {
  static const String _apiKey1 = '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'; // MuazRahman
  static const String _apiKey2 = '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'; // MuazRahman2
  static const String _apiKey3 = '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'; // MuazRahman3
  // static const String _apiKey4 = 'api_key_4_here';
  static const String _apiUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _aIModel = 'meta-llama/llama-4-maverick-17b-128e-instruct';

  final Logger _logger = Logger();

  int _requestCount = 0;  // To track the number of requests made
  int _currentApiKeyIndex = 0;  // To track which API key is currently in use

  // List of API keys
  final List<String> _apiKeys = [_apiKey1, _apiKey2, _apiKey3]; // 4th key will add here

  // This method is used to get the current API key based on the request count
  String get _currentApiKey {
    // If the request count reaches 100, switch to the next API key
    if (_requestCount >= 100) {
      _currentApiKeyIndex = (_currentApiKeyIndex + 1) % _apiKeys.length;  // Cycle through the API keys
      _requestCount = 0;  // Reset the request count after switching the API key
    }
    return _apiKeys[_currentApiKeyIndex];  // Return the correct API key based on the current index
  }

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
      Uri.parse(_apiUrl), // The API URL remains constant
      headers: {
        'Authorization': 'Bearer $_currentApiKey', // Use the current API key
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

      // Increment the request count after each request
      _requestCount++;

      return jsonData['choices'][0]['message']['content'];
    } else {
      _logger.e('Status Code => ${response.statusCode}');
      _logger.e('Error Body => ${response.body}');
      return 'Failed to get response.😟 Try again later!';
    }
  }
}
