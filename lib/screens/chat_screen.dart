import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';
import '../models/message_model.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              radius: 16,
              child: Icon(
                Icons.smart_toy_outlined,
                color: theme.colorScheme.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Gemini 1.5 Flash',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        actions: [
          // New Chat button
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Chat',
            onPressed: () {
              final chatProvider = Provider.of<ChatProvider>(context, listen: false);
              chatProvider.clearChat();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Started a new chat'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          // History button
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Chat History',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => Consumer<ChatProvider>(
                  builder: (ctx, chatProvider, _) {
                    final messages = chatProvider.messages;
                    
                    if (messages.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No chat history yet'),
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (ctx, index) {
                        final message = messages[index];
                        return ListTile(
                          leading: Icon(
                            message.role == MessageRole.user
                              ? Icons.person
                              : Icons.smart_toy_outlined,
                            color: theme.colorScheme.primary,
                          ),
                          title: Text(
                            message.role == MessageRole.user
                              ? 'You'
                              : 'Gemini',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            message.content.length > 50
                              ? '${message.content.substring(0, 50)}...'
                              : message.content,
                          ),
                          trailing: Text(
                            '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
          // Clear conversation button
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear Conversation',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Clear conversation?'),
                  content: const Text(
                    'This will delete all messages in this conversation. This action cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
                        chatProvider.clearChat();
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Conversation cleared'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text('CLEAR'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (ctx, chatProvider, _) {
                final messages = chatProvider.messages;
                final isProcessing = chatProvider.isProcessing;
                
                if (messages.isEmpty && !isProcessing) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: Lottie.asset(
                            'assets/animations/ai-assistant.json',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Welcome to Gemini 1.5 Flash',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            'Start by typing a message or tap the microphone to speak',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  reverse: false,
                  padding: const EdgeInsets.only(bottom: 8.0),
                  itemCount: messages.length + (isProcessing ? 1 : 0),
                  itemBuilder: (ctx, index) {
                    if (index == messages.length && isProcessing) {
                      // Show a thinking indicator with improved animation
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: theme.colorScheme.primaryContainer,
                              child: Icon(
                                Icons.smart_toy_outlined,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: theme.colorScheme.secondary.withOpacity(0.8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, 
                                    vertical: 12.0,
                                  ),
                                  child: Row(
                                    children: [
                                      DefaultTextStyle(
                                        style: TextStyle(
                                          color: theme.colorScheme.onSecondary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                        child: const Text('Thinking'),
                                      ),
                                      const SizedBox(width: 8),
                                      DefaultTextStyle(
                                        style: TextStyle(
                                          color: theme.colorScheme.onSecondary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                        child: AnimatedTextKit(
                                          animatedTexts: [
                                            TyperAnimatedText(
                                              '...',
                                              speed: const Duration(milliseconds: 300),
                                            ),
                                          ],
                                          isRepeatingAnimation: true,
                                          repeatForever: true,
                                          displayFullTextOnTap: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    final message = messages[index];
                    return MessageBubble(message: message);
                  },
                );
              },
            ),
          ),
          const ChatInput(),
        ],
      ),
    );
  }
} 