import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scholarship_application/admins/navigation_bar.dart';

class ProviderVerificationPage extends ConsumerStatefulWidget {
  @override
  _ProviderVerificationPageState createState() =>
      _ProviderVerificationPageState();
}

class _ProviderVerificationPageState
    extends ConsumerState<ProviderVerificationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _verifyProvider(String userId, bool isVerified) async {
    await _firestore.collection('users').doc(userId).update({
      'verified': isVerified,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Scholarship Providers'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .where('role', isEqualTo: 'Provider')
            .where('verified', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No providers to verify.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final providerData = doc.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(providerData['email'] ?? 'No Email'),
                  subtitle: Text(providerData['role'] ?? 'No Role'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => _verifyProvider(doc.id, true),
                      ),
                      IconButton(
                        icon: Icon(Icons.clear, color: Colors.red),
                        onPressed: () => _verifyProvider(doc.id, false),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      bottomNavigationBar: NaviBar(),
    );
  }
}
