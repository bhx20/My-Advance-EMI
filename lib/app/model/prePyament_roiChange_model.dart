class CalculationHistory {
  final double outstandingAmount;
  final double currentRate;
  final double currentEmi;
  final double revisedRate;
  final double prePaymentAmount;
  final double newEmi;
  final double emiDifference;
  final double oldEmi;
  final double newInterest;
  final double interestDifference;
  final double interestDifferenceTenure;
  final double oldInterest;
  final double oldInterestEmi;
  final double oldMonths;
  final double newMonths;
  final double monthsDifference;
  final bool isRevisedRateView;
  final DateTime createdAt;

  CalculationHistory({
    required this.outstandingAmount,
    required this.currentRate,
    required this.currentEmi,
    required this.revisedRate,
    required this.prePaymentAmount,
    required this.newEmi,
    required this.emiDifference,
    required this.oldEmi,
    required this.newInterest,
    required this.interestDifference,
    required this.interestDifferenceTenure,
    required this.oldInterest,
    required this.oldInterestEmi,
    required this.oldMonths,
    required this.newMonths,
    required this.monthsDifference,
    required this.isRevisedRateView,
    required this.createdAt,
  });
}
