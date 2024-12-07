class LoanCalculator {
 static double calculateTotalToPay(double amount, double interest) {
    return amount + (amount * interest / 100);
  }

 static double calculateAmountPerInstallment(double totalToPay, int numberOfInstallments) {
    return totalToPay / numberOfInstallments;
  }
}