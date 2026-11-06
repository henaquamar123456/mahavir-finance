import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class CustomerDetailsAdminScreen extends StatefulWidget {
  final Map<String, dynamic>? customerData;

  const CustomerDetailsAdminScreen({super.key, this.customerData});

  @override
  State<CustomerDetailsAdminScreen> createState() =>
      _CustomerDetailsAdminScreenState();
}

class _CustomerDetailsAdminScreenState
    extends State<CustomerDetailsAdminScreen> {
  int _selectedTab = 0;

  final List<String> _tabs = [
    'Overview',
    'Inquiries (3)',
    'Documents (5)',
    'Activity History',
    'Notes (2)',
  ];

  @override
  Widget build(BuildContext context) {
    final name = widget.customerData?['name'] ?? 'Amit Shah';
    final code = widget.customerData?['code'] ?? 'CUST001234';
    final phone = widget.customerData?['phone'] ?? '+91 9876543210';
    final email = widget.customerData?['email'] ?? 'amit.shah@gmail.com';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBreadcrumb(context),
              const SizedBox(height: 12),
              _buildHeaderTitleRow(),
              const SizedBox(height: 14),
              _buildCustomerMetaStrip(code),
              const SizedBox(height: 14),
              _buildTabsRow(),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 900;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              _buildProfileCard(name, phone, email),
                              const SizedBox(height: 14),
                              _buildPersonalInformationCard(name, phone, email),
                              const SizedBox(height: 14),
                              _buildEmploymentIncomeCard(),
                              const SizedBox(height: 14),
                              _buildKycInformationCard(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          flex: 6,
                          child: Column(
                            children: [
                              _buildLoanInquiriesCard(),
                              const SizedBox(height: 14),
                              _buildSubmittedDocumentsCard(),
                              const SizedBox(height: 14),
                              _buildRecentActivityCard(),
                              const SizedBox(height: 14),
                              _buildInternalNotesCard(),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      _buildProfileCard(name, phone, email),
                      const SizedBox(height: 14),
                      _buildPersonalInformationCard(name, phone, email),
                      const SizedBox(height: 14),
                      _buildEmploymentIncomeCard(),
                      const SizedBox(height: 14),
                      _buildKycInformationCard(),
                      const SizedBox(height: 14),
                      _buildLoanInquiriesCard(),
                      const SizedBox(height: 14),
                      _buildSubmittedDocumentsCard(),
                      const SizedBox(height: 14),
                      _buildRecentActivityCard(),
                      const SizedBox(height: 14),
                      _buildInternalNotesCard(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBreadcrumb(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.arrow_back_ios_new_rounded,
                size: 13, color: Color(0xFF0F3E38)),
            SizedBox(width: 6),
            Text(
              'Back to Customer List',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F3E38),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Row ke andar Wrap ki jagah Row(mainAxisSize: MainAxisSize.min) kiya gaya hai:
  Widget _buildHeaderTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Customer Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'View complete profile, inquiries and history.',
              style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
              label: const Text(
                'Add New Inquiry',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3E38),
                elevation: 0,
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined,
                  size: 15, color: AppColors.primary),
              label: const Text(
                'Edit Customer',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                children: [
                  Text('More',
                      style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                  Icon(Icons.keyboard_arrow_down_rounded,
                      size: 16, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomerMetaStrip(String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 8,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _buildMetaItem('Customer ID', code, isBold: true),
          _buildMetaItem('Registered On', '12 Sep 2024'),
          _buildMetaItem('Last Activity', '10 Sep 2024'),
          _buildMetaItem('Total Inquiries', '3'),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Account Status: ',
                  style: TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF16A36A),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildQuickActionButton(
                  Icons.phone_outlined, 'Call', const Color(0xFF0F3E38)),
              const SizedBox(width: 6),
              _buildQuickActionButton(Icons.chat_bubble_outline_rounded,
                  'WhatsApp', const Color(0xFF16A36A)),
              const SizedBox(width: 6),
              _buildQuickActionButton(
                  Icons.email_outlined, 'Email', const Color(0xFF0284C7)),
              const SizedBox(width: 6),
              _buildQuickActionButton(
                  Icons.sms_outlined, 'Send SMS', const Color(0xFFD97706)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ',
            style:
            const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
            color: isBold ? const Color(0xFF0F3E38) : AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(IconData icon, String tooltip, Color col) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: col.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 14, color: col),
        tooltip: tooltip,
        onPressed: () {},
      ),
    );
  }

  Widget _buildTabsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedTab = index),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0F3E38) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0F3E38)
                        : AppColors.border,
                  ),
                ),
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProfileCard(String name, String phone, String email) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFF0F3E38).withOpacity(0.1),
            child: Text(
              name.isNotEmpty ? name[0] : 'C',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F3E38),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF16A36A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(phone,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
                Text(email,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
                const Text('Noida, Uttar Pradesh',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInformationCard(
      String name, String phone, String email) {
    return _buildSectionCard(
      title: 'Personal Information',
      onEdit: () {},
      child: Column(
        children: [
          _buildInfoRow2('Full Name', name, 'Date of Birth',
              '15 Mar 1992 (32 years)'),
          const Divider(height: 14, color: AppColors.divider),
          _buildInfoRow2('Gender', 'Male', 'Mobile Number', phone),
          const Divider(height: 14, color: AppColors.divider),
          _buildInfoRow2(
              'Email Address', email, 'Alternate Number', '+91 9123456789'),
          const Divider(height: 14, color: AppColors.divider),
          _buildSingleInfoRow('Address',
              'A-102, Sector 62,\nNoida, Uttar Pradesh - 201309'),
        ],
      ),
    );
  }

  Widget _buildEmploymentIncomeCard() {
    return _buildSectionCard(
      title: 'Employment & Income',
      onEdit: () {},
      child: Column(
        children: [
          _buildInfoRow2('Employment Type', 'Salaried', 'Company Name',
              'TCS Pvt. Ltd.'),
          const Divider(height: 14, color: AppColors.divider),
          _buildInfoRow2('Designation', 'Software Engineer', 'Monthly Income',
              '₹1,20,000',
              isBoldSecond: true),
        ],
      ),
    );
  }

  Widget _buildKycInformationCard() {
    return _buildSectionCard(
      title: 'KYC Information',
      onEdit: () {},
      child: Column(
        children: [
          _buildInfoRow2('Aadhaar Number', 'XXXX-XXXX-4589', 'PAN Number',
              'ABCDE1234F'),
          const Divider(height: 14, color: AppColors.divider),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Address Proof',
                        style: TextStyle(
                            fontSize: 10.5, color: AppColors.textSecondary)),
                    const SizedBox(height: 3),
                    _buildVerifiedBadge('Verified'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Identity Proof',
                        style: TextStyle(
                            fontSize: 10.5, color: AppColors.textSecondary)),
                    const SizedBox(height: 3),
                    _buildVerifiedBadge('Verified'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoanInquiriesCard() {
    final inquiries = [
      {
        'id': '1',
        'type': 'Home Loan',
        'amount': '₹25,00,000',
        'status': 'Approved',
        'statusBg': const Color(0xFFDCFCE7),
        'statusCol': const Color(0xFF16A36A),
        'appliedOn': '12 Sep 2024',
      },
      {
        'id': '2',
        'type': 'Car Loan',
        'amount': '₹8,00,000',
        'status': 'Under Review',
        'statusBg': const Color(0xFFE0F2FE),
        'statusCol': const Color(0xFF0284C7),
        'appliedOn': '15 Aug 2024',
      },
      {
        'id': '3',
        'type': 'Personal Loan',
        'amount': '₹5,00,000',
        'status': 'Rejected',
        'statusBg': const Color(0xFFFEE2E2),
        'statusCol': const Color(0xFFDC2626),
        'appliedOn': '10 Jun 2024',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Loan Inquiries',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F3E38),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor:
              WidgetStateProperty.all(const Color(0xFFF8FAFC)),
              headingRowHeight: 38,
              dataRowMinHeight: 46,
              dataRowMaxHeight: 48,
              horizontalMargin: 8,
              columnSpacing: 22,
              columns: const [
                DataColumn(
                    label: Text('#',
                        style: TextStyle(
                            fontSize: 10.5, fontWeight: FontWeight.w800))),
                DataColumn(
                    label: Text('Loan Type',
                        style: TextStyle(
                            fontSize: 10.5, fontWeight: FontWeight.w800))),
                DataColumn(
                    label: Text('Requested Amount',
                        style: TextStyle(
                            fontSize: 10.5, fontWeight: FontWeight.w800))),
                DataColumn(
                    label: Text('Status',
                        style: TextStyle(
                            fontSize: 10.5, fontWeight: FontWeight.w800))),
                DataColumn(
                    label: Text('Applied On',
                        style: TextStyle(
                            fontSize: 10.5, fontWeight: FontWeight.w800))),
                DataColumn(
                    label: Text('Action',
                        style: TextStyle(
                            fontSize: 10.5, fontWeight: FontWeight.w800))),
              ],
              rows: inquiries.map((inq) {
                return DataRow(
                  cells: [
                    DataCell(Text(inq['id'] as String,
                        style: const TextStyle(fontSize: 11))),
                    DataCell(Text(inq['type'] as String,
                        style: const TextStyle(
                            fontSize: 11.5, fontWeight: FontWeight.w700))),
                    DataCell(Text(inq['amount'] as String,
                        style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary))),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: inq['statusBg'] as Color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          inq['status'] as String,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: inq['statusCol'] as Color,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(inq['appliedOn'] as String,
                        style: const TextStyle(fontSize: 10.5))),
                    DataCell(
                      InkWell(
                        onTap: () {},
                        child: const Text(
                          'View',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F3E38),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmittedDocumentsCard() {
    final docs = [
      {'name': 'Aadhaar Card', 'date': '12 Sep 2024'},
      {'name': 'PAN Card', 'date': '12 Sep 2024'},
      {'name': 'Address Proof', 'date': '12 Sep 2024'},
      {'name': 'Income Proof', 'date': '12 Sep 2024'},
      {'name': 'Bank Statement', 'date': '12 Sep 2024'},
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F3E38),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: docs.map((doc) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.description_outlined,
                        size: 16, color: Color(0xFF0284C7)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc['name']!,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            doc['date']!,
                            style: const TextStyle(
                              fontSize: 9.5,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildVerifiedBadge('Verified'),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.download_rounded,
                          size: 16, color: Color(0xFF0F3E38)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
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

  Widget _buildRecentActivityCard() {
    final activities = [
      {
        'time': '10 Sep 2024, 10:30 AM',
        'title': 'Loan approved for Home Loan (₹25,00,000)',
        'isApproved': true,
      },
      {
        'time': '09 Sep 2024, 04:15 PM',
        'title': 'Document verified - Income Proof',
        'isApproved': false,
      },
      {
        'time': '08 Sep 2024, 02:20 PM',
        'title': 'Customer submitted loan inquiry (Home Loan)',
        'isApproved': false,
      },
      {
        'time': '15 Aug 2024, 11:45 AM',
        'title': 'Car Loan inquiry status updated to Under Review',
        'isApproved': false,
      },
      {
        'time': '10 Jun 2024, 09:00 AM',
        'title': 'Personal Loan inquiry rejected',
        'isApproved': false,
        'isRejected': true,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: activities.map((act) {
              final isApproved = act['isApproved'] == true;
              final isRejected = act['isRejected'] == true;

              Color dotCol = const Color(0xFF0284C7);
              if (isApproved) dotCol = const Color(0xFF16A36A);
              if (isRejected) dotCol = const Color(0xFFDC2626);

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: CircleAvatar(radius: 4, backgroundColor: dotCol),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            act['time'] as String,
                            style: const TextStyle(
                              fontSize: 9.5,
                              color: AppColors.textHint,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            act['title'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildInternalNotesCard() {
    final notes = [
      {
        'author': 'Rohit Kumar (Loan Officer)',
        'time': '10 Sep 2024, 11:20 AM',
        'note':
        'Customer profile is eligible. All documents verified. Approved for Home Loan ₹25,00,000.',
      },
      {
        'author': 'Priya Singh (Support)',
        'time': '15 Aug 2024, 02:10 PM',
        'note':
        'Customer requested better interest rate for Car Loan. Follow up next week.',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Internal Notes',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              InkWell(
                onTap: () {},
                child: const Row(
                  children: [
                    Icon(Icons.add, size: 13, color: Color(0xFF0F3E38)),
                    SizedBox(width: 2),
                    Text(
                      'Add Note',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F3E38),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: notes.map((n) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          n['author']!,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F3E38),
                          ),
                        ),
                        Text(
                          n['time']!,
                          style: const TextStyle(
                            fontSize: 9.5,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      n['note']!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
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

  Widget _buildSectionCard({
    required String title,
    required Widget child,
    VoidCallback? onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              if (onEdit != null)
                InkWell(
                  onTap: onEdit,
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F3E38),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow2(String l1, String v1, String l2, String v2,
      {bool isBoldSecond = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l1,
                  style: const TextStyle(
                      fontSize: 10.5, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(v1,
                  style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l2,
                  style: const TextStyle(
                      fontSize: 10.5, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(
                v2,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight:
                  isBoldSecond ? FontWeight.w900 : FontWeight.w700,
                  color: isBoldSecond
                      ? const Color(0xFF0F3E38)
                      : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSingleInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 10.5, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      height: 1.25)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerifiedBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: Color(0xFF16A36A),
        ),
      ),
    );
  }
}