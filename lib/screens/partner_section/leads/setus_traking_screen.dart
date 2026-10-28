import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../../../../constants/theme/app_text_styles.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../p_models/partner_model_screen.dart';

class LeadStatusTrackingScreen extends StatelessWidget {
  final PartnerLeadModel lead;

  const LeadStatusTrackingScreen({
    super.key,
    required this.lead,
  });

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

                    // 1. Customer Summary Card with Call/WhatsApp
                    _buildCustomerSummaryCard(context),
                    const SizedBox(height: 14),

                    // 2. Loan Overview 4-Grid
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

            // Bottom Buttons Bar
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
                        Text(
                          lead.customerName,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Existing Customer', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF16A36A))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(lead.phone, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                    Text(lead.email, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                    Text(lead.city, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Text(
                'Lead ID: ${lead.id}',
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
                  onPressed: () {},
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
                  onPressed: () {},
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
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined, size: 15),
                  label: const Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.border),
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
              Expanded(child: _buildGridItem('Employment Type', 'Salaried')),
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
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Current Status: Under Review',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF0284C7)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Horizontal Numbered Stepper (1 to 5)
          Row(
            children: [
              _buildStepNode('1. Submitted', '12 Sep 2024\n10:30 AM', true, true),
              _buildStepNode('2. Under Review', '13 Sep 2024\n09:15 AM', true, false),
              _buildStepNode('3. Approved', '', false, false),
              _buildStepNode('4. Disbursed', '', false, false),
              _buildStepNode('5. Closed', '', false, false, isLast: true),
            ],
          ),
          const SizedBox(height: 16),

          // Info Callout Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: const Text(
              'Your customer\'s application is currently under review by our loan team. We will update you once we receive the next update.',
              style: TextStyle(fontSize: 11.5, color: Color(0xFF1E40AF), height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepNode(String title, String date, bool completed, bool passed, {bool isLast = false}) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: completed ? AppColors.secondary : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: completed ? AppColors.secondary : AppColors.border, width: 2),
                ),
                child: completed ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2.5,
                    color: passed ? AppColors.secondary : AppColors.border,
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
        'date': '13 Sep 2024, 09:15 AM',
        'title': 'Application Under Review',
        'desc': 'Documents verified. Application is under review by credit team.',
      },
      {
        'date': '12 Sep 2024, 02:30 PM',
        'title': 'Documents Submitted',
        'desc': 'All required documents have been submitted successfully.',
      },
      {
        'date': '12 Sep 2024, 10:30 AM',
        'title': 'Lead Created',
        'desc': 'Lead created by you.',
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
      {'name': 'Aadhaar Card', 'size': 'PDF • 1.2 MB'},
      {'name': 'PAN Card', 'size': 'PDF • 980 KB'},
      {'name': 'Salary Slip', 'size': 'PDF • 1.5 MB'},
      {'name': 'Bank Statement', 'size': 'PDF • 2.1 MB'},
      {'name': 'Photograph', 'size': 'JPG • 450 KB'},
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
              const Text('Submitted Documents', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
              InkWell(
                onTap: () {},
                child: const Text('View All >', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary)),
              ),
            ],
          ),
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
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.border),
                minimumSize: const Size(0, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Update Information', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 10),
          // Expanded(
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (_) => const PartnerSupportScreen()),
          //       );
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: const Color(0xFF0F3E38),
          //       elevation: 0,
          //       minimumSize: const Size(0, 46),
          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          //     ),
          //     child: const Text('Contact Support', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
          //   ),
          // ),
        ],
      ),
    );
  }
}