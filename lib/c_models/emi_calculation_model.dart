class YearlyBreakdownItem {
  final int year;
  final double principalPaid;
  final double interestPaid;
  final double outstandingBalance;

  const YearlyBreakdownItem({
    required this.year,
    required this.principalPaid,
    required this.interestPaid,
    required this.outstandingBalance,
  });
}

class EmiResultModel {
  final double loanAmount;
  final double interestRate;
  final int tenureYears;
  final double monthlyEmi;
  final double totalInterest;
  final double totalPayable;
  final double principalPercentage;
  final double interestPercentage;
  final List<YearlyBreakdownItem> yearlyBreakdown;

  const EmiResultModel({
    required this.loanAmount,
    required this.interestRate,
    required this.tenureYears,
    required this.monthlyEmi,
    required this.totalInterest,
    required this.totalPayable,
    required this.principalPercentage,
    required this.interestPercentage,
    required this.yearlyBreakdown,
  });
}