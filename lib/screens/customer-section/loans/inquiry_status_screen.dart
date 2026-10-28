import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/theme/app_text_styles.dart';
import '../../../../utils/currency_formatter.dart';

enum TrackingStage {
  underReview,
  documentRequired,
  approved,
}

class InquiryStatusScreen extends StatefulWidget {
  final String inquiryId;
  final String loanType;

  const InquiryStatusScreen({
    super.key,
    this.inquiryId = 'MF202610200001',
    this.loanType = 'Personal Loan',
  });

  @override
  State<InquiryStatusScreen> createState() => _InquiryStatusScreenState();
}

class _InquiryStatusScreenState extends State<InquiryStatusScreen> {
  TrackingStage _currentStage = TrackingStage.underReview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Inquiry Status',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Stage Switcher Chips (PDF Page 14 ke teeno flows test karne ke liye)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStageTab('Under Review', TrackingStage.underReview),
                    const SizedBox(width: 8),
                    _buildStageTab('Document Required', TrackingStage.documentRequired),
                    const SizedBox(width: 8),
                    _buildStageTab('Loan Approved', TrackingStage.approved),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 2. Header Info Card
              _buildHeaderCard(),
              const SizedBox(height: 14),

              // 3. Step Progress Bar
              _buildTrackerStepper(),
              const SizedBox(height: 16),

              // 4. Dynamic Middle Content (Under Review vs Document Required vs Approved)
              if (_currentStage == TrackingStage.underReview)
                _buildUnderReviewSection(),
              if (_currentStage == TrackingStage.documentRequired)
                _buildDocumentRequiredSection(),
              if (_currentStage == TrackingStage.approved)
                _buildApprovedSection(),

              const SizedBox(height: 20),

              // 5. Need Help Support Callout
              _buildSupportSection(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStageTab(String title, TrackingStage stage) {
    final isSelected = _currentStage == stage;
    return ChoiceChip(
      label: Text(title),
      selected: isSelected,
      onSelected: (_) => setState(() => _currentStage = stage),
      selectedColor: AppColors.secondary,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.white : AppColors.textPrimary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.secondary : AppColors.border,
        ),
      ),
      showCheckmark: false,
    );
  }

  // Header Card
  Widget _buildHeaderCard() {
    String statusTitle = 'Under Review';
    Color statusBg = const Color(0xFFFEF3C7);
    Color statusColor = const Color(0xFFD97706);

    if (_currentStage == TrackingStage.documentRequired) {
      statusTitle = 'Document Required';
      statusBg = const Color(0xFFFEE2E2);
      statusColor = const Color(0xFFDC2626);
    } else if (_currentStage == TrackingStage.approved) {
      statusTitle = 'Approved';
      statusBg = const Color(0xFFDCFCE7);
      statusColor = const Color(0xFF16A36A);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _currentStage == TrackingStage.approved
                  ? Icons.check_circle_outline_rounded
                  : Icons.savings_rounded,
              color: statusColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.loanType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Inquiry ID: ${widget.inquiryId}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusTitle,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Stepper Header
  Widget _buildTrackerStepper() {
    int activeStep = 1;
    if (_currentStage == TrackingStage.documentRequired) activeStep = 2;
    if (_currentStage == TrackingStage.approved) activeStep = 3;

    final steps = ['Submitted\n20 Oct', 'Under Review\n21 Oct', 'Offer Stage\nCurrent', 'Completed\nDisbursal'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            final stepIndex = index ~/ 2;
            final isPassed = activeStep > stepIndex;
            return Expanded(
              child: Container(
                height: 2,
                color: isPassed ? AppColors.secondary : AppColors.border,
              ),
            );
          } else {
            final stepIndex = index ~/ 2;
            final isCompleted = activeStep > stepIndex;
            final isCurrent = activeStep == stepIndex;

            return Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppColors.secondary
                        : isCurrent
                        ? (_currentStage == TrackingStage.documentRequired
                        ? AppColors.error
                        : AppColors.secondary)
                        : Colors.white,
                    border: Border.all(
                      color: isCompleted || isCurrent
                          ? (_currentStage == TrackingStage.documentRequired
                          ? AppColors.error
                          : AppColors.secondary)
                          : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : isCurrent
                        ? Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    )
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  steps[stepIndex],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  // Stage 1: Under Review Content
  Widget _buildUnderReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Status',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Our verification team is reviewing your documents and financial profile. We will notify you once loan offers are ready.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 12),
              _buildDetailItem('Requested Amount', '₹ 5,00,000'),
              _buildDetailItem('Purpose', 'Home Renovation'),
              _buildDetailItem('Expected Disbursal', 'Within 7-10 days', isLast: true),
            ],
          ),
        ),
      ],
    );
  }

  // Stage 2: Document Required Content
  Widget _buildDocumentRequiredSection() {
    final docs = [
      {'title': 'Income Proof', 'sub': 'Salary slips (last 3 months) or ITR', 'status': 'Required'},
      {'title': 'Identity Proof', 'sub': 'Government-issued ID', 'status': 'Uploaded'},
      {'title': 'Address Proof', 'sub': 'Utility bill / Rent agreement', 'status': 'Required'},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Additional Documents Required',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.priority_high_rounded, size: 14, color: AppColors.error),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Please upload the following documents to continue with your loan application.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          ...docs.map((d) {
            final isRequired = d['status'] == 'Required';
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isRequired ? const Color(0xFFFFFBEB) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isRequired ? const Color(0xFFFDE68A) : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isRequired ? Icons.upload_file_rounded : Icons.check_circle_rounded,
                    color: isRequired ? const Color(0xFFD97706) : AppColors.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d['title']!,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          d['sub']!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    d['status']!,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: isRequired ? const Color(0xFFD97706) : AppColors.secondary,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.cloud_upload_outlined, size: 18),
              label: const Text('Upload Documents'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Stage 3: Approved Content
  Widget _buildApprovedSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.verified_rounded, color: AppColors.secondary, size: 24),
              SizedBox(width: 8),
              Text(
                'Loan Approved!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Congratulations! Your loan inquiry has been approved by our partner lending institution.',
            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildDetailItem('Sanctioned Amount', CurrencyFormatter.formatWhole(800000)),
                _buildDetailItem('Interest Rate', '10.5% p.a.'),
                _buildDetailItem('Tenure', '5 Years'),
                _buildDetailItem('Monthly EMI', '₹ 17,192', isLast: true),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('View Offer Details', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: const Row(
        children: [
          Icon(Icons.headset_mic_outlined, color: Color(0xFF2563EB), size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Have Questions?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E40AF),
                  ),
                ),
                Text(
                  'Contact support for any queries regarding verification.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF1E3A8A)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}