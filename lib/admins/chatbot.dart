import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scholarship_application/admins/navigation_bar.dart';
import 'package:scholarship_application/admins/send_image_screen.dart';
import 'package:scholarship_application/components/message_list.dart';
import 'package:scholarship_application/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Chatbot extends ConsumerStatefulWidget {
  const Chatbot({super.key});

  @override
  ConsumerState<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends ConsumerState<Chatbot> {
  late final TextEditingController _messageController;
  final apiKey = dotenv.env['API_KEY'] ?? '';

  void initState() {
    _messageController = TextEditingController();
    super.initState();
  }

  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          child: Column(
            children: [
              Expanded(
                child: MessageList(
                  userId: FirebaseAuth.instance.currentUser!.uid,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Ask Question',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.image),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SendImageScreen(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                      ),
                      onPressed: sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NaviBar(),
    );
  }

  Future sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;
    await ref.read(chatProvider).sendTextMessage(
          apiKey: apiKey,
          textPrompt: _messageController.text,
        );
    _messageController.clear();
  }
}
