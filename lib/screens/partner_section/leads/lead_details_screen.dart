import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../../../../constants/theme/app_text_styles.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../p_models/partner_model_screen.dart';
import 'setus_traking_screen.dart';

class LeadDetailsScreen extends StatefulWidget {
  final PartnerLeadModel lead;

  const LeadDetailsScreen({super.key, required this.lead});

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  final List _documents = const [
    {'name': 'Identity Document', 'size': 'PDF • 1.2 MB'},
    {'name': 'PAN Card', 'size': 'PDF • 980 KB'},
    {'name': 'Salary Slip', 'size': 'PDF • 1.5 MB'},
    {'name': 'Bank Statement', 'size': 'PDF • 2.1 MB'},
    {'name': 'Photograph', 'size': 'JPG • 450 KB'},
  ];

  Future<void> _makeCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to place call to $cleanPhone'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _openWhatsApp(String phone, String name) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final String url =
        'https://wa.me/$cleanPhone?text=Hello%20$name,%20greetings%20from%20Mahavir%20Finance!';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open WhatsApp for $cleanPhone'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lead = widget.lead;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          AssetsConstants.mahavirLogo,
          height: 32,
          errorBuilder: (_, __, ___) => const Text(
            'Mahavir Finance',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(
                Icons.person,
                size: 20,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lead Details',
                      style: AppTextStyles.headingLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'View complete customer information, loan requirements and document details.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 1. Customer Information Card
                    _buildCustomerCard(lead),
                    const SizedBox(height: 14),

                    // 2. Loan Requirements Card
                    _buildLoanRequirementsCard(lead),
                    const SizedBox(height: 14),

                    // 3. Lead Status Progress Stepper
                    _buildLeadStatusSection(context, lead),
                    const SizedBox(height: 14),

                    // 4. Submitted Documents Card
                    _buildDocumentsCard(context),
                    const SizedBox(height: 14),

                    // 5. Additional Notes Card
                    _buildAdditionalNotesCard(lead),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom Action Bar
            _buildBottomActionBar(context, lead),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCard(PartnerLeadModel lead) {
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
                'Customer Information',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Active Lead',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF16A36A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: lead.iconColor.withValues(alpha: 0.12),
                child: Icon(Icons.person, color: lead.iconColor, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead.customerName,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lead.customerId.isNotEmpty
                          ? 'Customer ID: ${lead.customerId}'
                          : 'ID: Lead Ref #${lead.id.replaceAll('#', '')}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: lead.status.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  lead.status.label,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: lead.status.textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lead ID: ${lead.id}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Submitted: ${lead.date}',
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          _buildInfoRow(
            Icons.phone_outlined,
            lead.phone.isNotEmpty ? lead.phone : 'Not Provided',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.email_outlined,
            lead.email.isNotEmpty ? lead.email : 'Not Provided',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.location_on_outlined,
            lead.city.isNotEmpty ? lead.city : 'India',
          ),
        ],
      ),
    );
  }

  Widget _buildLoanRequirementsCard(PartnerLeadModel lead) {
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
          const Text(
            'Loan Requirements',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildRequirementBlock(
                  'Loan Category',
                  lead.loanCategory,
                ),
              ),
              Expanded(
                child: _buildRequirementBlock('Loan Tenure', lead.tenure),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildRequirementBlock(
                  'Requested Amount',
                  CurrencyFormatter.formatWhole(lead.amount),
                  isAmount: true,
                ),
              ),
              Expanded(
                child: _buildRequirementBlock(
                  'Employment Type',
                  'Salaried / Professional',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildRequirementBlock(
                  'Estimated Commission',
                  CurrencyFormatter.formatWhole(lead.amount * 0.015),
                ),
              ),
              Expanded(
                child: _buildRequirementBlock(
                  'Commission Rate',
                  '1.5% Standard',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementBlock(
    String label,
    String value, {
    bool isAmount = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: isAmount ? AppColors.secondary : AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildLeadStatusSection(BuildContext context, PartnerLeadModel lead) {
    final isUnderReview =
        lead.status == PartnerLeadStatus.underReview ||
        lead.status == PartnerLeadStatus.approved;
    final isApproved = lead.status == PartnerLeadStatus.approved;
    final isRejected = lead.status == PartnerLeadStatus.rejected;

    final stages = [
      {
        'name': 'Submitted',
        'date': lead.date,
        'completed': true,
        'isFailed': false,
      },
      {
        'name': 'Under Review',
        'date': isUnderReview ? 'In Review' : '',
        'completed': isUnderReview,
        'isFailed': false,
      },
      {
        'name': isRejected ? 'Rejected' : 'Approved',
        'date': isApproved ? 'Approved' : (isRejected ? 'Declined' : ''),
        'completed': isApproved || isRejected,
        'isFailed': isRejected,
      },
      {'name': 'Disbursed', 'date': '', 'completed': false, 'isFailed': false},
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
                'Lead Status',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LeadStatusTrackingScreen(lead: lead),
                    ),
                  );
                },
                child: const Text(
                  'View Timeline >',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(stages.length, (index) {
              final stage = stages[index];
              final isCompleted = stage['completed'] as bool;
              final isFailed = stage['isFailed'] as bool;
              final isLast = index == stages.length - 1;

              final Color activeColor = isFailed
                  ? AppColors.error
                  : AppColors.secondary;

              return Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2.5,
                            color: index == 0
                                ? Colors.transparent
                                : (isCompleted
                                      ? activeColor
                                      : AppColors.border),
                          ),
                        ),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: isCompleted ? activeColor : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCompleted
                                  ? activeColor
                                  : AppColors.border,
                              width: 2,
                            ),
                          ),
                          child: isCompleted
                              ? Icon(
                                  isFailed ? Icons.close : Icons.check,
                                  size: 13,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        Expanded(
                          child: Container(
                            height: 2.5,
                            color: isLast
                                ? Colors.transparent
                                : (index < 1 && isCompleted
                                      ? activeColor
                                      : AppColors.border),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      stage['name'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isCompleted
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isCompleted
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                    if ((stage['date'] as String).isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        stage['date'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 8.5,
                          color: AppColors.textHint,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsCard(BuildContext context) {
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
                'Submitted Documents',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Document upload dialog opened'),
                      backgroundColor: AppColors.secondary,
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline_rounded,
                      size: 16,
                      color: AppColors.secondary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Add Document',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),

          ..._documents.map(
            (doc) => _buildDocumentRow(doc['name']!, doc['size']!),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(String name, String size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.picture_as_pdf_rounded,
              color: Color(0xFF0284C7),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  size,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.visibility_outlined,
              size: 18,
              color: AppColors.iconSecondary,
            ),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Previewing $name')));
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.download_rounded,
              size: 18,
              color: AppColors.iconSecondary,
            ),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Downloading $name')));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalNotesCard(PartnerLeadModel lead) {
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
          const Text(
            'Additional Notes / Remarks',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lead created under your partner referral code. Customer is seeking ${lead.loanCategory} of ${CurrencyFormatter.formatWhole(lead.amount)} for ${lead.tenure}. Follow up regarding KYC documents.',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, PartnerLeadModel lead) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: OutlinedButton.icon(
              onPressed: () => _makeCall(lead.phone),
              icon: const Icon(Icons.phone_in_talk_rounded, size: 16),
              label: const Text(
                'Call',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.border),
                minimumSize: const Size(0, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          Expanded(
            flex: 3,
            child: OutlinedButton.icon(
              onPressed: () => _openWhatsApp(lead.phone, lead.customerName),
              icon: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 16,
                color: Color(0xFF16A36A),
              ),
              label: const Text(
                'WhatsApp',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF16A36A),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFBBF7D0)),
                backgroundColor: const Color(0xFFF0FDF4),
                minimumSize: const Size(0, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          Expanded(
            flex: 4,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LeadStatusTrackingScreen(lead: lead),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3E38),
                elevation: 0,
                minimumSize: const Size(0, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Track Status',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.iconSecondary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
