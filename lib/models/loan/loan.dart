import 'package:freezed_annotation/freezed_annotation.dart';
part 'loan.freezed.dart';
part 'loan.g.dart';

@freezed
class Loan with _$Loan {
  const Loan._();
  const factory Loan({
    String? id,
    required double amount,
    required double interestRate,
    required int numberOfInstallments,
    required String paymentFrequency,
    required String? clientId,
    int? installmentsPaid,
    int? cuotasRestantes,
    @Default(false) bool completado,
    @Default(false) bool renovado,
  }) = _Loan;
  factory Loan.fromJson(Map<String, Object?> json) => _$LoanFromJson(json);
}
