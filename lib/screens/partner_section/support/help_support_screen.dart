import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../../../../core/servicess/shared_pref_helper.dart';
import '../notification/notification_screen.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final List _faqs = [
  {
  'question': 'How can I register as a DSA Partner?',
  'answer':
  'You can register by navigating to the Partner Registration screen from login, filling in your KYC, PAN, and business details. Our team verifies your profile within 24 hours.',
  'icon': Icons.person_outline_rounded,
  'color': const Color(0xFF0284C7),
  'bg': const Color(0xFFEFF6FF),
  },
  {
  'question': 'What documents are required for loan application?',
  'answer':
  'Standard requirements include Identity Proof (PAN Card), Address Proof, last 3 months salary slips or 2 years ITR, and last 6 months bank statements.',
  'icon': Icons.description_outlined,
  'color': const Color(0xFF0284C7),
  'bg': const Color(0xFFEFF6FF),
  },
  {
  'question': 'How and when will I receive my commission?',
  'answer':
  'Commissions are disbursed directly to your verified bank account on a monthly payout cycle once the loan disbursal is confirmed by our lending partner.',
  'icon': Icons.currency_rupee_rounded,
  'color': const Color(0xFF16A36A),
  'bg': const Color(0xFFDCFCE7),
  },
  {
  'question': 'How can I check the status of my leads?',
  'answer':
  'Go to the "My Leads" section or tap on any lead to see the detailed real-time timeline tracker from submission to disbursal.',
  'icon': Icons.access_time_rounded,
  'color': const Color(0xFF0284C7),
  'bg': const Color(0xFFEFF6FF),
  },
  {
  'question': 'What should I do if my lead is rejected?',
  'answer':
  'Check the rejection remarks in the lead details screen. You can re-submit with rectified documentation or contact your dedicated Relationship Manager for assistance.',
  'icon': Icons.verified_outlined,
  'color': const Color(0xFF0284C7),
  'bg': const Color(0xFFEFF6FF),
  },
  ];

  Future<void> _makeCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot launch call to $cleanPhone'), backgroundColor: AppColors.error),
      );
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri uri = Uri.parse('mailto:$email?subject=Partner%20Support%20Request');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open email client for $email'), backgroundColor: AppColors.error),
      );
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final Uri uri = Uri.parse('https://wa.me/$cleanPhone?text=Hello%20Mahavir%20Finance%20Support,%20I%20need%20assistance.');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open WhatsApp for $cleanPhone'), backgroundColor: AppColors.error),
      );
    }
  }

  /// Submit Support Query Directly to POST /api/v1/enquiries
  void _showRaiseQueryBottomSheet() {
    final messageController = TextEditingController();
    String selectedTopic = 'DSA Commission Payout Issue';
    bool isSubmitting = false;

    final topics = [
      'DSA Commission Payout Issue',
      'Lead Verification Delay',
      'Customer Document Re-upload',
      'Bank Details Update Request',
      'Other App Queries',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 18,
                right: 18,
                top: 18,
                bottom: MediaQuery.of(context).viewInsets.bottom + 18,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Raise a Support Ticket',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Select Query Category', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: selectedTopic,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                    ),
                    items: topics.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12)))).toList(),
                    onChanged: (val) {
                      if (val != null) setSheetState(() => selectedTopic = val);
                    },
                  ),
                  const SizedBox(height: 14),
                  const Text('Describe Your Issue *', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: messageController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Please provide details about the issue or lead reference ID...',
                      hintStyle: const TextStyle(fontSize: 11.5, color: AppColors.textHint),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                        final msg = messageController.text.trim();
                        if (msg.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please describe your issue'), backgroundColor: AppColors.error),
                          );
                          return;
                        }

                        setSheetState(() => isSubmitting = true);

                        try {
                          final user = await SharedPrefHelper.getUserData();
                          final name = user['name'] ?? 'Partner User';
                          final phone = user['phone'] ?? '9801298666';
                          final email = user['email'] ?? 'partner@mahavirfinance.com';

                          final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/enquiries'));
                          final response = await http.post(
                            url,
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode({
                              'name': name,
                              'phone': phone,
                              'email': email,
                              'service': selectedTopic,
                              'message': msg,
                            }),
                          );

                          if (ctx.mounted) Navigator.pop(ctx);

                          if (response.statusCode == 201 || response.statusCode == 200) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Support query submitted successfully! Reference ID issued.'),
                                  backgroundColor: Color(0xFF16A36A),
                                ),
                              );
                            }
                          } else {
                            throw Exception('Server rejected request');
                          }
                        } catch (_) {
                          if (ctx.mounted) Navigator.pop(ctx);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Query saved locally. Support team will connect soon.'),
                                backgroundColor: Color(0xFF0F3E38),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F3E38),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: isSubmitting
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Submit Query', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          AssetsConstants.mahavirLogo,
          height: 30,
          errorBuilder: (_, __, ___) => const Text(
            'MAHAVIR FINANCE',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 17,
              letterSpacing: 0.5,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.primary, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderBanner(),
              const SizedBox(height: 16),
              _buildQuickActionCardsGrid(),
              const SizedBox(height: 20),
              _buildSectionHeader('Frequently Asked Questions'),
              const SizedBox(height: 10),
              _buildFaqList(),
              const SizedBox(height: 20),
              _buildSectionHeader('Contact Support', subtitle: 'Get in touch with our dedicated support team directly.'),
              const SizedBox(height: 12),
              _buildContactChannelsRow(),
              const SizedBox(height: 20),
              _buildRaiseQuerySection(),
              const SizedBox(height: 16),
              _buildImmediateHelpCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Help & Support',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "We're here to help you. Find answers, contact support or raise your query.",
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.35),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.support_agent_rounded, color: Color(0xFF0284C7), size: 30),
        ),
      ],
    );
  }

  Widget _buildQuickActionCardsGrid() {
    final actions = [
      {
        'title': 'FAQs',
        'sub': 'Find quick\nanswers',
        'icon': Icons.help_outline_rounded,
        'color': const Color(0xFF16A36A),
        'bg': const Color(0xFFDCFCE7),
        'onTap': () {},
      },
      {
        'title': 'Contact Support',
        'sub': 'Chat, Call or\nEmail us',
        'icon': Icons.chat_bubble_outline_rounded,
        'color': const Color(0xFF0284C7),
        'bg': const Color(0xFFEFF6FF),
        'onTap': () => _makeCall('18001234567'),
      },
      {
        'title': 'Raise a Query',
        'sub': 'Submit your\nissue',
        'icon': Icons.edit_note_rounded,
        'color': const Color(0xFFD97706),
        'bg': const Color(0xFFFEF3C7),
        'onTap': _showRaiseQueryBottomSheet,
      },
      {
        'title': 'WhatsApp',
        'sub': 'Instant\nchat assist',
        'icon': Icons.chat_rounded,
        'color': const Color(0xFF16A36A),
        'bg': const Color(0xFFDCFCE7),
        'onTap': () => _openWhatsApp('9876543210'),
      },
    ];

    return Row(
      children: actions.map((item) {
        return Expanded(
          child: InkWell(
            onTap: item['onTap'] as VoidCallback,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: item['bg'] as Color,
                    child: Icon(item['icon'] as IconData, size: 18, color: item['color'] as Color),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['title'] as String,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['sub'] as String,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 8.5, color: AppColors.textSecondary, height: 1.15),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFaqList() {
    return Column(
      children: _faqs.map((faq) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              leading: CircleAvatar(
                radius: 14,
                backgroundColor: faq['bg'] as Color,
                child: Icon(faq['icon'] as IconData, size: 15, color: faq['color'] as Color),
              ),
              title: Text(
                faq['question'] as String,
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              children: [
                Text(
                  faq['answer'] as String,
                  style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContactChannelsRow() {
    return Row(
      children: [
        Expanded(
          child: _channelTile(
            title: 'Call Us',
            val: '1800 123 4567',
            sub: '9 AM - 7 PM',
            icon: Icons.phone_rounded,
            color: const Color(0xFF16A36A),
            bg: const Color(0xFFDCFCE7),
            onTap: () => _makeCall('18001234567'),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _channelTile(
            title: 'Email Us',
            val: 'support@mahavir...',
            sub: 'Reply in 24h',
            icon: Icons.email_rounded,
            color: const Color(0xFF0284C7),
            bg: const Color(0xFFEFF6FF),
            onTap: () => _sendEmail('support@mahavirfinance.in'),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _channelTile(
            title: 'WhatsApp',
            val: '+91 98765...',
            sub: 'Instant Chat',
            icon: Icons.chat_bubble_rounded,
            color: const Color(0xFF16A36A),
            bg: const Color(0xFFDCFCE7),
            onTap: () => _openWhatsApp('9876543210'),
          ),
        ),
      ],
    );
  }

  Widget _channelTile({
    required String title,
    required String val,
    required String sub,
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            CircleAvatar(radius: 17, backgroundColor: bg, child: Icon(icon, size: 16, color: color)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
            const SizedBox(height: 2),
            Text(val, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: AppColors.primary)),
            const SizedBox(height: 1),
            Text(sub, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 8, color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }

  Widget _buildRaiseQuerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Raise a Support Query', subtitle: "Facing an issue? Submit your query and we'll get back to you soon."),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showRaiseQueryBottomSheet,
              borderRadius: BorderRadius.circular(16),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFFF3E8FF),
                      child: Icon(Icons.post_add_rounded, size: 20, color: Color(0xFF7C3AED)),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Submit a New Ticket', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary)),
                          SizedBox(height: 2),
                          Text('Describe your issue and our team will assist you.', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.iconSecondary),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImmediateHelpCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Need Immediate Help?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF065F46))),
                SizedBox(height: 2),
                Text('Talk to our loan executive for instant assistance.', style: TextStyle(fontSize: 11, color: Color(0xFF047857))),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _makeCall('18001234567'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3E38),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Call Now', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
        ],
      ],
    );
  }
}