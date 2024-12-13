import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prestamos/services/firebase_service.dart';
import '/utils/snack_bar_top.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateCompanyScreen extends StatefulWidget {
  const CreateCompanyScreen({super.key});

  @override
  _CreateCompanyScreenState createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController rcnController = TextEditingController();

  String? addressError;
  String? phoneError;
  String? rcnError;
  String? nameError;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser?.uid; // Obtener el ID del usuario logueado
  }

  // Método para mostrar SnackBar
  void _showSnackBar(String message) {
    SnackBarTop.showTopSnackBar(context, message);
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es obligatorio.';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'La dirección es obligatoria.';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es obligatorio.';
    }
    return null;
  }

  void _saveCompany() {
    setState(() {
      nameError = _validateName(nameController.text);
      addressError = _validateAddress(addressController.text);
      phoneError = _validatePhone(phoneController.text);
    });

    if (nameError == null && addressError == null && phoneError == null) {
      // Llamar al método para guardar la empresa
      addCompanyToFirestore(
        name: nameController.text,
        address: addressController.text,
        phone: phoneController.text,
        rcn: rcnController.text.isNotEmpty
            ? rcnController.text
            : null, // Solo pasar RCN si no está vacío
        userId: userId!, // Pasar el ID del usuario
      ).then((_) {
        // Mostrar un mensaje de éxito o navegar a otra pantalla
        _showSnackBar('Empresa guardada exitosamente');
      }).catchError((error) {
        // Manejar el error
        _showSnackBar('Error al guardar la empresa: $error');
      });
    } else {
      // Manejar la validación de campos vacíos
      _showSnackBar('Por favor, complete todos los campos obligatorios.');
    }
  }

  void _cancel() {
    Navigator.pop(context);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Empresa'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validateName,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          labelText: 'Dirección',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validateAddress,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Teléfono',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: _validatePhone,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: rcnController,
                        decoration: const InputDecoration(
                          labelText: 'RCN (opcional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _saveCompany();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Guardar'),
                          ),
                          const SizedBox(width: 40),
                          ElevatedButton(
                            onPressed: _cancel,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
