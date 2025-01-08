import 'package:flutter/material.dart';
import 'package:prestamos/ui/extensions/build_context_extension.dart';
import 'package:prestamos/domain/models/client/client.dart';

class ClientDetailsScreen extends StatelessWidget {
  final Client client;
  const ClientDetailsScreen({
    super.key,
    required this.client,
  });

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
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.clientDetail),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Container(
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
                  Text(
                    context.l10n.clientContact,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                  const SizedBox(height: 16),
                  _buildListTile(
                      Icons.person, context.l10n.fullName, client.name),
                  _buildListTile(
                      Icons.phone, context.l10n.telephone, client.phone),
                  _buildListTile(
                      Icons.home, context.l10n.direction, client.address),
                  _buildListTile(
                    Icons.card_membership,
                    context.l10n.clientId,
                    client.identityCard,
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.emergencyContact,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                  const SizedBox(height: 16),
                  _buildListTile(Icons.person, context.l10n.fullName,
                      client.emergencyContactName),
                  _buildListTile(
                    Icons.phone,
                    context.l10n.telephone,
                    client.emergencyContactPhone,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
