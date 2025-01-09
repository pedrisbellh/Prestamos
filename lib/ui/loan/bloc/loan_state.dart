import 'package:equatable/equatable.dart';
import 'package:prestamos/domain/models/loan/loan.dart';

abstract class LoanState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoanInitial extends LoanState {}

class LoanLoading extends LoanState {}

class LoanSuccess extends LoanState {
  final String message;

  LoanSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class LoanError extends LoanState {
  final String message;

  LoanError(this.message);

  @override
  List<Object> get props => [message];
}

class LoanDataSuccess extends LoanState {
  final List<Loan> loans;

  LoanDataSuccess(this.loans);

  @override
  List<Object> get props => [loans];
}
