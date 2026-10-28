
class LoanConstants {
  LoanConstants._();

  // Loan Categories
  static const String personalLoan = 'Personal Loan';
  static const String homeLoan = 'Home Loan';
  static const String businessLoan = 'Business Loan';
  static const String educationLoan = 'Education Loan';
  static const String vehicleLoan = 'Vehicle Loan';
  static const String goldLoan = 'Gold Loan';

  // Loan Inquiry Fields
  static const String applicantName = 'Applicant Name';
  static const String applicantEmail = 'Email Address';
  static const String applicantMobile = 'Mobile Number';
  static const String requestedAmount = 'Requested Loan Amount';
  static const String employmentType = 'Employment Type';
  static const String monthlyIncome = 'Monthly Income';
  static const String loanPurpose = 'Loan Purpose';

  // Inquiry Status
  static const String statusPending = 'pending';
  static const String statusUnderReview = 'under_review';
  static const String statusApproved = 'approved';
  static const String statusRejected = 'rejected';
  static const String statusCompleted = 'completed';

  // Employment Types
  static const String salaried = 'Salaried';
  static const String selfEmployed = 'Self Employed';
  static const String businessOwner = 'Business Owner';
  static const String otherEmployment = 'Other';

  // Loan Tenure Units
  static const String months = 'Months';
  static const String years = 'Years';

  // EMI Calculator
  static const double defaultLoanAmount = 100000;
  static const double defaultInterestRate = 10.0;
  static const int defaultLoanTenureMonths = 12;

  // EMI Calculator Input Validation
  static const double minimumLoanAmount = 1;
  static const double minimumInterestRate = 0;
  static const int minimumLoanTenureMonths = 1;

  // Loan Inquiry Pagination
  static const int inquiryPageSize = 10;
  static const int initialPage = 1;

  // Display Labels
  static const String applyForLoan = 'Apply for Loan';
  static const String checkEligibility = 'Check Eligibility';
  static const String viewLoanDetails = 'View Loan Details';
  static const String trackInquiry = 'Track Inquiry';
  static const String noInquiriesFound = 'No inquiries found.';
}
