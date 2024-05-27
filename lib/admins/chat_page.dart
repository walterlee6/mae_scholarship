// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:scholarship_application/components/chat_bubble.dart';
// import 'package:scholarship_application/components/my_textfield.dart';
// import 'package:scholarship_application/services/chat_service.dart';

// class ChatPage extends StatefulWidget {
//   final String receiverEmail;
//   final String receiverID;

//   ChatPage({
//     super.key,
//     required this.receiverEmail,
//     required this.receiverID,
//   });

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _messageController = TextEditingController();

//   final ChatService _chatService = ChatService();

//   User? getCurrentUser() {
//     return FirebaseAuth.instance.currentUser;
//   }

//   void _sendMessage() async {
//     if (_messageController.text.isNotEmpty) {
//       await _chatService.sendMessage(widget.receiverID, _messageController.text);

//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.receiverEmail),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _buildMessagesList(),
//           ),
//           _buildUserInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessagesList() {
//     String senderID = getCurrentUser()!.uid;
//     return StreamBuilder(
//       stream: _chatService.getMessages(widget.receiverID, senderID),
//       builder: ((context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text("Error"),
//           );
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         return ListView(
//           children:
//               snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
//         );
//       }),
//     );
//   }

//   Widget _buildMessageItem(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//     bool isCurrentUser = data['senderID'] == getCurrentUser()!.uid;

//     var alignment =
//         isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

//     return Container(
//       alignment: alignment,
//       child: Column(
//         crossAxisAlignment:
//             isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           ChatBubble(
//             message: data["message"],
//             isCurrentUser: isCurrentUser,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildUserInput() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 50),
//       child: Row(
//         children: [
//           Expanded(
//             child: MyTextField(
//               controller: _messageController,
//               hintText: "Type a message",
//               obscureText: false,
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.blue,
//             ),
//             child: IconButton(
//               icon: Icon(
//                 Icons.arrow_upward,
//                 color: Colors.white,
//               ),
//               onPressed: _sendMessage,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholarship_application/components/chat_bubble.dart';
import 'package:scholarship_application/components/my_textfield.dart';
import 'package:scholarship_application/services/chat_services.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildCustomHeader(),
          Expanded(
            child: _buildMessagesList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.blueGrey[900],
        child: Row(
          children: [
            // IconButton(
            //   icon: Icon(Icons.arrow_back, color: Colors.white),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
            CircleAvatar(
              backgroundColor: Colors.blueGrey[700],
              child: Text(
                widget.receiverEmail[0].toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 10),
            Text(
              widget.receiverEmail,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    String senderID = getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: ((context, snapshot) {
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

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      }),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == getCurrentUser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    // return Container(
    //   alignment: alignment,
    //   margin: EdgeInsets.symmetric(vertical: 5),
    //   child: ChatBubble(
    //     message: data["message"],
    //     isCurrentUser: isCurrentUser,
    //   ),
    // );

    return Container(
      alignment: alignment,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser)
            CircleAvatar(
              backgroundColor: Colors.blueGrey[700],
              child: Text(
                widget.receiverEmail[0].toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          if (!isCurrentUser) SizedBox(width: 10),
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
          ),
          if (isCurrentUser) SizedBox(width: 10),
          if (isCurrentUser)
            CircleAvatar(
              backgroundColor: Colors.blueGrey[700],
              child: Text(
                getCurrentUser()?.email?[0].toUpperCase() ?? '',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.blueGrey[800],
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
            ),
          ),
          SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
