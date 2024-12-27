import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestamos/extensions/build_context_extension.dart';
import '/models/user.dart';

class UserPanelScreen extends StatelessWidget {
  const UserPanelScreen({super.key});

  Future<UserData> _fetchUserData(String userId) async {
    QuerySnapshot clientsSnapshot = await FirebaseFirestore.instance
        .collection('clients')
        .where('userId', isEqualTo: userId)
        .get();

    QuerySnapshot loansSnapshot = await FirebaseFirestore.instance
        .collection('loan')
        .where('userId', isEqualTo: userId)
        .get();

    QuerySnapshot companySnapshot = await FirebaseFirestore.instance
        .collection('company')
        .where('userId', isEqualTo: userId)
        .get();

    String companyName = companySnapshot.docs.isNotEmpty
        ? companySnapshot.docs.first['name']
        : 'Sin empresa';

    int clientCount = clientsSnapshot.docs.length;
    int loanCount = loansSnapshot.docs.length;
    int completedLoans =
        loansSnapshot.docs.where((doc) => doc['completado'] == true).length;
    int renewedLoans =
        loansSnapshot.docs.where((doc) => doc['renovado'] == true).length;

    return UserData(
      clientCount: clientCount,
      loanCount: loanCount,
      completedLoans: completedLoans,
      renewedLoans: renewedLoans,
      companyName: companyName,
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.black54),
      ),
      leading: Icon(icon, color: Colors.teal),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.accountDetails),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: user != null
            ? FutureBuilder<UserData>(
                future: _fetchUserData(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text(context.l10n.noData));
                  }

                  UserData userData = snapshot.data!;

                  return SingleChildScrollView(
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.accountInformation,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildListTile(
                                Icons.email, context.l10n.email, user.email!),
                            _buildListTile(Icons.business,
                                context.l10n.companyName, userData.companyName),
                            _buildListTile(
                                Icons.people,
                                context.l10n.totalClients,
                                userData.clientCount.toString()),
                            _buildListTile(Icons.money, context.l10n.totalLoans,
                                userData.loanCount.toString()),
                            _buildListTile(
                                Icons.check_circle,
                                context.l10n.finishLoans,
                                userData.completedLoans.toString()),
                            _buildListTile(
                                Icons.refresh,
                                context.l10n.renewLoans,
                                userData.renewedLoans.toString()),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(child: Text(context.l10n.noUser)),
      ),
    );
  }
}
