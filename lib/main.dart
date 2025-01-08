import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prestamos/data/repositories/company_repository.dart';
import 'package:prestamos/domain/models/client/client.dart';
import 'package:prestamos/ui/client/screens/client_details_screen.dart';
import 'package:prestamos/ui/company/bloc/company_bloc.dart';
import 'package:prestamos/ui/company/screens/create_company_screen.dart';
import 'package:prestamos/ui/loan/screens/create_loan_screen.dart';
import 'package:prestamos/ui/loan/screens/print_screen.dart';
import 'package:prestamos/ui/user/screens/register_screen.dart';
import 'package:prestamos/ui/user/screens/user_panel_screen.dart';
import 'package:prestamos/ui/company/screens/view_company_screen.dart';
import 'package:prestamos/ui/loan/screens/view_loan_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'ui/user/screens/login_screen.dart';
import 'ui/client/screens/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Habilitar el almacenamiento en caché de Firestore
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);
  } catch (e) {
    print("Error inicializando Firebase: $e");
    return;
  }

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(
          create: (context) => CompanyBloc(CompanyRepository()),
        ),

        // Otros providers
      ],
      child: const MainApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: "/login",
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      path: '/createLoan/:clientName',
      builder: (BuildContext context, GoRouterState state) {
        final String clientName = state.pathParameters['clientName']!;
        return CreateLoanScreen(clientName: clientName);
      },
    ),
    GoRoute(
      path: '/viewLoan/:loanId',
      builder: (BuildContext context, GoRouterState state) {
        final String loanId = state.pathParameters['loanId']!;
        return ViewLoanScreen(loanId: loanId);
      },
    ),
    GoRoute(
      path: '/clientDetails/:clientId',
      builder: (BuildContext context, GoRouterState state) {
        final String clientId = state.pathParameters['clientId']!;
        return FutureBuilder<Client?>(
          future: _getClientById(clientId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Cliente no encontrado'));
            } else {
              final client = snapshot.data!;
              return ClientDetailsScreen(client: client);
            }
          },
        );
      },
    ),
    GoRoute(
      path: '/createCompany',
      builder: (BuildContext context, GoRouterState state) {
        return const CreateCompanyScreen();
      },
    ),
    GoRoute(
      path: '/viewCompany/:userId',
      builder: (BuildContext context, GoRouterState state) {
        final String userId = state.pathParameters['userId']!;
        return ViewCompanyScreen(userId: userId);
      },
    ),
    GoRoute(
      path: '/userPanel',
      builder: (BuildContext context, GoRouterState state) {
        return const UserPanelScreen();
      },
    ),
    GoRoute(
      path: '/print',
      builder: (BuildContext context, GoRouterState state) {
        return const PrintScreen();
      },
    ),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    );
  },
);

Future<Client?> _getClientById(String clientId) async {
  try {
    final doc = await FirebaseFirestore.instance
        .collection('clients')
        .doc(clientId)
        .get();

    if (doc.exists) {
      return Client.fromJson(doc.data()!);
    }
  } catch (e) {
    print('Error al obtener el cliente: $e');
  }
  return null;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Prestamos',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
