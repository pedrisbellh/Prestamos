import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prestamos/data/utils/validators/company_validator.dart';
import 'package:prestamos/ui/company/bloc/company_bloc.dart';
import 'package:prestamos/ui/company/bloc/company_event.dart';
import 'package:prestamos/ui/company/bloc/company_state.dart';
import 'package:prestamos/ui/extensions/build_context_extension.dart';
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userId;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser?.uid;
  }

  void _showSnackBar(String message) {
    SnackBarTop.showTopSnackBar(context, message);
  }

  void _saveCompany() {
    if (_formKey.currentState!.validate()) {
      final companyBloc = context.read<CompanyBloc>();

      companyBloc.add(AddCompany(
        nameController.text,
        addressController.text,
        phoneController.text,
        rcnController.text.isNotEmpty ? rcnController.text : null,
      ));
    }
  }

  void _cancel() {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.createCompany),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<CompanyBloc, CompanyState>(
        listener: (context, state) {
          if (state is CompanySuccess) {
            _showSnackBar(state.message);
            Navigator.pop(context);
          } else if (state is CompanyError) {
            _showSnackBar(state.message);
          }
        },
        child: Center(
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
      ),
    );
  }
}
