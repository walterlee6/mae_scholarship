import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scholarship_application/admins/chat_page.dart';
import 'package:scholarship_application/admins/navigation_bar.dart';
import 'package:scholarship_application/components/user_tile.dart';
import 'package:scholarship_application/authentications/login_page.dart';
import 'package:scholarship_application/services/chat_services.dart';

class Chatbox extends ConsumerWidget {
  Chatbox({super.key});

  final ChatService _chatService = ChatService();

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final selectedIndex = ref.watch(selectedIndexProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: _buildUserList(),
      bottomNavigationBar: NaviBar(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Map<String, dynamic>> admins = [];
        List<Map<String, dynamic>> providers = [];
        List<Map<String, dynamic>> students = [];

        for (var userData in snapshot.data!) {
          if (userData["role"] == "admin") {
            admins.add(userData);
          } else if (userData["role"] == "provider") {
            providers.add(userData);
          } else {
            students.add(userData);
          }
        }

        return ListView(
          children: [
            ...admins.map((userData) => _buildUserTile(userData, context)),
            ...providers.map((userData) => _buildUserTile(userData, context)),
            ...students.map((userData) => _buildUserTile(userData, context)),
          ],
        );
      },
    );
  }

  Widget _buildUserTile(Map<String, dynamic> userData, BuildContext context) {
    bool isCurrentUser = userData["email"] == getCurrentUser()!.email;

    return UserTile(
      text: userData["email"],
      role: userData["role"],
      onChatTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverEmail: userData["email"],
              receiverID: userData["uid"],
            ),
          ),
        );
      },
      onDeleteTap: isCurrentUser
          ? null
          : () async {
              await _chatService.deleteUser(userData["uid"]);
            },
    );

    //       return ListView(
    //         children: snapshot.data!
    //             .map<Widget>(
    //               (userData) => _buildUserListItem(userData, context),
    //             )
    //             .toList(),
    //       );
    //     },
    //   );
    // }

    // Widget _buildUserListItem(
    //     Map<String, dynamic> userData, BuildContext context) {
    //   if (userData["email"] != getCurrentUser()!.email) {
    //     return UserTile(
    //       text: userData["email"],
    //       onTap: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => ChatPage(
    //               receiverEmail: userData["email"],
    //               receiverID: userData["uid"],
    //             ),
    //           ),
    //         );
    //       },
    //     );
    //   } else {
    //     return Container();
    //   }
  }
}
