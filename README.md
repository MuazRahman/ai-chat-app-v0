# MuazAI Chat Assistant

A Flutter-based AI chat application that provides an intelligent conversational experience.

## Features

- 🤖 AI-powered chat interface
- 💬 Real-time messaging
- 🎨 Beautiful UI with background images
- 📱 Cross-platform support (Android, iOS, Web)
- 🔄 Multiple API key support with automatic rotation

## Setup

### 1. Environment Configuration

Create a `.env` file in the root directory with your API configuration:

```env
APIKEY1=your_openai_api_key_here
APIKEY2=your_second_api_key_here
APIKEY3=your_third_api_key_here
APIURL=https://api.openai.com/v1/chat/completions
AIMODEL=gpt-3.5-turbo
```

**Note:** You need at least one valid API key for the app to function properly.

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

## Troubleshooting

If the app shows a blank screen:

1. **Check your `.env` file** - Make sure it exists and contains valid API keys
2. **Verify API keys** - Ensure your OpenAI API keys are valid and have sufficient credits
3. **Check internet connection** - The app requires internet access to communicate with the AI service
4. **Restart the app** - Sometimes a hot restart can resolve initialization issues

## Dependencies

- Flutter SDK
- GetX for state management
- HTTP package for API calls
- Flutter Markdown for rich text display
- Flutter Dotenv for environment variable management

## License

This project is for educational purposes.
