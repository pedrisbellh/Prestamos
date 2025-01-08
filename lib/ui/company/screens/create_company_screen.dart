import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:prestamos/data/utils/validators/company_validator.dart';
import 'package:prestamos/ui/extensions/build_context_extension.dart';
import 'package:prestamos/data/services/firebase_service.dart';
import '../../../data/utils/snack_bar_top.dart';
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

  void _saveCompany() {
    setState(() {
      nameError = CompanyValidation.validateName(nameController.text, context);
      addressError =
          CompanyValidation.validateAddress(addressController.text, context);
      phoneError =
          CompanyValidation.validatePhone(phoneController.text, context);
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
                        validator: (value) =>
                            CompanyValidation.validateName(value, context),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: context.l10n.direction,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            CompanyValidation.validateAddress(value, context),
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
                        validator: (value) =>
                            CompanyValidation.validatePhone(value, context),
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
