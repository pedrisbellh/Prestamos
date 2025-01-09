import 'package:flutter_bloc/flutter_bloc.dart';
import 'company_event.dart';
import 'company_state.dart';
import 'package:prestamos/data/repositories/company_repository.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final CompanyRepository companyRepository;

  CompanyBloc(this.companyRepository) : super(CompanyInitial()) {
    on<AddCompany>((event, emit) async {
      emit(CompanyLoading());
      try {
        await companyRepository.addCompany(
          event.name,
          event.address,
          event.phone,
          event.rcn,
        );
        emit(CompanySuccess('Empresa creada'));
      } catch (e) {
        emit(CompanyError('Fallo al crear empresa: $e'));
      }
    });

    on<FetchCompany>((event, emit) async {
      emit(CompanyLoading());
      try {
        final company = await companyRepository.getCompany(event.userId);
        if (company != null) {
          emit(CompanyDataSuccess(company));
        } else {
          emit(CompanyError('Empresa no encontrada'));
        }
      } catch (e) {
        emit(CompanyError('Fallo al obtener empresa: $e'));
      }
    });
  }
}
