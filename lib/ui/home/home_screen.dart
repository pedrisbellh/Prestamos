import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prestamos/ui/extensions/build_context_extension.dart';
import 'package:prestamos/ui/widgets/utils/snack_bar_top.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser?.uid;
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          children: [
            _buildGridItem(Icons.person, 'Clientes', context, '/clients',
                color: Colors.teal),
            _buildGridItem(
                Icons.monetization_on, 'Préstamos', context, '/loans',
                color: Colors.teal),
            _buildGridItem(
                Icons.date_range_outlined, 'Cobrar', context, '/toCollect',
                color: Colors.teal),
            _buildGridItem(
                Icons.date_range_outlined, 'Atrasados', context, '/delays',
                color: Colors.red.shade900),
            _buildGridItem(
                Icons.settings, 'Configuración', context, '/settings',
                color: Colors.teal),
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
