// loan_event.dart
import 'package:equatable/equatable.dart';
import 'package:prestamos/domain/models/loan/loan.dart';

abstract class LoanEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddLoan extends LoanEvent {
  final Loan loan;

  AddLoan(this.loan);

  @override
  List<Object> get props => [loan];
}

class RemoveLoan extends LoanEvent {
  final String loanId;

  RemoveLoan(this.loanId);

  @override
  List<Object> get props => [loanId];
}
