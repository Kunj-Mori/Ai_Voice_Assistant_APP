import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/chat_provider.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticIn,
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleSubmitted(BuildContext context) {
    final message = _textController.text.trim();
    if (message.isEmpty) return;

    Provider.of<ChatProvider>(context, listen: false).sendMessage(message);
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  void _handleMicTap(ChatProvider chatProvider) {
    if (chatProvider.isListening) {
      chatProvider.stopListening();
      _animationController.reverse();
    } else {
      _animationController.forward().then((_) {
        _animationController.reverse();
        chatProvider.startListening();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final isListening = chatProvider.isListening;
    final isProcessing = chatProvider.isProcessing;
    final isSpeaking = chatProvider.isSpeaking;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          )
        ],
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  side: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                color: theme.colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: TextField(
                    controller: _textController,
                    onChanged: (text) {
                      setState(() {
                        _isComposing = text.trim().isNotEmpty;
                      });
                    },
                    onSubmitted: (text) => _handleSubmitted(context),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                      enabled: !isListening && !isProcessing,
                    ),
                    cursorColor: theme.colorScheme.primary,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            if (_isComposing)
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: isProcessing ? null : () => _handleSubmitted(context),
                  color: theme.colorScheme.onPrimary,
                ),
              )
            else
              Stack(
                alignment: Alignment.center,
                children: [
                  if (isListening)
                    AvatarGlow(
                      animate: true,
                      glowColor: theme.colorScheme.primary,
                      duration: const Duration(milliseconds: 2000),
                      repeat: true,
                      startDelay: Duration.zero,
                      glowCount: 2,
                      glowRadiusFactor: 0.7,
                      child: const SizedBox(width: 40, height: 40),
                    ),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: isListening ? _pulseAnimation.value : _scaleAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isListening 
                                ? theme.colorScheme.primary
                                : theme.colorScheme.secondaryContainer,
                          ),
                          child: IconButton(
                            icon: Icon(
                              isListening ? Icons.mic : Icons.mic_none,
                              color: isListening
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSecondaryContainer,
                            ),
                            onPressed: isProcessing || isSpeaking
                                ? null
                                : () => _handleMicTap(chatProvider),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            if (isSpeaking)
              Container(
                margin: const EdgeInsets.only(left: 8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.volume_up),
                  color: theme.colorScheme.onErrorContainer,
                  onPressed: () => chatProvider.stopSpeaking(),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 