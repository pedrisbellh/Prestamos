import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prestamos/data/repositories/loan_repository.dart';
import 'loan_event.dart';
import 'loan_state.dart';

class LoanBloc extends Bloc<LoanEvent, LoanState> {
  final LoanRepository loanRepository;

  LoanBloc(this.loanRepository) : super(LoanInitial());

  Stream<LoanState> mapEventToState(LoanEvent event) async* {
    if (event is AddLoan) {
      yield LoanLoading();
      try {
        String loanId = await loanRepository.addLoan(event.loan);
        yield LoanLoaded(
            [event.loan.copyWith(id: loanId)]); // Retorna el préstamo agregado
      } catch (e) {
        yield LoanError('Error al agregar el préstamo: $e');
      }
    } else if (event is RemoveLoan) {
      yield LoanLoading();
      try {
        await loanRepository.removeLoan(event.loanId);
        yield LoanLoaded(
            []); // Retorna una lista vacía o puedes manejar la lista de otra manera
      } catch (e) {
        yield LoanError('Error al eliminar el préstamo: $e');
      }
    }
  }
}
