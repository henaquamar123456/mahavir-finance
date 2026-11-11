import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../../../../constants/theme/app_text_styles.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../p_models/partner_model_screen.dart';
import '../support/help_support_screen.dart';

class LeadStatusTrackingScreen extends StatelessWidget {
  final PartnerLeadModel lead;

  const LeadStatusTrackingScreen({
    super.key,
    required this.lead,
  });

  Future<void> _makeCall(BuildContext context, String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to call $cleanPhone'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _openWhatsApp(BuildContext context, String phone, String name) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final String url =
        'https://wa.me/$cleanPhone?text=Hello%20$name,%20greetings%20from%20Mahavir%20Finance!';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open WhatsApp for $cleanPhone'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

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
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lead Status Tracking',
                      style: AppTextStyles.headingLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Track the status of your referred customer loan application.',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 14),

                    // 1. Customer Summary Card
                    _buildCustomerSummaryCard(context),
                    const SizedBox(height: 14),

                    // 2. Loan Overview Grid
                    _buildLoanOverviewGrid(),
                    const SizedBox(height: 14),

                    // 3. Application Status & Stages Stepper
                    _buildApplicationStatusCard(),
                    const SizedBox(height: 14),

                    // 4. Recent Updates Timeline
                    _buildRecentUpdatesTimeline(),
                    const SizedBox(height: 14),

                    // 5. Submitted Documents Preview
                    _buildDocumentsPreviewCard(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom Actions Bar
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSummaryCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: lead.iconColor.withValues(alpha: 0.12),
                child: Icon(Icons.person, color: lead.iconColor, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            lead.customerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Referred Lead', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF16A36A))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(lead.phone.isNotEmpty ? lead.phone : 'No Phone', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                    if (lead.email.isNotEmpty)
                      Text(lead.email, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                    Text(lead.city.isNotEmpty ? lead.city : 'India', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Text(
                'ID: ${lead.id}',
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _makeCall(context, lead.phone),
                  icon: const Icon(Icons.phone_in_talk_rounded, size: 15),
                  label: const Text('Call', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.border),
                    minimumSize: const Size(0, 38),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openWhatsApp(context, lead.phone, lead.customerName),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 15, color: Color(0xFF16A36A)),
                  label: const Text('WhatsApp', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF16A36A))),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFBBF7D0)),
                    backgroundColor: const Color(0xFFF0FDF4),
                    minimumSize: const Size(0, 38),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoanOverviewGrid() {
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
          const Text('Loan Overview', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildGridItem('Loan Category', lead.loanCategory)),
              Expanded(child: _buildGridItem('Requested Amount', CurrencyFormatter.formatWhole(lead.amount), isAmount: true)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildGridItem('Loan Tenure', lead.tenure)),
              Expanded(child: _buildGridItem('Est. Commission', CurrencyFormatter.formatWhole(lead.amount * 0.015), isAmount: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(String label, String value, {bool isAmount = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            color: isAmount ? AppColors.secondary : AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationStatusCard() {
    final isUnderReview = lead.status == PartnerLeadStatus.underReview || lead.status == PartnerLeadStatus.approved;
    final isApproved = lead.status == PartnerLeadStatus.approved;
    final isRejected = lead.status == PartnerLeadStatus.rejected;

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
              const Text('Application Status', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: lead.status.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Status: ${lead.status.label}',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: lead.status.textColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Horizontal Stepper Bar
          Row(
            children: [
              _buildStepNode('1. Submitted', lead.date, true, true),
              _buildStepNode('2. Under Review', isUnderReview ? 'In Review' : '', isUnderReview, isApproved || isRejected),
              _buildStepNode(isRejected ? '3. Rejected' : '3. Approved', isApproved ? 'Approved' : (isRejected ? 'Declined' : ''), isApproved || isRejected, isApproved, isFailed: isRejected),
              _buildStepNode('4. Disbursed', '', false, false),
              _buildStepNode('5. Closed', '', false, false, isLast: true),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isRejected ? const Color(0xFFFEF2F2) : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isRejected ? const Color(0xFFFECACA) : const Color(0xFFBFDBFE)),
            ),
            child: Text(
              isRejected
                  ? 'This application has been declined based on verification criteria. Please contact support for re-evaluation.'
                  : isApproved
                  ? 'Congratulations! The loan has been approved. Disbursal schedule will be issued shortly.'
                  : 'Your customer\'s application is currently under review by our credit team. Status will update dynamically.',
              style: TextStyle(
                fontSize: 11.5,
                color: isRejected ? const Color(0xFFB91C1C) : const Color(0xFF1E40AF),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepNode(String title, String date, bool completed, bool passed, {bool isLast = false, bool isFailed = false}) {
    final activeColor = isFailed ? AppColors.error : AppColors.secondary;

    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: completed ? activeColor : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: completed ? activeColor : AppColors.border, width: 2),
                ),
                child: completed
                    ? Icon(isFailed ? Icons.close : Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2.5,
                    color: passed ? activeColor : AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9, fontWeight: completed ? FontWeight.w700 : FontWeight.w500, color: AppColors.primary),
          ),
          if (date.isNotEmpty)
            Text(
              date,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 8, color: AppColors.textHint, height: 1.15),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentUpdatesTimeline() {
    final updates = [
      {
        'date': lead.date,
        'title': 'Current Status: ${lead.status.label}',
        'desc': 'Application record updated to ${lead.status.label}.',
      },
      {
        'date': lead.date,
        'title': 'Lead Created',
        'desc': 'Lead initiated by you under DSA referral program.',
      },
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
          const Text('Recent Updates', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),

          ...updates.map((u) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(u['date']!, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                        const SizedBox(height: 1),
                        Text(u['title']!, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        const SizedBox(height: 2),
                        Text(u['desc']!, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, height: 1.3)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDocumentsPreviewCard() {
    final docs = [
      {'name': 'Identity Document', 'size': 'PDF • 1.2 MB'},
      {'name': 'PAN Card', 'size': 'PDF • 980 KB'},
      {'name': 'Income Proof', 'size': 'PDF • 1.5 MB'},
      {'name': 'Bank Statement', 'size': 'PDF • 2.1 MB'},
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
          const Text('Submitted Documents', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: docs.map((doc) {
                return Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF0284C7), size: 22),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doc['name']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          Text(doc['size']!, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.border),
                minimumSize: const Size(0, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Back to Lead Details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3E38),
                elevation: 0,
                minimumSize: const Size(0, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Contact Support', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}