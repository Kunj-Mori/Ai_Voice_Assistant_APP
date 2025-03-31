enum MessageRole { user, assistant }

class Message {
  final String content;
  final MessageRole role;
  final DateTime timestamp;

  Message({
    required this.content,
    required this.role,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'role': role.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'],
      role: json['role'] == 'user' ? MessageRole.user : MessageRole.assistant,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
} 