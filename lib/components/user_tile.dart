// import 'package:flutter/material.dart';

// class UserTile extends StatelessWidget {
//   final String text;
//   final void Function()? onTap;

//   const UserTile({
//     super.key,
//     required this.text,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.lightBlue,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//         padding: EdgeInsets.all(20),
//         child: Row(
//           children: [
//             Icon(Icons.person),
//             SizedBox(width: 5),
//             Text(text),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String role;
  // final void Function()? onTap;
  final void Function()? onChatTap;
  final void Function()? onDeleteTap;

  const UserTile({
    super.key,
    required this.text,
    required this.role,
    // this.onTap,
    this.onChatTap,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChatTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.person),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            if (onChatTap != null)
              IconButton(
                icon: Icon(Icons.chat, color: Colors.white),
                onPressed: onChatTap,
              ),
            if (onDeleteTap != null)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: onDeleteTap,
              ),
          ],
        ),
      ),
    );
  }
}
