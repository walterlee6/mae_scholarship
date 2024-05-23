// import 'package:flutter/material.dart';
// import 'package:scholarship_application/components/user_tile.dart';

// class UserManagementPage extends StatelessWidget {
//   const UserManagementPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Management Page'),
//       ),
//       // body: ListView.builder(
//       //   itemCount: 10,
//       //   itemBuilder: (context, index) {
//       //     return ListTile(
//       //       title: Text('User ${index + 1}'),
//       //       subtitle: Text('User ${index + 1}@example.com'),
//       //       trailing: IconButton(
//       //         icon: Icon(
//       //           Icons.delete,
//       //           color: Colors.red,
//       //         ),
//       //         onPressed: () {},
//       //       ),
//       //     );
//       //   },
//       // ),
//       // body: UserTile(

//       // ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholarship_application/admin/chat_page.dart';
import 'package:scholarship_application/components/user_tile.dart';
import 'package:scholarship_application/pages/login_page.dart';
import 'package:scholarship_application/services/chat_service.dart';

class UserManagementPage extends StatelessWidget {
  UserManagementPage({super.key});

  final ChatService _chatService = ChatService();

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Management"),
      ),
      body: _buildUserList(),
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
          } else if (userData["role"] == "student") {
            students.add(userData);
          }
        }

        return ListView(children: [
          ...admins.map((userData) => _buildUserListItem(userData, context)),
          ...providers.map((userData) => _buildUserListItem(userData, context)),
          ...students.map((userData) => _buildUserListItem(userData, context)),
        ]);

        // return ListView(
        //   children: snapshot.data!
        //       .map<Widget>(
        //         (userData) => _buildUserListItem(userData, context),
        //       )
        //       .toList(),
        // );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    bool isCurrentUser = userData["email"] == getCurrentUser()!.email;

    return UserTile(
      text: userData["email"],
      role: userData["role"],
      // onTap: () {
      //   // Handle tap if needed
      // },
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

    // return ListTile(
    //   leading: Icon(Icons.person),
    //   title: Text(userData["email"]),
    //   subtitle: Text(userData["role"]),
    //   trailing: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       IconButton(
    //         icon: Icon(Icons.chat),
    //         onPressed: () {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => ChatPage(
    //                 receiverEmail: userData["email"],
    //                 receiverID: userData["uid"],
    //               ),
    //             ),
    //           );
    //         },
    //       ),
    //       if (!isCurrentUser)
    //         IconButton(
    //           icon: Icon(Icons.delete),
    //           onPressed: () {
    //             _chatService.deleteUser(userData["uid"]);
    //           },
    //         ),
    //     ],
    //   ),
    // );
    // if (userData["email"] != getCurrentUser()!.email) {
    //   return UserTile(
    //     text: userData["email"],
    //     onTap: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => ChatPage(
    //             receiverEmail: userData["email"],
    //             receiverID: userData["uid"],
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // } else {
    //   return Container();
    // }
  }
}
