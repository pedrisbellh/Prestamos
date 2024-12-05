import 'package:flutter/material.dart';

class ClientDetailsScreen extends StatelessWidget {
  final String clientName;
  final String clientPhone;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String address; // Nuevo campo
  final String identityCard; // Nuevo campo

  const ClientDetailsScreen({
    super.key,
    required this.clientName,
    required this.clientPhone,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.address, // Agregar parámetro
    required this.identityCard, // Agregar parámetro
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
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Agregar SingleChildScrollView aquí
          child: Center(
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
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    const SizedBox(height: 16),
                    _buildListTile(Icons.person, 'Nombre Completo', clientName),
                    _buildListTile(Icons.phone, 'Teléfono', clientPhone),
                    _buildListTile(Icons.home, 'Dirección actual', address),
                    _buildListTile(Icons.card_membership, 'Cédula de Identidad', identityCard),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'Contacto de Emergencia',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    const SizedBox(height: 16),
                    _buildListTile(Icons.person, 'Nombre Completo', emergencyContactName),
                    _buildListTile(Icons.phone, 'Teléfono', emergencyContactPhone),
                  ],
                ),
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
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.black54),
      ),
      leading: Icon(icon, color: Colors.teal),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    );
  }
}