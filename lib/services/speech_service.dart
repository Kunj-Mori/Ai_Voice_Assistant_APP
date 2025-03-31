import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeechService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _speechEnabled = false;
  
  // Callbacks
  VoidCallback? onListeningStarted;
  VoidCallback? onListeningStopped;
  Function(String)? onSpeechResult;
  
  SpeechService() {
    _initSpeech();
    _initTts();
  }
  
  // Initialize speech recognition
  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }
  
  // Initialize text-to-speech
  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }
  
  // Start listening
  Future<void> startListening() async {
    if (!_speechEnabled) {
      await _initSpeech();
    }
    
    await _speechToText.listen(
      onResult: (result) {
        if (result.finalResult && onSpeechResult != null) {
          onSpeechResult!(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      partialResults: false,
      localeId: "en_US",
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
    );
    
    if (onListeningStarted != null) {
      onListeningStarted!();
    }
  }
  
  // Stop listening
  Future<void> stopListening() async {
    await _speechToText.stop();
    
    if (onListeningStopped != null) {
      onListeningStopped!();
    }
  }
  
  // Speak text
  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }
  
  // Stop speaking
  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }
  
  // Check if speech service is listening
  bool get isListening => _speechToText.isListening;
  
  // Dispose resources
  Future<void> dispose() async {
    await _flutterTts.stop();
    await _speechToText.cancel();
  }
} 