import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Método para crear una cuenta
  Future<String?> createAccount(String correo, String pass) async {
    // Validación básica de entradas
    if (correo.isEmpty || pass.isEmpty) {
      return 'El correo y la contraseña no pueden estar vacíos.';
    }

    // Validación del formato del correo electrónico
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(correo)) {
      return 'El correo electrónico proporcionado no es válido.';
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: correo,
        password: pass,
      );
      // Almacenar credenciales localmente
      await _saveCredentials(correo, pass);
      return null; // Retorna null si la creación fue exitosa
    } on FirebaseAuthException catch (e) {
      // Manejo de errores específicos de Firebase
      switch (e.code) {
        case 'weak-password':
          return 'La contraseña proporcionada es demasiado débil.';
        case 'email-already-in-use':
          return 'La cuenta ya existe para ese correo electrónico.';
        case 'invalid-email':
          return 'El correo electrónico proporcionado no es válido.';
        default:
          return 'Error desconocido: ${e.message}';
      }
    } catch (e) {
      return 'Error: ${e.toString()}'; // Retorna un mensaje de error genérico
    }
  }

  /// Método para iniciar sesión
  Future<String?> signInEmailAndPassword(String email, String password) async {
    // Validación básica de entradas
    if (email.isEmpty || password.isEmpty) {
      return 'El correo y la contraseña no pueden estar vacíos.';
    }

    // Validación del formato del correo electrónico
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email)) {
      return 'El correo electrónico proporcionado no es válido.';
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Retorna null si el inicio de sesión fue exitoso
    } on FirebaseAuthException catch (e) {
      // Manejo de errores específicos de Firebase
      switch (e.code) {
        case 'user-not-found':
          return 'No se encontró un usuario con ese correo electrónico.';
        case 'wrong-password':
          return 'La contraseña es incorrecta.';
        case 'invalid-email':
          return 'El correo electrónico no es válido.';
        case 'invalid-credential':
          return 'Credenciales incorrectas';
        case 'network-request-failed' || 'unknow':
          return 'Revise su conexión a internet';
        default:
          return '${e.message}';
      }
    } catch (e) {
      return 'Error: ${e.toString()}'; // Retorna un mensaje de error genérico
    }
  }

  /// Método para iniciar sesión offline
  Future<User?> signInOffline(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('email');
    String? storedPassword = prefs.getString('password');

    // Verificar si las credenciales almacenadas coinciden
    if (storedEmail == email && storedPassword == password) {
      // Si las credenciales coinciden, retorna un usuario simulado
      return _auth
          .currentUser; // Aquí deberías retornar un objeto User real si lo tienes
    }
    return null; // Retorna null si las credenciales no coinciden
  }

  /// Método para almacenar credenciales
  Future<void> _saveCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  /// Método para limpiar credenciales
  Future<void> clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
  }
}
