import 'package:flutter_bloc/flutter_bloc.dart';
import 'loan_event.dart';
import 'loan_state.dart';
import 'package:prestamos/data/repositories/loan_repository.dart';

class LoanBloc extends Bloc<LoanEvent, LoanState> {
  final LoanRepository loanRepository;

  LoanBloc(this.loanRepository) : super(LoanInitial()) {
    on<AddLoan>((event, emit) async {
      emit(LoanLoading());
      try {
        String loanId = await loanRepository.addLoan(
          clientName: event.clientName,
          amount: event.amount,
          interestRate: event.interestRate,
          numberOfInstallments: event.numberOfInstallments,
          paymentFrequency: event.paymentFrequency,
        );
        emit(LoanSuccess('Préstamo creado con ID: $loanId'));
      } catch (e) {
        emit(LoanError('Fallo al crear préstamo: $e'));
      }
    });

    on<FetchLoans>((event, emit) async {
      emit(LoanLoading());
      try {
        final loans = await loanRepository.getLoans(event.userId);
        emit(LoanDataSuccess(loans));
      } catch (e) {
        emit(LoanError('Fallo al obtener préstamos: $e'));
      }
    });
  }
}
