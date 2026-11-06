import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class BlogManagementScreen extends StatefulWidget {
  const BlogManagementScreen({super.key});

  @override
  State<BlogManagementScreen> createState() => _BlogManagementScreenState();
}

class _BlogManagementScreenState extends State<BlogManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All Categories';
  String _selectedStatus = 'All Status';
  String _selectedAuthor = 'All Authors';
  String _selectedDateRange = 'All Time';
  int _rowsPerPage = 10;
  bool _selectAll = false;
  final Set<int> _selectedRows = {};

  final List<String> _categoryOptions = [
    'All Categories',
    'Home Loan',
    'Personal Loan',
    'Car Loan',
    'Business',
    'Education',
    'Investment',
    'Financial Tips',
    'General',
  ];

  final List<String> _statusOptions = [
    'All Status',
    'Published',
    'Draft',
    'Scheduled',
  ];

  final List<String> _authorOptions = [
    'All Authors',
    'Admin',
    'Priya Sharma',
    'Amit Kumar',
    'Neha Gupta',
    'Rahul Verma',
    'Pooja Singh',
    'Vikram Yadav',
  ];

  // PDF Page 18 ke sabhi 10 blogs ka sample data[cite: 18]
  final List<Map<String, dynamic>> _blogs = [
    {
      'id': 1,
      'title': 'Home Loan Guide 2024',
      'excerpt': 'Everything you need to know about home loans',
      'category': 'Home Loan',
      'author': 'Admin',
      'status': 'Published',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'views': '3.2K',
      'publishedOn': '10 Oct 2024',
      'color': const Color(0xFF0F3E38),
      'icon': Icons.home_rounded,
    },
    {
      'id': 2,
      'title': 'Top 10 Investment Tips',
      'excerpt': 'Smart investment for better financial future',
      'category': 'Investment',
      'author': 'Priya Sharma',
      'status': 'Published',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'views': '1.8K',
      'publishedOn': '08 Oct 2024',
      'color': const Color(0xFF0284C7),
      'icon': Icons.trending_up_rounded,
    },
    {
      'id': 3,
      'title': 'Car Loan vs Personal Loan',
      'excerpt': 'Which loan is better for you? A complete comparison',
      'category': 'Car Loan',
      'author': 'Amit Kumar',
      'status': 'Draft',
      'statusBg': const Color(0xFFF1F5F9),
      'statusCol': const Color(0xFF64748B),
      'views': '—',
      'publishedOn': '06 Oct 2024',
      'color': const Color(0xFF7C3AED),
      'icon': Icons.directions_car_rounded,
    },
    {
      'id': 4,
      'title': 'Education Loan Benefits',
      'excerpt': 'How to fund your higher education easily',
      'category': 'Education',
      'author': 'Neha Gupta',
      'status': 'Published',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'views': '2.5K',
      'publishedOn': '05 Oct 2024',
      'color': const Color(0xFFD97706),
      'icon': Icons.school_rounded,
    },
    {
      'id': 5,
      'title': 'Business Loan for MSMEs',
      'excerpt': 'Get the right funding to grow your business',
      'category': 'Business',
      'author': 'Rahul Verma',
      'status': 'Scheduled',
      'statusBg': const Color(0xFFE0F2FE),
      'statusCol': const Color(0xFF0284C7),
      'views': '—',
      'publishedOn': '15 Oct 2024',
      'color': const Color(0xFF16A36A),
      'icon': Icons.business_center_rounded,
    },
    {
      'id': 6,
      'title': 'Personal Loan Explained',
      'excerpt': 'Quick and easy personal loan for your needs',
      'category': 'Personal Loan',
      'author': 'Admin',
      'status': 'Published',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'views': '4.1K',
      'publishedOn': '01 Oct 2024',
      'color': const Color(0xFF0F3E38),
      'icon': Icons.person_rounded,
    },
    {
      'id': 7,
      'title': 'How to Calculate EMI?',
      'excerpt': 'A step by step guide to calculate your own EMI',
      'category': 'General',
      'author': 'Pooja Singh',
      'status': 'Published',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'views': '920',
      'publishedOn': '28 Sep 2024',
      'color': const Color(0xFF64748B),
      'icon': Icons.calculate_outlined,
    },
    {
      'id': 8,
      'title': 'Improve Your Credit Score',
      'excerpt': 'Simple tips to improve your credit score',
      'category': 'Financial Tips',
      'author': 'Vikram Yadav',
      'status': 'Draft',
      'statusBg': const Color(0xFFF1F5F9),
      'statusCol': const Color(0xFF64748B),
      'views': '—',
      'publishedOn': '25 Sep 2024',
      'color': const Color(0xFFEAB308),
      'icon': Icons.speed_rounded,
    },
    {
      'id': 9,
      'title': 'Tax Benefits on Home Loan',
      'excerpt': 'Know the tax benefits available on home loans',
      'category': 'Home Loan',
      'author': 'Admin',
      'status': 'Published',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'views': '1.1K',
      'publishedOn': '22 Sep 2024',
      'color': const Color(0xFF0F3E38),
      'icon': Icons.account_balance_wallet_rounded,
    },
    {
      'id': 10,
      'title': 'Documents Required for Loan',
      'excerpt': 'List of documents for different loan types',
      'category': 'General',
      'author': 'Neha Gupta',
      'status': 'Scheduled',
      'statusBg': const Color(0xFFE0F2FE),
      'statusCol': const Color(0xFF0284C7),
      'views': '—',
      'publishedOn': '18 Oct 2024',
      'color': const Color(0xFF64748B),
      'icon': Icons.description_outlined,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = 'All Categories';
      _selectedStatus = 'All Status';
      _selectedAuthor = 'All Authors';
      _selectedDateRange = 'All Time';
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  // PDF Page 18 ka Create/Edit Blog Form Modal[cite: 18]
  void _openAddEditBlogModal({Map<String, dynamic>? blog}) {
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController(text: blog?['title'] ?? '');
    final slugCtrl = TextEditingController(
      text: blog?['title']?.toString().toLowerCase().replaceAll(' ', '-') ??
          'home-loan-guide-2024',
    );
    final excerptCtrl = TextEditingController(text: blog?['excerpt'] ?? '');
    final contentCtrl = TextEditingController();
    final tagsCtrl = TextEditingController(text: 'Home Loan, Finance, EMI');

    String category = blog?['category'] ?? 'Home Loan';
    String author = blog?['author'] ?? 'Admin';
    String status = blog?['status'] ?? 'Published';

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
                  blog == null ? 'Create Blog' : 'Edit Blog',
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
              width: 540,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Blog Title & Slug[cite: 18]
                      TextFormField(
                        controller: titleCtrl,
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration('Title *', 'Enter blog title'),
                        onChanged: (val) {
                          setModalState(() {
                            slugCtrl.text =
                                val.toLowerCase().replaceAll(' ', '-');
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: slugCtrl,
                        decoration: _inputDecoration('Slug *', 'blog-url-slug'),
                      ),
                      const SizedBox(height: 12),

                      // Category & Author Selection[cite: 18]
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: category,
                              items: _categoryOptions
                                  .where((c) => c != 'All Categories')
                                  .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c,
                                      style: const TextStyle(
                                          fontSize: 11.5))))
                                  .toList(),
                              onChanged: (val) =>
                                  setModalState(() => category = val!),
                              decoration: _inputDecoration('Category *', ''),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: author,
                              items: _authorOptions
                                  .where((a) => a != 'All Authors')
                                  .map((a) => DropdownMenuItem(
                                  value: a,
                                  child: Text(a,
                                      style: const TextStyle(
                                          fontSize: 11.5))))
                                  .toList(),
                              onChanged: (val) =>
                                  setModalState(() => author = val!),
                              decoration: _inputDecoration('Author *', ''),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Excerpt[cite: 18]
                      TextFormField(
                        controller: excerptCtrl,
                        maxLines: 2,
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration(
                          'Excerpt *',
                          'Short description of the blog article (max 150 chars)...',
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Featured Image Upload Box[cite: 18]
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.add_photo_alternate_outlined,
                                size: 22, color: Color(0xFF0F3E38)),
                            SizedBox(height: 4),
                            Text(
                              'Upload Featured Image',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F3E38)),
                            ),
                            Text('PNG, JPG up to 2MB',
                                style: TextStyle(
                                    fontSize: 9.5, color: AppColors.textHint)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Rich Text Editor Toolbar Mockup[cite: 18]
                      const Text(
                        'Content *',
                        style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8)),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: const [
                            Text('Paragraph ▾',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary)),
                            SizedBox(width: 12),
                            Icon(Icons.format_bold_rounded,
                                size: 15, color: AppColors.primary),
                            SizedBox(width: 8),
                            Icon(Icons.format_italic_rounded,
                                size: 15, color: AppColors.primary),
                            SizedBox(width: 8),
                            Icon(Icons.format_underlined_rounded,
                                size: 15, color: AppColors.primary),
                            SizedBox(width: 8),
                            Icon(Icons.link_rounded,
                                size: 15, color: AppColors.primary),
                            SizedBox(width: 8),
                            Icon(Icons.format_list_bulleted_rounded,
                                size: 15, color: AppColors.primary),
                          ],
                        ),
                      ),
                      TextFormField(
                        controller: contentCtrl,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Write your blog content here...',
                          hintStyle: TextStyle(
                              fontSize: 11, color: AppColors.textHint),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(8)),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(8)),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tags[cite: 18]
                      TextFormField(
                        controller: tagsCtrl,
                        decoration: _inputDecoration(
                            'Tags', 'Add tags, press enter (e.g. Loan, EMI)'),
                      ),
                      const SizedBox(height: 12),

                      // Status Selection Radios[cite: 18]
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
                                value: 'Draft',
                                groupValue: status,
                                activeColor: const Color(0xFF0F3E38),
                                onChanged: (v) =>
                                    setModalState(() => status = v!),
                              ),
                              const Text('Draft',
                                  style: TextStyle(fontSize: 11)),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Published',
                                groupValue: status,
                                activeColor: const Color(0xFF0F3E38),
                                onChanged: (v) =>
                                    setModalState(() => status = v!),
                              ),
                              const Text('Publish Now',
                                  style: TextStyle(fontSize: 11)),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Scheduled',
                                groupValue: status,
                                activeColor: const Color(0xFF0F3E38),
                                onChanged: (v) =>
                                    setModalState(() => status = v!),
                              ),
                              const Text('Schedule',
                                  style: TextStyle(fontSize: 11)),
                            ],
                          ),
                        ],
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
                        content: Text(blog == null
                            ? 'New blog published successfully!'
                            : 'Blog article updated!'),
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
                child: const Text('Save Blog',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
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
              // Header title and Create Blog button[cite: 18]
              _buildHeaderSection(),
              const SizedBox(height: 16),

              // 1. 4 Metric Cards (Total, Published, Drafts, Scheduled)[cite: 18]
              _buildTopMetricsRow(),
              const SizedBox(height: 16),

              // 2. Search & Filter Bar[cite: 18]
              _buildFilterToolbar(),
              const SizedBox(height: 16),

              // 3. Blog Data Table[cite: 18]
              _buildBlogsDataTable(),
              const SizedBox(height: 14),

              // 4. Pagination Footer[cite: 18]
              _buildPaginationFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Header Title Row[cite: 18]
  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Blog Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Create, edit and publish blog articles to educate customers and partners.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _openAddEditBlogModal(),
          icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
          label: const Text(
            '+ Create Blog',
            style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F3E38),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  // 1. Four Metric Badges[cite: 18]
  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Blogs',
            value: '28',
            badgeText: '↑ 16%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'All time',
            icon: Icons.article_outlined,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Published',
            value: '20',
            badgeText: '↑ 25%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Live on web/app',
            icon: Icons.check_circle_outline_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Drafts',
            value: '5',
            badgeText: '↓ 17%',
            badgeBg: const Color(0xFFFEF3C7),
            badgeColor: const Color(0xFFD97706),
            subtitle: 'Not published',
            icon: Icons.edit_note_rounded,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Scheduled',
            value: '3',
            badgeText: '↑ 50%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Scheduled for later',
            icon: Icons.schedule_rounded,
            iconBg: const Color(0xFFF3E8FF),
            iconColor: const Color(0xFF7C3AED),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String badgeText,
    required Color badgeBg,
    required Color badgeColor,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
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
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600)),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                    color: badgeBg, borderRadius: BorderRadius.circular(4)),
                child: Text(badgeText,
                    style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: badgeColor)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                  radius: 14,
                  backgroundColor: iconBg,
                  child: Icon(icon, size: 16, color: iconColor)),
              const SizedBox(width: 10),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle,
              style:
              const TextStyle(fontSize: 10, color: AppColors.textHint)),
        ],
      ),
    );
  }

  // 2. Search & Filter Bar[cite: 18]
  Widget _buildFilterToolbar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 12),
                decoration: const InputDecoration(
                  hintText: 'Search by title, category or tags...',
                  hintStyle:
                  TextStyle(fontSize: 11, color: AppColors.textHint),
                  prefixIcon: Icon(Icons.search_rounded,
                      size: 17, color: AppColors.iconSecondary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedCategory,
              items: _categoryOptions,
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedStatus,
              items: _statusOptions,
              onChanged: (v) => setState(() => _selectedStatus = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedAuthor,
              items: _authorOptions,
              onChanged: (v) => setState(() => _selectedAuthor = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedDateRange,
              items: ['All Time', 'This Month', 'Last 3 Months', 'This Year'],
              icon: Icons.calendar_today_outlined,
              onChanged: (v) => setState(() => _selectedDateRange = v!),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: _resetFilters,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Reset',
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    IconData? icon,
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(icon ?? Icons.keyboard_arrow_down_rounded,
              size: 16, color: AppColors.iconSecondary),
          isExpanded: true,
          style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primary),
          items: items
              .map((i) => DropdownMenuItem(
              value: i,
              child: Text(i, overflow: TextOverflow.ellipsis)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // 3. Blogs Data Table[cite: 18]
  Widget _buildBlogsDataTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Blogs (28)',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary),
                ),
                Text(
                  'Latest First ▾',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F3E38)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: DataTable(
                headingRowColor:
                WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                headingRowHeight: 44,
                dataRowMinHeight: 54,
                dataRowMaxHeight: 58,
                horizontalMargin: 14,
                columnSpacing: 22,
                columns: [
                  DataColumn(
                    label: Checkbox(
                      value: _selectAll,
                      activeColor: const Color(0xFF0F3E38),
                      onChanged: (val) {
                        setState(() {
                          _selectAll = val ?? false;
                          if (_selectAll) {
                            _selectedRows.addAll(
                                List.generate(_blogs.length, (i) => i));
                          } else {
                            _selectedRows.clear();
                          }
                        });
                      },
                    ),
                  ),
                  const DataColumn(label: Text('#', style: _headerStyle)),
                  const DataColumn(label: Text('Thumbnail', style: _headerStyle)),
                  const DataColumn(label: Text('Title', style: _headerStyle)),
                  const DataColumn(label: Text('Category', style: _headerStyle)),
                  const DataColumn(label: Text('Author', style: _headerStyle)),
                  const DataColumn(label: Text('Status', style: _headerStyle)),
                  const DataColumn(label: Text('Views', style: _headerStyle)),
                  const DataColumn(
                      label: Text('Published On', style: _headerStyle)),
                  const DataColumn(label: Text('Actions', style: _headerStyle)),
                ],
                rows: List.generate(_blogs.length, (index) {
                  final item = _blogs[index];
                  final isSelected = _selectedRows.contains(index);

                  return DataRow(
                    selected: isSelected,
                    cells: [
                      DataCell(
                        Checkbox(
                          value: isSelected,
                          activeColor: const Color(0xFF0F3E38),
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedRows.add(index);
                              } else {
                                _selectedRows.remove(index);
                              }
                              _selectAll =
                                  _selectedRows.length == _blogs.length;
                            });
                          },
                        ),
                      ),
                      DataCell(Text('${item['id']}',
                          style: const TextStyle(
                              fontSize: 11.5, color: AppColors.textSecondary))),
                      DataCell(
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color:
                            (item['color'] as Color).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(item['icon'] as IconData,
                              size: 18, color: item['color'] as Color),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 250,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary),
                              ),
                              Text(
                                item['excerpt'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['category'] as String,
                            style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary),
                          ),
                        ),
                      ),
                      DataCell(Text(item['author'] as String,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textPrimary))),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: item['statusBg'] as Color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['status'] as String,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: item['statusCol'] as Color,
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text(item['views'] as String,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F3E38)))),
                      DataCell(
                        Text(
                          item['publishedOn'] as String,
                          style: const TextStyle(
                              fontSize: 10.5, color: AppColors.textSecondary),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  size: 16, color: Color(0xFF0F3E38)),
                              tooltip: 'Edit Blog',
                              onPressed: () =>
                                  _openAddEditBlogModal(blog: item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded,
                                  size: 16, color: Color(0xFFDC2626)),
                              tooltip: 'Delete Blog',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Deleted blog: ${item['title']}')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const TextStyle _headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  // 4. Pagination Footer[cite: 18]
  Widget _buildPaginationFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Showing 1 to 10 of 28 blogs',
          style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
        ),
        Row(
          children: [
            Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _rowsPerPage,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary),
                  items: [10, 25, 50]
                      .map((n) =>
                      DropdownMenuItem(value: n, child: Text('$n per page')))
                      .toList(),
                  onChanged: (val) => setState(() => _rowsPerPage = val!),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _buildPageButton('<', isEnabled: false),
            const SizedBox(width: 4),
            _buildPageButton('1', isSelected: true),
            const SizedBox(width: 4),
            _buildPageButton('2'),
            const SizedBox(width: 4),
            _buildPageButton('3'),
            const SizedBox(width: 4),
            _buildPageButton('>'),
          ],
        ),
      ],
    );
  }

  Widget _buildPageButton(String text,
      {bool isSelected = false, bool isEnabled = true}) {
    return InkWell(
      onTap: isEnabled ? () {} : null,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F3E38) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: isSelected ? const Color(0xFF0F3E38) : AppColors.border),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected
                ? Colors.white
                : isEnabled
                ? AppColors.primary
                : AppColors.textHint,
          ),
        ),
      ),
    );
  }
}