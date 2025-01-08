// loan_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/models/loan/loan.dart';

abstract class LoanState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoanInitial extends LoanState {}

class LoanLoading extends LoanState {}

class LoanLoaded extends LoanState {
  final List<Loan> loan;

  LoanLoaded(this.loan);

  @override
  List<Object> get props => [loan];
}

class LoanError extends LoanState {
  final String message;

  LoanError(this.message);

  @override
  List<Object> get props => [message];
}
