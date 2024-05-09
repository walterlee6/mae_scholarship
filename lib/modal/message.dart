import 'package:flutter/foundation.dart' show immutable;

@immutable
class Message {
  final String id;
  final String message;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isMine;

  Message({
    required this.id,
    required this.message,
    this.imageUrl,
    required this.createdAt,
    required this.isMine,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'imageUrl': imageUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isMine': isMine,
    };
  }

  factory Message.fromMap(Map<String, dynamic> data) {
    return Message(
      id: data['id'] as String,
      message: data['message'] as String,
      imageUrl: data['imageUrl'] != null ? data['imageUrl'] as String : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int),
      isMine: data['isMine'] as bool,
    );
  }

  Message copyWith({
    String? imageUrl,
  }) {
    return Message(
      id: id,
      message: message,
      imageUrl: imageUrl,
      createdAt: createdAt,
      isMine: isMine,
    );
  }
}
