import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'message_model.dart';

class ApiService {
  late final String? _apiKey1;
  late final String? _apiKey2;
  late final String? _apiKey3;
  late final String? _apiUrl;
  late final String? _aIModel;

  final Logger _logger = Logger();

  int _requestCount = 0;  // To track the number of requests made
  int _currentApiKeyIndex = 0;  // To track which API key is currently in use

  // List of API keys
  late final List<String?> _apiKeys;

  // Initialize the service with environment variables or defaults
  Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');
      _apiKey1 = dotenv.env['APIKEY1'];
      _apiKey2 = dotenv.env['APIKEY2'];
      _apiKey3 = dotenv.env['APIKEY3'];
      _apiUrl = dotenv.env['APIURL'];
      _aIModel = dotenv.env['AIMODEL'];
    } catch (e) {
      _logger.w('Failed to load .env file: $e');
      // Set default values if .env file is not available
      _apiKey1 = null;
      _apiKey2 = null;
      _apiKey3 = null;
      _apiUrl = 'https://api.openai.com/v1/chat/completions';
      _aIModel = 'gpt-3.5-turbo';
    }
    
    _apiKeys = [_apiKey1, _apiKey2, _apiKey3];
  }

  // This method is used to get the current API key based on the request count
  String? get _currentApiKey {
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
    // Check if API key is available
    if (_currentApiKey == null || _currentApiKey!.isEmpty) {
      return 'API key not configured. Please check your .env file.';
    }

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

    try {
      final response = await http.post(
        Uri.parse(_apiUrl!), // The API URL remains constant
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
    } catch (e) {
      _logger.e('Error making API request: $e');
      return 'Network error occurred. Please check your internet connection.';
    }
  }
}
