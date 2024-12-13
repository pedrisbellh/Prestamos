import 'package:flutter/material.dart';

class UserPanelScreen extends StatelessWidget {
  const UserPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Usuario'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text(
          'Datos del usuario',
          style:
              TextStyle(fontSize: 24), // Puedes ajustar el tamaño de la fuente
        ),
      ),
    );
  }
}
