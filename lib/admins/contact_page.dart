import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scholarship_application/admins/chat_page.dart';
import 'package:scholarship_application/admins/navigation_bar.dart';
import 'package:scholarship_application/components/user_tile.dart';
import 'package:scholarship_application/services/chat_services.dart';

class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  final ChatService _chatService = ChatService();
  bool _adminsExpanded = false;
  bool _providersExpanded = false;
  bool _studentsExpanded = false;

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

        List<Map<String, dynamic>> providers = [];
        List<Map<String, dynamic>> students = [];
        List<Map<String, dynamic>> admins = [];

        for (var userData in snapshot.data!) {
          if (userData["role"] == "Provider") {
            providers.add(userData);
          } else if (userData["role"] == "Student") {
            students.add(userData);
          } else if (userData["role"] == "Admin") {
            admins.add(userData);
          }
        }

        var currentUserData = snapshot.data!.firstWhere(
          (userData) => userData["email"] == getCurrentUser()!.email,
        );
        admins.removeWhere(
            (userData) => userData["email"] == getCurrentUser()!.email);

        return ListView(
          children: [
            _buildCurrentUserTile(currentUserData),
            _buildCategoryTile(
              "Admins",
              admins,
              _adminsExpanded,
              () {
                setState(() {
                  _adminsExpanded = !_adminsExpanded;
                });
              },
            ),
            _buildCategoryTile(
              "Providers",
              providers,
              _providersExpanded,
              () {
                setState(() {
                  _providersExpanded = !_providersExpanded;
                });
              },
            ),
            _buildCategoryTile(
              "Students",
              students,
              _studentsExpanded,
              () {
                setState(() {
                  _studentsExpanded = !_studentsExpanded;
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCurrentUserTile(Map<String, dynamic> userData) {
    return Container(
      color: Colors.blueGrey[800],
      padding: EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Contact",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          ListTile(
            title: Text(
              userData["email"],
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              userData["role"],
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(
    String title,
    List<Map<String, dynamic>> users,
    bool isExpanded,
    VoidCallback onTap,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[900],
          ),
        ),
        leading: Icon(Icons.group, color: Colors.blueGrey[900]),
        children: isExpanded
            ? [
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return _buildUserTile(users[index]);
                  },
                ),
              ]
            : [],
        initiallyExpanded: isExpanded,
        onExpansionChanged: (expanded) {
          onTap();
        },
      ),
    );
  }

  Widget _buildUserTile(Map<String, dynamic> userData) {
    return Card(
      color: Colors.blueGrey[700],
      margin: EdgeInsets.all(6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              userData["email"],
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.chat, color: Colors.greenAccent),
                  onPressed: () {
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
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () async {
                    await _chatService.deleteUser(userData["uid"]);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
