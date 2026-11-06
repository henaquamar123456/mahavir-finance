import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class CmsContentManagementScreen extends StatefulWidget {
  const CmsContentManagementScreen({super.key});

  @override
  State<CmsContentManagementScreen> createState() =>
      _CmsContentManagementScreenState();
}

class _CmsContentManagementScreenState
    extends State<CmsContentManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryTab = 0; // 0: Home Banners, 1: App Content, 2: FAQs, etc.

  final List<Map<String, dynamic>> _categoryTabs = [
    {
      'title': 'Home Banners',
      'subtitle': 'Manage app banner sliders',
      'icon': Icons.view_carousel_rounded,
    },
    {
      'title': 'App Content',
      'subtitle': 'Manage static content',
      'icon': Icons.article_outlined,
    },
    {
      'title': 'FAQs',
      'subtitle': 'Manage frequently asked questions',
      'icon': Icons.quiz_outlined,
    },
    {
      'title': 'Announcements',
      'subtitle': 'Manage important notices',
      'icon': Icons.campaign_outlined,
    },
    {
      'title': 'Static Pages',
      'subtitle': 'About, Terms, Privacy etc.',
      'icon': Icons.description_outlined,
    },
  ];

  // PDF Page 17 ke sabhi 5 Home Banners ka data[cite: 17]
  final List<Map<String, dynamic>> _banners = [
    {
      'id': 1,
      'title': 'Home Loan',
      'subtitle': 'Build Your Dream Home Today',
      'desc': 'Get low interest rates and flexible EMI options',
      'btnText': 'Apply Now',
      'action': 'Open Loan Page',
      'status': 'Active',
      'order': 1,
      'color': const Color(0xFF0F3E38),
      'icon': Icons.home_rounded,
    },
    {
      'id': 2,
      'title': 'Personal Loan',
      'subtitle': 'For Your Every Need',
      'desc': 'Quick approval with minimal documentation',
      'btnText': 'Apply Now',
      'action': 'Open Loan Page',
      'status': 'Active',
      'order': 2,
      'color': const Color(0xFF7C3AED),
      'icon': Icons.person_rounded,
    },
    {
      'id': 3,
      'title': 'Car Loan',
      'subtitle': 'Drive Your Dreams',
      'desc': 'Attractive interest rates & flexible tenure',
      'btnText': 'Apply Now',
      'action': 'Open Loan Page',
      'status': 'Active',
      'order': 3,
      'color': const Color(0xFF0284C7),
      'icon': Icons.directions_car_rounded,
    },
    {
      'id': 4,
      'title': 'Education Loan',
      'subtitle': 'Invest in a Brighter Future',
      'desc': 'Support for higher education with fast processing',
      'btnText': 'Apply Now',
      'action': 'Open Loan Page',
      'status': 'Active',
      'order': 4,
      'color': const Color(0xFFD97706),
      'icon': Icons.school_rounded,
    },
    {
      'id': 5,
      'title': 'Business Loan',
      'subtitle': 'Fuel Your Business Growth',
      'desc': 'Quick funding with collateral-free options',
      'btnText': 'Apply Now',
      'action': 'Open Loan Page',
      'status': 'Inactive',
      'order': 5,
      'color': const Color(0xFF16A36A),
      'icon': Icons.business_center_rounded,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // PDF Page 17 ka Add/Edit Banner Modal Dialog[cite: 17]
  void _openAddEditBannerModal({Map<String, dynamic>? banner}) {
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController(text: banner?['title'] ?? '');
    final subtitleCtrl = TextEditingController(text: banner?['subtitle'] ?? '');
    final descCtrl = TextEditingController(text: banner?['desc'] ?? '');
    final btnTextCtrl =
    TextEditingController(text: banner?['btnText'] ?? 'Apply Now');

    String buttonAction = banner?['action'] ?? 'Open Loan Page';
    String status = banner?['status'] ?? 'Active';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            titlePadding: const EdgeInsets.fromLTRB(18, 16, 14, 10),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  banner == null ? 'Add Banner' : 'Edit Banner',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner Title[cite: 17]
                      TextFormField(
                        controller: titleCtrl,
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration:
                        _inputDecoration('Title *', 'Home Loan'),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle[cite: 17]
                      TextFormField(
                        controller: subtitleCtrl,
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration(
                            'Subtitle *', 'Make Your Dream Home a Reality'),
                      ),
                      const SizedBox(height: 12),

                      // Description[cite: 17]
                      TextFormField(
                        controller: descCtrl,
                        maxLines: 2,
                        decoration: _inputDecoration('Description',
                            'Get low interest rates and flexible EMI options...'),
                      ),
                      const SizedBox(height: 12),

                      // Button Text & Action[cite: 17]
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: btnTextCtrl,
                              decoration: _inputDecoration(
                                  'Button Text', 'Apply Now'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: buttonAction,
                              items: [
                                'Open Loan Page',
                                'Open Partner Page',
                                'Open External Link',
                                'Open Contact Page',
                              ]
                                  .map((a) => DropdownMenuItem(
                                  value: a,
                                  child: Text(a,
                                      style:
                                      const TextStyle(fontSize: 11.5))))
                                  .toList(),
                              onChanged: (val) =>
                                  setModalState(() => buttonAction = val!),
                              decoration:
                              _inputDecoration('Button Action', ''),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Status Radios[cite: 17]
                      Row(
                        children: [
                          const Text('Status: ',
                              style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary)),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Active',
                                groupValue: status,
                                activeColor: const Color(0xFF0F3E38),
                                onChanged: (v) =>
                                    setModalState(() => status = v!),
                              ),
                              const Text('Active',
                                  style: TextStyle(fontSize: 11)),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Inactive',
                                groupValue: status,
                                activeColor: const Color(0xFF0F3E38),
                                onChanged: (v) =>
                                    setModalState(() => status = v!),
                              ),
                              const Text('Inactive',
                                  style: TextStyle(fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Upload Banner Image Box[cite: 17]
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.cloud_upload_outlined,
                                size: 24, color: Color(0xFF0F3E38)),
                            SizedBox(height: 4),
                            Text(
                              'Upload Banner Image',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F3E38)),
                            ),
                            Text('Recommended: 1200 x 600 px (PNG, JPG)',
                                style: TextStyle(
                                    fontSize: 9.5, color: AppColors.textHint)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel',
                    style: TextStyle(color: AppColors.textSecondary)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(banner == null
                            ? 'New banner slider added!'
                            : 'Banner details updated successfully!'),
                        backgroundColor: const Color(0xFF0F3E38),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3E38),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  banner == null ? 'Save Banner' : 'Update Banner',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
          const BorderSide(color: Color(0xFF0F3E38), width: 1.4)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header title[cite: 17]
              _buildHeaderSection(),
              const SizedBox(height: 16),

              // 1. Top 5 Category Navigation Hub Cards[cite: 17]
              _buildCategoryHubCards(),
              const SizedBox(height: 16),

              // 2. Middle Row: Home Banners Management & Live Mobile App Preview[cite: 17]
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 980;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Home Banners Table[cite: 17]
                        Expanded(flex: 7, child: _buildHomeBannersCard()),
                        const SizedBox(width: 14),

                        // Right: Live App Preview Mockup[cite: 17]
                        SizedBox(
                          width: 320,
                          child: _buildLiveAppPreviewCard(),
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _buildHomeBannersCard(),
                      const SizedBox(height: 14),
                      _buildLiveAppPreviewCard(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              // 3. Bottom Row: App Content, FAQs, and Announcements[cite: 17]
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 980;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildAppContentSummaryCard()),
                        const SizedBox(width: 14),
                        Expanded(child: _buildFaqsSummaryCard()),
                        const SizedBox(width: 14),
                        Expanded(child: _buildAnnouncementsSummaryCard()),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _buildAppContentSummaryCard(),
                      const SizedBox(height: 14),
                      _buildFaqsSummaryCard(),
                      const SizedBox(height: 14),
                      _buildAnnouncementsSummaryCard(),
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

  // Header Title Row[cite: 17]
  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'CMS / Content Management',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Manage app content, banners, FAQs, and static pages for Mahavir Finance app.',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // 1. Top 5 Category Navigation Cards[cite: 17]
  Widget _buildCategoryHubCards() {
    return Row(
      children: List.generate(_categoryTabs.length, (index) {
        final cat = _categoryTabs[index];
        final isSelected = _selectedCategoryTab == index;

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index == _categoryTabs.length - 1 ? 0 : 8),
            child: InkWell(
              onTap: () => setState(() => _selectedCategoryTab = index),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0F3E38) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF0F3E38) : AppColors.border,
                    width: isSelected ? 1.4 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      cat['icon'] as IconData,
                      size: 20,
                      color: isSelected ? const Color(0xFF5EEAD4) : const Color(0xFF0F3E38),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat['title'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? Colors.white : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cat['subtitle'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9.5,
                        color: isSelected ? Colors.white70 : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // 2. Left: Home Banners Table[cite: 17]
  Widget _buildHomeBannersCard() {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Home Banners (5)',
                    style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary),
                  ),
                  Text(
                    'Manage the banner sliders shown on app home screen.',
                    style:
                    TextStyle(fontSize: 10, color: AppColors.textSecondary),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _openAddEditBannerModal(),
                icon: const Icon(Icons.add_rounded, size: 15, color: Colors.white),
                label: const Text(
                  '+ Add Banner',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3E38),
                  elevation: 0,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: DataTable(
                headingRowColor:
                WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                headingRowHeight: 40,
                dataRowMinHeight: 52,
                dataRowMaxHeight: 56,
                horizontalMargin: 12,
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('Preview', style: _headerStyle)),
                  DataColumn(label: Text('Title', style: _headerStyle)),
                  DataColumn(label: Text('Subtitle', style: _headerStyle)),
                  DataColumn(label: Text('Status', style: _headerStyle)),
                  DataColumn(label: Text('Order', style: _headerStyle)),
                  DataColumn(label: Text('Actions', style: _headerStyle)),
                ],
                rows: _banners.map((item) {
                  final isActive = item['status'] == 'Active';

                  return DataRow(
                    cells: [
                      DataCell(
                        Container(
                          width: 44,
                          height: 28,
                          decoration: BoxDecoration(
                            color:
                            (item['color'] as Color).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: (item['color'] as Color)
                                    .withValues(alpha: 0.3)),
                          ),
                          child: Icon(item['icon'] as IconData,
                              size: 16, color: item['color'] as Color),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 220,
                          child: Text(
                            item['subtitle'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 10.5, color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFFDCFCE7)
                                : const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['status'] as String,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: isActive
                                  ? const Color(0xFF16A36A)
                                  : const Color(0xFFDC2626),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${item['order']}',
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary)),
                            const SizedBox(width: 4),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.arrow_drop_up_rounded,
                                    size: 16, color: AppColors.iconSecondary),
                                Icon(Icons.arrow_drop_down_rounded,
                                    size: 16, color: AppColors.iconSecondary),
                              ],
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  size: 15, color: Color(0xFF0F3E38)),
                              tooltip: 'Edit Banner',
                              onPressed: () =>
                                  _openAddEditBannerModal(banner: item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded,
                                  size: 15, color: Color(0xFFDC2626)),
                              tooltip: 'Delete Banner',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Deleted banner: ${item['title']}')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const TextStyle _headerStyle = TextStyle(
    fontSize: 10.5,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  // 2. Right: Live Mobile App Banner Preview[cite: 17]
  Widget _buildLiveAppPreviewCard() {
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
                'Banner Preview (App View)',
                style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary),
              ),
              Icon(Icons.smartphone_rounded,
                  size: 16, color: Color(0xFF0F3E38)),
            ],
          ),
          const SizedBox(height: 12),

          // Simulated Phone Banner Card[cite: 17]
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F3E38), Color(0xFF134E4A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Special Scheme',
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF5EEAD4))),
                    ),
                    const Icon(Icons.home_work_rounded,
                        color: Colors.white70, size: 20),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Build Your Dream\nHome Today',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.2),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Get low interest rates and flexible EMI options.',
                  style: TextStyle(fontSize: 10, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A36A),
                    elevation: 0,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text('Apply Now',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Dot indicator representation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 14,
                  height: 4,
                  decoration: BoxDecoration(
                      color: const Color(0xFF0F3E38),
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 4),
              Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                      color: AppColors.border, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                      color: AppColors.border, shape: BoxShape.circle)),
            ],
          ),
        ],
      ),
    );
  }

  // 3. Bottom Card 1: App Content[cite: 17]
  Widget _buildAppContentSummaryCard() {
    final items = [
      {'title': 'Why Choose Us', 'sub': 'Key benefits & features'},
      {'title': 'About Us', 'sub': 'Company background & vision'},
      {'title': 'Contact Us', 'sub': 'Address, phone & email'},
      {'title': 'Terms & Conditions', 'sub': 'Legal policies & rules'},
    ];

    return _buildSummaryCard(
      title: 'App Content',
      actionText: 'View All',
      items: items,
      icon: Icons.article_outlined,
    );
  }

  // 3. Bottom Card 2: FAQs[cite: 17]
  Widget _buildFaqsSummaryCard() {
    final items = [
      {'title': 'How to apply for a loan?', 'sub': 'Step by step procedure'},
      {'title': 'What documents are required?', 'sub': 'KYC & income proofs'},
      {'title': 'How long does approval take?', 'sub': '24-48 business hours'},
      {'title': 'Can I prepay my loan?', 'sub': 'Foreclosure terms & charges'},
    ];

    return _buildSummaryCard(
      title: 'FAQs',
      actionText: 'View All',
      items: items,
      icon: Icons.quiz_outlined,
    );
  }

  // 3. Bottom Card 3: Announcements[cite: 17]
  Widget _buildAnnouncementsSummaryCard() {
    final items = [
      {'title': 'Diwali Special Offer', 'sub': '10 Oct 2024 • Active'},
      {'title': 'System Maintenance', 'sub': '02 Oct 2024 • Completed'},
      {'title': 'New Loan Product', 'sub': '28 Sep 2024 • Active'},
      {'title': 'Updated Interest Rates', 'sub': '20 Sep 2024 • Active'},
    ];

    return _buildSummaryCard(
      title: 'Announcements',
      actionText: 'View All',
      items: items,
      icon: Icons.campaign_outlined,
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String actionText,
    required List<Map<String, String>> items,
    required IconData icon,
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
              Text(title,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary)),
              Text(actionText,
                  style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F3E38))),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: items.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(icon, size: 14, color: const Color(0xFF0F3E38)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary)),
                          Text(item['sub']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 9.5,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        size: 14, color: AppColors.iconSecondary),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}