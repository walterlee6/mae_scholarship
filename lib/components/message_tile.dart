import 'package:flutter/material.dart';
import 'package:scholarship_application/modals/bot_message.dart';

class MessageTile extends StatelessWidget {
  final Message message;
  final bool isOutgoing;

  const MessageTile({
    super.key,
    required this.message,
    required this.isOutgoing,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isOutgoing ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: isOutgoing ? Colors.white : Colors.black,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 10),
            message.imageUrl != null
                ? Image.network(message.imageUrl!)
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
