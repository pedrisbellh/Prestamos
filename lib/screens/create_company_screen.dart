import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:prestamos/extensions/build_context_extension.dart';
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
    userId = _auth.currentUser?.uid;
  }

  void _showSnackBar(String message) {
    SnackBarTop.showTopSnackBar(context, message);
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.emptyField;
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.emptyField;
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.emptyField;
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
      addCompanyToFirestore(
        name: nameController.text,
        address: addressController.text,
        phone: phoneController.text,
        rcn: rcnController.text.isNotEmpty ? rcnController.text : null,
        userId: userId!,
      ).then((_) {
        _showSnackBar(context.l10n.saveCompany);
      }).catchError((error) {
        _showSnackBar(context.l10n.error);
      });
    } else {
      _showSnackBar(context.l10n.emptyField2);
    }
  }

  void _cancel() {
    context.go('/');
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.createCompany),
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
                        decoration: InputDecoration(
                          labelText: context.l10n.name,
                          border: const OutlineInputBorder(),
                        ),
                        validator: _validateName,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: context.l10n.direction,
                          border: const OutlineInputBorder(),
                        ),
                        validator: _validateAddress,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: context.l10n.telephone,
                          border: const OutlineInputBorder(),
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
                        decoration: InputDecoration(
                          labelText: context.l10n.rcn,
                          border: const OutlineInputBorder(),
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
                            child: Text(context.l10n.acept),
                          ),
                          const SizedBox(width: 40),
                          ElevatedButton(
                            onPressed: _cancel,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(context.l10n.cancel),
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
