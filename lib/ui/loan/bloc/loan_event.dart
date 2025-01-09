import 'package:equatable/equatable.dart';

abstract class LoanEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddLoan extends LoanEvent {
  final String clientName;
  final double amount;
  final double interestRate;
  final int numberOfInstallments;
  final String paymentFrequency;

  AddLoan(this.clientName, this.amount, this.interestRate,
      this.numberOfInstallments, this.paymentFrequency);

  @override
  List<Object> get props => [
        clientName,
        amount,
        interestRate,
        numberOfInstallments,
        paymentFrequency
      ];
}

class FetchLoans extends LoanEvent {
  final String userId;

  FetchLoans(this.userId);

  @override
  List<Object> get props => [userId];
}
