import 'package:flutter/material.dart';
import 'package:prestamos/models/client/client.dart';

class ClientDetailsScreen extends StatelessWidget {
  final Client client;
  const ClientDetailsScreen({
    super.key,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Cliente'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Agregar SingleChildScrollView aquí
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
                    'Contacto del Cliente',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                  const SizedBox(height: 16),
                  _buildListTile(Icons.person, 'Nombre Completo', client.name),
                  _buildListTile(Icons.phone, 'Teléfono', client.phone),
                  _buildListTile(
                      Icons.home, 'Dirección actual', client.address),
                  _buildListTile(
                    Icons.card_membership,
                    'Cédula de Identidad',
                    client.identityCard,
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Contacto de Emergencia',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                  const SizedBox(height: 16),
                  _buildListTile(Icons.person, 'Nombre Completo',
                      client.emergencyContactName),
                  _buildListTile(
                    Icons.phone,
                    'Teléfono',
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
