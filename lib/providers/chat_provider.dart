import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message_model.dart';
import '../services/gemini_service.dart';
import '../services/speech_service.dart';

class ChatProvider extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final SpeechService _speechService = SpeechService();
  final List<Message> _messages = [];
  bool _isProcessing = false;
  bool _isSpeaking = false;
  static const String _storageKey = 'chat_messages';

  ChatProvider() {
    _loadMessages();
    _setupSpeechCallbacks();
  }

  List<Message> get messages => List.unmodifiable(_messages);
  bool get isListening => _speechService.isListening;
  bool get isProcessing => _isProcessing;
  bool get isSpeaking => _isSpeaking;
  SpeechService get speechService => _speechService;

  void _setupSpeechCallbacks() {
    _speechService.onListeningStarted = () {
      notifyListeners();
    };

    _speechService.onListeningStopped = () {
      notifyListeners();
    };

    _speechService.onSpeechResult = (text) {
      if (text.isNotEmpty) {
        sendMessage(text);
      }
    };
  }

  Future<void> _loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? messagesJson = prefs.getString(_storageKey);
      
      if (messagesJson != null) {
        final List<dynamic> decodedMessages = jsonDecode(messagesJson);
        _messages.addAll(
          decodedMessages.map((msgJson) => Message.fromJson(msgJson)).toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading messages: $e');
    }
  }

  Future<void> _saveMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String messagesJson = jsonEncode(
        _messages.map((msg) => msg.toJson()).toList(),
      );
      await prefs.setString(_storageKey, messagesJson);
    } catch (e) {
      debugPrint('Error saving messages: $e');
    }
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;
    
    // Add user message
    final userMessage = Message(
      content: content,
      role: MessageRole.user,
    );
    _messages.add(userMessage);
    notifyListeners();
    await _saveMessages();

    // Set processing state
    _isProcessing = true;
    notifyListeners();

    try {
      // Get AI response
      final response = await _geminiService.sendMessage(content);
      
      // Add AI message
      final aiMessage = Message(
        content: response,
        role: MessageRole.assistant,
      );
      _messages.add(aiMessage);
      await _saveMessages();

      // Don't automatically speak the response
      // Just update the state
      _isProcessing = false;
      notifyListeners();
    } catch (e) {
      // Add error message
      final errorMessage = Message(
        content: 'Sorry, an error occurred: $e',
        role: MessageRole.assistant,
      );
      _messages.add(errorMessage);
      await _saveMessages();
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> speakMessage(String content) async {
    if (_isSpeaking) {
      await stopSpeaking();
    }
    
    _isSpeaking = true;
    notifyListeners();
    await _speechService.speak(content);
    _isSpeaking = false;
    notifyListeners();
  }

  Future<void> startListening() async {
    await _speechService.startListening();
    notifyListeners();
  }

  Future<void> stopListening() async {
    await _speechService.stopListening();
    notifyListeners();
  }

  Future<void> stopSpeaking() async {
    await _speechService.stopSpeaking();
    _isSpeaking = false;
    notifyListeners();
  }

  Future<void> clearChat() async {
    _messages.clear();
    await _geminiService.resetSession();
    await _saveMessages();
    notifyListeners();
  }

  @override
  void dispose() {
    _speechService.dispose();
    super.dispose();
  }
} 