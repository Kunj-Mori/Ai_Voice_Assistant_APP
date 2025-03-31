import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../models/message_model.dart';
import '../providers/chat_provider.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final theme = Theme.of(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    final isSpeaking = chatProvider.isSpeaking;
    
    final bubbleColor = isUser 
        ? theme.colorScheme.primary 
        : theme.colorScheme.secondaryContainer;
    final textColor = isUser 
        ? theme.colorScheme.onPrimary 
        : theme.colorScheme.onSecondaryContainer;
    final bubbleAlignment = isUser 
        ? CrossAxisAlignment.end 
        : CrossAxisAlignment.start;
    final bubbleBorderRadius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(6),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: bubbleAlignment,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser && message.content.length > 30)
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  margin: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        isSpeaking ? Icons.stop_circle : Icons.play_circle_filled,
                        key: ValueKey(isSpeaking),
                        color: theme.colorScheme.primary,
                        size: 22,
                      ),
                    ),
                    onPressed: () {
                      if (isSpeaking) {
                        chatProvider.stopSpeaking();
                      } else {
                        chatProvider.speakMessage(message.content);
                      }
                    },
                    tooltip: isSpeaking ? 'Stop speaking' : 'Listen',
                    constraints: const BoxConstraints(
                      minHeight: 36,
                      minWidth: 36,
                    ),
                    padding: EdgeInsets.zero,
                    iconSize: 22,
                  ),
                ),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: bubbleBorderRadius,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isUser
                      ? Text(
                          message.content,
                          style: TextStyle(color: textColor),
                        )
                      : MarkdownBody(
                          data: message.content,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(color: textColor),
                            h1: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                            h2: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                            h3: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                            h4: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                            h5: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                            h6: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                            code: TextStyle(
                              color: textColor.withOpacity(0.9),
                              backgroundColor: isUser 
                                  ? Colors.black.withOpacity(0.2) 
                                  : Colors.black.withOpacity(0.1),
                              fontFamily: 'monospace',
                            ),
                            codeblockDecoration: BoxDecoration(
                              color: isUser 
                                  ? Colors.black.withOpacity(0.2) 
                                  : Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            blockquote: TextStyle(
                              color: textColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 4.0, 
              right: isUser ? 4.0 : 0.0, 
              left: isUser ? 0.0 : 4.0
            ),
            child: Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 