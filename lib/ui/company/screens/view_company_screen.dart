import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prestamos/ui/company/bloc/company_bloc.dart';
import 'package:prestamos/ui/company/bloc/company_event.dart';
import 'package:prestamos/ui/company/bloc/company_state.dart';
import 'package:prestamos/ui/extensions/build_context_extension.dart';

class ViewCompanyScreen extends StatelessWidget {
  final String userId;

  const ViewCompanyScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    context.read<CompanyBloc>().add(FetchCompany(userId));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.viewCompany2),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CompanyBloc, CompanyState>(
        builder: (context, state) {
          if (state is CompanyLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            );
          } else if (state is CompanyError) {
            return Center(child: Text(state.message));
          } else if (state is CompanyDataSuccess) {
            final company = state.company;
            return Container(
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
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.companyDetails,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal),
                        ),
                        const SizedBox(height: 16),
                        _buildListTile(
                            Icons.business, context.l10n.name, company.name),
                        _buildListTile(Icons.home, context.l10n.direction,
                            company.address),
                        _buildListTile(
                            Icons.phone, context.l10n.telephone, company.phone),
                        _buildListTile(Icons.card_membership, context.l10n.rcn,
                            company.rcn ?? context.l10n.noAvaliable),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle) {
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
    );
  }
}
