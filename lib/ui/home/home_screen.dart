import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prestamos/data/providers/company_provider/company_provider_impl.dart';
import 'package:prestamos/data/repositories/company_repository.dart';
import 'package:prestamos/domain/models/company/company.dart';
import 'package:prestamos/ui/extensions/build_context_extension.dart';
import 'package:prestamos/ui/widgets/utils/snack_bar_top.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late CompanyRepository companyRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser?.uid;
    companyRepository = CompanyRepository(CompanyProviderImpl());
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      context.go('/login');
    } catch (e) {
      SnackBarTop.showTopSnackBar(context, context.l10n.error);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayMe'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            offset: const Offset(0, 52),
            onSelected: (value) async {
              switch (value) {
                // Cual es la opcion (1)
                // llamo a un evento del bloc
                case 1:
                  String userId = FirebaseAuth.instance.currentUser!.uid;
                  Company? company = await companyRepository.getCompany(userId);

                  if (company != null) {
                    context.push('/viewCompany/$userId');
                  } else {
                    context.push('/createCompany');
                  }
                  break;
                case 2:
                  context.push('/userPanel');
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 1,
                child: Text(context.l10n.viewCompany),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text(context.l10n.accountDetails),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          children: [
            _buildGridItem(Icons.person, 'Clientes', context, '/clients'),
            _buildGridItem(
                Icons.monetization_on, 'Préstamos', context, '/loans'),
            _buildGridItem(
                Icons.date_range_outlined, 'Atrasados', context, '/delays',
                color: Colors.red.shade900),
            _buildGridItem(
                Icons.settings, 'Configuración', context, '/settings'),
            _buildGridItem(Icons.logout, 'Cerrar Sesión', context, '',
                color: Colors.red.shade900, onTap: () => _logout(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(
      IconData icon, String title, BuildContext context, String route,
      {Color color = Colors.black, Function? onTap}) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap();
          } else {
            context.push(route);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
