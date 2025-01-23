import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prestamos/data/providers/company_provider/company_provider_impl.dart';
import 'package:prestamos/data/repositories/company_repository.dart';
import 'package:prestamos/domain/models/company/company.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late CompanyRepository companyRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser?.uid;
    companyRepository = CompanyRepository(CompanyProviderImpl());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
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
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Padding para el Card
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinear a la izquierda
                children: [
                  const Text(
                    'Opciones de Cuenta',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(
                      height: 16), // Espacio entre el título y las opciones
                  _buildListTile(
                    Icons.account_circle,
                    'Detalles de Cuenta',
                    'Ver la información básica de tu cuenta',
                    () => context.push('/userPanel'),
                  ),
                  _buildListTile(
                    Icons.email,
                    'Modificar correo electrónico',
                    'Cambia tu dirección de correo electrónico',
                    () => context.push('/modifyEmail'),
                  ),
                  _buildListTile(
                    Icons.lock,
                    'Modificar contraseña',
                    'Cambia tu contraseña actual',
                    () => context.push('/modifyPassword'),
                  ),
                  _buildCompanyTile(context),
                  _buildListTile(
                    Icons.info,
                    'Detalles de la aplicación',
                    'Información sobre la aplicación',
                    () => context.push('/appDetails'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
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
      onTap: onTap,
    );
  }

  Widget _buildCompanyTile(BuildContext context) {
    return ListTile(
      title: const Text(
        'Mi Empresa',
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      subtitle: const Text(
        'Ver detalles de la empresa o crear una empresa si aún no existe.',
        style: TextStyle(color: Colors.black54),
      ),
      leading: const Icon(Icons.business, color: Colors.teal),
      onTap: () async {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        Company? company = await companyRepository.getCompany(userId);

        if (company != null) {
          context.push('/viewCompany/$userId');
        } else {
          context.push('/createCompany');
        }
      },
    );
  }
}
