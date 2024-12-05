class Loan {
  final String clientName;
  final double amount;
  final double interestRate;
  final int numberOfInstallments;
  final String paymentFrequency;
   int installmentsPaid;
   int cuotasRestantes;

  Loan({
    required this.clientName,
    required this.amount,
    required this.interestRate,
    required this.numberOfInstallments,
    required this.paymentFrequency,
      this.installmentsPaid = 0,
      this.cuotasRestantes = 0,
  });

  double calculateTotalToPay() {
    return amount + (amount * (interestRate / 100) * numberOfInstallments);
  }

  double calculateAmountPerInstallment() {
    return calculateTotalToPay() / numberOfInstallments;
  }
}