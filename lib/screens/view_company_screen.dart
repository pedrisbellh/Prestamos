import 'package:flutter/material.dart';
import 'package:prestamos/models/company/company.dart';
import 'package:prestamos/services/firebase_service.dart';

class ViewCompanyScreen extends StatelessWidget {
  final String userId;

  const ViewCompanyScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Empresa'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Company?>(
        future: getCompanyFromFirestore(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se encontró la empresa.'));
          }

          final company = snapshot.data!;
          return Container(
            height: double.infinity,
            color: Colors.grey[200],
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
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
                      const Text(
                        'Detalles de la Empresa',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal),
                      ),
                      const SizedBox(height: 16),
                      _buildListTile(Icons.business, 'Nombre', company.name),
                      _buildListTile(Icons.home, 'Dirección', company.address),
                      _buildListTile(Icons.phone, 'Teléfono', company.phone),
                      _buildListTile(Icons.card_membership, 'RCN',
                          company.rcn ?? 'No disponible'),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
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
}
