# 🎙️ Gemini AI Voice Assistant

![Flutter](https://img.shields.io/badge/Flutter-3.7+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Google Gemini](https://img.shields.io/badge/Gemini_1.5-Flash-4285F4?style=for-the-badge&logo=google&logoColor=white)

A modern, feature-rich voice assistant powered by Google's Gemini 1.5 Flash API. Interact naturally through voice or text and receive intelligent responses with a beautiful, responsive UI.

## ✨ Features

- **🗣️ Dual Input Methods**: Seamlessly switch between voice and text input
- **🎧 Manual Text-to-Speech**: Control when to hear AI responses with playback buttons
- **🎭 Adaptive UI**: Automatically switches between light and dark themes
- **💾 Conversation History**: Review and continue previous conversations
- **🌐 Gemini 1.5 Flash**: Faster, more efficient AI responses
- **🎨 Beautiful Animations**: Smooth transitions and visual feedback

## 📱 Screenshots

<div align="center">
  <table>
    <tr>
      <td><img src="screenshots/dark_mode.png" alt="Dark Mode" width="200"/></td>
      <td><img src="screenshots/light_mode.png" alt="Light Mode" width="200"/></td>
      <td><img src="screenshots/voice_input.png" alt="Voice Input" width="200"/></td>
    </tr>
  </table>
</div>

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.7.0 or higher
- Dart 3.0.0 or higher
- A Google Gemini API key from [Google AI Studio](https://ai.google.dev/)
- Android Studio or Visual Studio Code with Flutter extensions

### Step-by-Step Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/gemini_voice_assistant.git
   cd gemini_voice_assistant
   ```

2. **Get your Gemini API Key**
   - Visit [Google AI Studio](https://ai.google.dev/)
   - Create a new API key for the Gemini 1.5 Flash model
   - Copy the API key

3. **Set up environment variables**
   - Create a `.env` file in the project root
   ```
   GEMINI_API_KEY=your_gemini_api_key_here
   ```

4. **Install dependencies**
   ```bash
   flutter pub get
   ```

5. **Run the application**
   ```bash
   # For debug mode
   flutter run
   
   # For release mode
   flutter run --release
   ```

### Building for Production

**Android**
```bash
flutter build apk --release
# The APK will be available at build/app/outputs/flutter-apk/app-release.apk
```

**iOS**
```bash
flutter build ios --release
# Open the Runner.xcworkspace in Xcode and distribute via App Store Connect
```

## 📱 Usage Guide

### Voice Input
1. Tap the microphone button at the bottom
2. Speak your question or command clearly
3. The app will show a glowing animation while listening
4. Release the button or wait for it to auto-stop when you finish speaking
5. View the AI's response in the chat

### Text Input
1. Type your message in the text field
2. Tap the send button (appears when text is entered)
3. View the response in the chat thread

### Listen to Responses
1. Tap the play button next to any AI response
2. The app will read the response aloud
3. Tap the stop button to end playback at any time

### Managing Conversations
- **New Chat**: Tap the + icon in the app bar
- **View History**: Tap the history icon to see past messages
- **Clear Chat**: Tap the delete icon to clear the current conversation

## ��️ Architecture

The application follows a clean architecture pattern with:

- **Models**: Data structures for messages and conversations
- **Services**: API communication and speech processing
- **Providers**: State management using the Provider pattern
- **UI Components**: Widgets for responsive and interactive UI

## 🛠️ Technical Details

### Dependencies

- `google_generative_ai`: For Gemini API integration
- `speech_to_text`: For voice recognition
- `flutter_tts`: For text-to-speech functionality
- `provider`: For state management
- `shared_preferences`: For storing chat history
- `lottie`: For animations
- `flutter_markdown`: For rendering markdown responses

### Permissions

The app requires the following permissions:
- `RECORD_AUDIO`: For voice recognition
- `INTERNET`: For API communication

## 🔮 Future Enhancements

- Multi-language support
- Image recognition capabilities
- Voice customization options
- Cloud synchronization between devices
- Advanced conversation context management

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgements

- Google for the Gemini API
- Flutter team for the amazing framework
- All package authors for their valuable contributions

## ❓ Troubleshooting

**API Key Issues**
- Ensure your `.env` file is correctly placed in the project root
- Check that the API key is correctly formatted with no extra spaces
- Verify that your API key has access to the Gemini 1.5 Flash model

**Voice Recognition Problems**
- Ensure microphone permissions are granted to the app
- Speak clearly and in a quiet environment
- Check your device's language settings match the app's configuration

**Text-to-Speech Not Working**
- Ensure your device's media volume is turned up
- Check that text-to-speech is enabled in your device settings
- Try restarting the app if speech output stops working

---

<div align="center">
  <p>Built with ❤️ using Flutter</p>
</div>
