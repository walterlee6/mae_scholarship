import 'package:flutter/material.dart';
import 'package:scholarship_application/admin/chatbot.dart';
import 'package:scholarship_application/admin/user_manual.dart';

class NaviBar extends StatelessWidget {
  const NaviBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              color: Colors.blue.withOpacity(0.3),
              child: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                color: Colors.blue,
              ),
            ),
            Container(
              color: Colors.green.withOpacity(0.3),
              child: IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                color: Colors.green,
              ),
            ),
            Container(
              color: Colors.orange.withOpacity(0.3),
              child: IconButton(
                icon: Icon(Icons.library_books),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserManual()),
                  );
                },
                color: Colors.orange,
              ),
            ),
            Container(
              color: Colors.pink.withOpacity(0.3),
              child: IconButton(
                icon: Icon(Icons.chat_bubble),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Chatbot()),
                  );
                },
                color: Colors.pink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
