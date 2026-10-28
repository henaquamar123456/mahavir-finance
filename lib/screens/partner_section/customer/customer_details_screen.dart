import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../leads/add_new_lead_screen.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? customer;

  const CustomerDetailsScreen({super.key, this.customer});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final customerName = widget.customer?['name'] ?? 'Amit Shah';
    final customerPhone = widget.customer?['phone'] ?? '+91 98765 43210';
    final customerEmail = widget.customer?['email'] ?? 'amit.shah@gmail.com';
    final customerCity = widget.customer?['city'] ?? 'Ahmedabad, Gujarat';
    final customerId = widget.customer?['id'] ?? 'CUST00124';

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
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
              child: const Icon(Icons.person, size: 20, color: Color(0xFF0F3E38)),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Title
                    const Text(
                      'Customer Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'View customer profile, loan details and complete lead history.',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),

                    // 1. Hero Customer Overview Card
                    _buildCustomerHeroCard(
                      name: customerName,
                      id: customerId,
                      phone: customerPhone,
                      email: customerEmail,
                      city: customerCity,
                    ),
                    const SizedBox(height: 14),

                    // 2. Personal Information Card
                    _buildPersonalInformationCard(
                      name: customerName,
                      phone: customerPhone,
                      email: customerEmail,
                    ),
                    const SizedBox(height: 14),

                    // 3. Employment & Income Details Card
                    _buildEmploymentDetailsCard(),
                    const SizedBox(height: 14),

                    // 4. Loan Requirement Card
                    _buildLoanRequirementCard(),
                    const SizedBox(height: 14),

                    // 5. Lead History Card
                    _buildLeadHistoryCard(),
                    const SizedBox(height: 14),

                    // 6. Submitted Documents Card
                    _buildSubmittedDocumentsCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Sticky Bar (Call Customer, WhatsApp, Add New Lead)
            _buildBottomActionBar(context, customerPhone),
          ],
        ),
      ),
    );
  }

  // 1. Hero Customer Card
  Widget _buildCustomerHeroCard({
    required String name,
    required String id,
    required String phone,
    required String email,
    required String city,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
                child: const Icon(Icons.person, size: 30, color: Color(0xFF0F3E38)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Customer ID: $id',
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _buildBadge('Verified', const Color(0xFFDCFCE7), const Color(0xFF16A36A)),
                        _buildBadge('Existing Customer', const Color(0xFFEFF6FF), const Color(0xFF0284C7)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Active Customer',
                  style: TextStyle(
                    fontSize: 10.5,
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
          _buildInfoRow(Icons.phone_outlined, phone),
          const SizedBox(height: 6),
          _buildInfoRow(Icons.email_outlined, email),
          const SizedBox(height: 6),
          _buildInfoRow(Icons.cake_outlined, '15 Mar 1990 (34 years)'),
          const SizedBox(height: 6),
          _buildInfoRow(Icons.location_on_outlined, city),
        ],
      ),
    );
  }

  // 2. Personal Information Card
  Widget _buildPersonalInformationCard({
    required String name,
    required String phone,
    required String email,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(
            icon: Icons.person_outline_rounded,
            iconColor: const Color(0xFF16A36A),
            title: 'Personal Information',
            onEdit: () {},
          ),
          const SizedBox(height: 12),
          _buildTwoColRow('Full Name', name, 'Date of Birth', '15 Mar 1990'),
          const Divider(height: 16, color: AppColors.divider),
          _buildTwoColRow('Mobile Number', phone, 'Address', '203, Satellite Road,\nAhmedabad, Gujarat - 380015'),
          const Divider(height: 16, color: AppColors.divider),
          _buildTwoColRow('Email Address', email, '', ''),
        ],
      ),
    );
  }

  // 3. Employment & Income Details Card
  Widget _buildEmploymentDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(
            icon: Icons.business_center_outlined,
            iconColor: const Color(0xFF0284C7),
            title: 'Employment & Income Details',
            onEdit: () {},
          ),
          const SizedBox(height: 12),
          _buildTwoColRow('Employment Type', 'Salaried', 'Monthly Income', '₹75,000', isBoldSecond: true),
          const Divider(height: 16, color: AppColors.divider),
          _buildTwoColRow('Company Name', 'TCS Pvt. Ltd.', 'Work Experience', '5 Years'),
          const Divider(height: 16, color: AppColors.divider),
          _buildTwoColRow('PAN Number', 'ABCDE1234F', '', ''),
        ],
      ),
    );
  }

  // 4. Loan Requirement Card
  Widget _buildLoanRequirementCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(
            icon: Icons.assignment_outlined,
            iconColor: const Color(0xFFD97706),
            title: 'Loan Requirement',
            onEdit: () {},
          ),
          const SizedBox(height: 12),
          _buildTwoColRow('Loan Category', 'Car Loan', 'Loan Tenure', '5 Years'),
          const Divider(height: 16, color: AppColors.divider),
          _buildTwoColRow('Requested Amount', '₹8,00,000', 'Purpose', 'New Car Purchase', isBoldFirst: true),
        ],
      ),
    );
  }

  // 5. Lead History Card
  Widget _buildLeadHistoryCard() {
    final history = [
      {
        'time': '13 Sep 2024, 09:15 AM',
        'status': 'Under Review',
        'desc': 'Documents verified. Application is under review by credit team.',
        'isCurrent': true,
      },
      {
        'time': '12 Sep 2024, 02:30 PM',
        'status': 'Documents Submitted',
        'desc': 'All required documents have been submitted successfully.',
        'isCurrent': false,
      },
      {
        'time': '12 Sep 2024, 10:30 AM',
        'status': 'Lead Created',
        'desc': 'Lead created by you.',
        'isCurrent': false,
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
              Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.history_rounded, size: 16, color: Color(0xFF16A36A)),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Lead History',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                ],
              ),
              InkWell(
                onTap: () {},
                child: const Text(
                  'View All >',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...history.map((h) {
            final isCurrent = h['isCurrent'] as bool;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: isCurrent ? const Color(0xFF0284C7) : const Color(0xFFCBD5E1),
                    ),
                    Container(
                      width: 1.5,
                      height: 42,
                      color: const Color(0xFFE2E8F0),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            h['time'] as String,
                            style: const TextStyle(fontSize: 10, color: AppColors.textHint, fontWeight: FontWeight.w600),
                          ),
                          if (isCurrent)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                h['status'] as String,
                                style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Color(0xFF0284C7)),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        h['desc'] as String,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // 6. Submitted Documents Card
  Widget _buildSubmittedDocumentsCard() {
    final docs = [
      {'name': 'Aadhaar Card', 'info': 'PDF • 1.2 MB'},
      {'name': 'PAN Card', 'info': 'PDF • 980 KB'},
      {'name': 'Salary Slip', 'info': 'PDF • 1.5 MB'},
      {'name': 'Bank Statement', 'info': 'PDF • 2.1 MB'},
      {'name': 'Photograph', 'info': 'JPG • 450 KB'},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
            children: const [
              Text(
                'Submitted Documents',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
              Text(
                'View All >',
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: docs.map((doc) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.picture_as_pdf_outlined, size: 16, color: Color(0xFFEF4444)),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc['name']!,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                        Text(
                          doc['info']!,
                          style: const TextStyle(fontSize: 9.5, color: AppColors.textHint),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Bottom Floating Bar
  Widget _buildBottomActionBar(BuildContext context, String phone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calling $phone...')),
                );
              },
              icon: const Icon(Icons.phone_outlined, size: 15, color: Color(0xFF0F3E38)),
              label: const Text(
                'Call Customer',
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening WhatsApp for $phone...')),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 15, color: Color(0xFF16A36A)),
            label: const Text(
              'WhatsApp',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF16A36A)),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              side: const BorderSide(color: Color(0xFFBBF7D0)),
              backgroundColor: const Color(0xFFDCFCE7).withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddNewLeadScreen()),
                );
              },
              icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
              label: const Text(
                'Add New Lead',
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3E38),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onEdit,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary),
            ),
          ],
        ),
        InkWell(
          onTap: onEdit,
          child: const Text(
            'Edit',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color bg, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.iconSecondary),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 11.5, color: AppColors.textPrimary))),
      ],
    );
  }

  Widget _buildTwoColRow(String l1, String v1, String l2, String v2, {bool isBoldFirst = false, bool isBoldSecond = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l1, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(
                v1,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isBoldFirst ? FontWeight.w900 : FontWeight.w700,
                  color: isBoldFirst ? const Color(0xFF0F3E38) : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        if (l2.isNotEmpty)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l2, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(
                  v2,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isBoldSecond ? FontWeight.w900 : FontWeight.w700,
                    color: isBoldSecond ? const Color(0xFF0F3E38) : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}