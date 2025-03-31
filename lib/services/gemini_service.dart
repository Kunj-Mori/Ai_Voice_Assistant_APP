import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/message_model.dart';

class GeminiService {
  late final GenerativeModel _model;
  late ChatSession _chatSession;

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('API key not found! Please add it to .env file.');
    }
    
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topP: 0.95,
        topK: 40,
        maxOutputTokens: 1024,
      ),
    );
    
    _chatSession = _model.startChat();
  }

  Future<String> sendMessage(String message) async {
    try {
      final response = await _chatSession.sendMessage(Content.text(message));
      final responseText = response.text ?? 'No response from AI';
      return responseText;
    } catch (e) {
      return 'Error communicating with AI service: $e';
    }
  }
  
  Future<void> resetSession() async {
    _chatSession = _model.startChat();
  }
} 