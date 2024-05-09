import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scholarship_application/components/message_tile.dart';
import 'package:scholarship_application/providers/get_all_messages_provider.dart';

class MessageList extends ConsumerWidget {
  final String userId;

  const MessageList({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageData = ref.watch(getAllMessagesProvider(userId));

    return messageData.when(data: (messages) {
      return ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages.elementAt(index);

          return MessageTile(
            isOutgoing: message.isMine,
            message: message,
          );
        },
      );
    }, error: (error, stackTrace) {
      return Center(
        child: Text(error.toString()),
      );
    }, loading: () {
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
