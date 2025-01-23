import 'package:flutter/material.dart';

class AppDetailsScreen extends StatelessWidget {
  const AppDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Aplicación'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajustar el tamaño de la Card
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PayMe',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              Text(
                '(v.1.0.0)',
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 16),
              Text(
                'PayMe es una aplicación Android para gestionar tus préstamos de manera fácil y eficiente.',
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
