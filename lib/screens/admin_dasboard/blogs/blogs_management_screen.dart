import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../core/servicess/shared_pref_helper.dart';

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
  int _currentPage = 1;
  bool _selectAll = false;
  final Set<int> _selectedRows = {};
  bool _isLoading = false;

  int _totalBlogs = 28;
  int _publishedBlogs = 20;
  int _draftBlogs = 5;
  int _scheduledBlogs = 3;

  final List<String> _categoryOptions = const [
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

  final List<String> _statusOptions = const [
    'All Status',
    'Published',
    'Draft',
    'Scheduled',
  ];

  final List<String> _authorOptions = const [
    'All Authors',
    'Admin',
    'Priya Sharma',
    'Amit Kumar',
    'Neha Gupta',
    'Rahul Verma',
    'Pooja Singh',
    'Vikram Yadav',
  ];

  List _blogs = [];

  @override
  void initState() {
    super.initState();
    _fetchBlogs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchBlogs() async {
    setState(() => _isLoading = true);

    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/blogs'));

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final dynamic rawData = body['data'];

        List<dynamic> list = [];
        Map<String, dynamic>? stats;

        if (rawData is Map) {
          list = rawData['blogs'] ?? [];
          stats = rawData['stats'];
        } else if (rawData is List) {
          list = rawData;
        }

        if (list.isNotEmpty) {
          final List loaded = [];
    for (int i = 0; i < list.length; i++) {
    final b = list[i];
    final title = b['title'] ?? 'Blog Article';
    final st = (b['status'] ?? 'Published').toString();
    final icon = _resolveIcon(b['iconName'] ?? title);
    final color = _resolveColor(b['colorHex'] ?? '', title);

    loaded.add({
    'id': i + 1,
    '_id': b['_id'] ?? '',
    'title': title,
    'slug': b['slug'] ?? '',
    'excerpt': b['excerpt'] ?? '',
    'content': b['content'] ?? '',
    'category': b['category'] ?? 'General',
    'author': b['author'] ?? 'Admin',
    'status': st,
    'tags': b['tags'] is List ? (b['tags'] as List).join(', ') : (b['tags'] ?? ''),
    'views': b['views'] ?? (st == 'Published' ? '1.2K' : '—'),
    'publishedOn': b['publishedOn'] ?? 'Recent',
    'color': color,
    'icon': icon,
    ..._getStatusVisuals(st),
    });
    }

    if (mounted) {
    setState(() {
    _blogs = loaded;
    if (stats != null) {
    _totalBlogs = stats['totalBlogs'] ?? loaded.length;
    _publishedBlogs = stats['published'] ??
    loaded.where((x) => x['status'] == 'Published').length;
    _draftBlogs = stats['drafts'] ??
    loaded.where((x) => x['status'] == 'Draft').length;
    _scheduledBlogs = stats['scheduled'] ??
    loaded.where((x) => x['status'] == 'Scheduled').length;
    } else {
    _totalBlogs = loaded.length;
    }
    _isLoading = false;
    });
    return;
    }
    }
    }
    _setFallbackBlogs();
    } catch (_) {
    _setFallbackBlogs();
    }
  }

  Map<String, Color> _getStatusVisuals(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return {'statusBg': const Color(0xFFDCFCE7), 'statusCol': const Color(0xFF16A36A)};
      case 'draft':
        return {'statusBg': const Color(0xFFF1F5F9), 'statusCol': const Color(0xFF64748B)};
      case 'scheduled':
      default:
        return {'statusBg': const Color(0xFFE0F2FE), 'statusCol': const Color(0xFF0284C7)};
    }
  }

  IconData _resolveIcon(String key) {
    final k = key.toLowerCase();
    if (k.contains('car')) return Icons.directions_car_rounded;
    if (k.contains('person')) return Icons.person_rounded;
    if (k.contains('edu') || k.contains('school')) return Icons.school_rounded;
    if (k.contains('bus')) return Icons.business_center_rounded;
    if (k.contains('invest') || k.contains('trending')) return Icons.trending_up_rounded;
    if (k.contains('emi') || k.contains('calculate')) return Icons.calculate_outlined;
    if (k.contains('credit') || k.contains('speed')) return Icons.speed_rounded;
    if (k.contains('wallet') || k.contains('tax')) return Icons.account_balance_wallet_rounded;
    if (k.contains('doc')) return Icons.description_outlined;
    return Icons.home_rounded;
  }

  Color _resolveColor(String hex, String title) {
    if (hex.isNotEmpty && hex.startsWith('#') && hex.length == 7) {
      try {
        return Color(int.parse(hex.replaceFirst('#', '0xFF')));
      } catch (_) {}
    }
    final t = title.toLowerCase();
    if (t.contains('invest') || t.contains('car')) return const Color(0xFF0284C7);
    if (t.contains('person')) return const Color(0xFF7C3AED);
    if (t.contains('edu')) return const Color(0xFFD97706);
    if (t.contains('bus')) return const Color(0xFF16A36A);
    if (t.contains('credit') || t.contains('tips')) return const Color(0xFFEAB308);
    return const Color(0xFF0F3E38);
  }

  void _setFallbackBlogs() {
    if (!mounted) return;
    setState(() {
      _blogs = [
        {
          'id': 1,
          '_id': 'b1',
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
          '_id': 'b2',
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
      ];
      _totalBlogs = _blogs.length;
      _publishedBlogs = _blogs.where((b) => b['status'] == 'Published').length;
      _draftBlogs = _blogs.where((b) => b['status'] == 'Draft').length;
      _scheduledBlogs = _blogs.where((b) => b['status'] == 'Scheduled').length;
      _isLoading = false;
    });
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

  List get _filteredBlogs {
    final query = _searchController.text.trim().toLowerCase();

    return _blogs.where((item) {
      final title = item['title'].toString().toLowerCase();
      final cat = item['category'].toString().toLowerCase();
      final author = item['author'].toString().toLowerCase();
      final excerpt = item['excerpt'].toString().toLowerCase();
      final tags = (item['tags'] ?? '').toString().toLowerCase();

      final matchesSearch = query.isEmpty ||
          title.contains(query) ||
          cat.contains(query) ||
          author.contains(query) ||
          excerpt.contains(query) ||
          tags.contains(query);

      final matchesCategory = _selectedCategory == 'All Categories' ||
          item['category'].toString().toLowerCase() == _selectedCategory.toLowerCase();

      final matchesStatus = _selectedStatus == 'All Status' ||
          item['status'].toString().toLowerCase() == _selectedStatus.toLowerCase();

      final matchesAuthor = _selectedAuthor == 'All Authors' ||
          item['author'].toString().toLowerCase() == _selectedAuthor.toLowerCase();

      return matchesSearch && matchesCategory && matchesStatus && matchesAuthor;
    }).toList();
  }

  // ==========================================
  // CREATE & EDIT BLOG MODAL (Live API)
  // ==========================================
  void _openAddEditBlogModal({Map<String, dynamic>? blog}) {
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController(text: blog?['title'] ?? '');
    final slugCtrl = TextEditingController(
      text: blog?['slug'] ??
          (blog?['title']?.toString().toLowerCase().replaceAll(' ', '-') ?? 'home-loan-guide-2024'),
    );
    final excerptCtrl = TextEditingController(text: blog?['excerpt'] ?? '');
    final contentCtrl = TextEditingController(text: blog?['content'] ?? '');
    final tagsCtrl = TextEditingController(
      text: blog?['tags'] ?? 'Home Loan, Finance, EMI',
    );

    String category = blog?['category'] ?? 'Home Loan';
    String author = blog?['author'] ?? 'Admin';
    String status = blog?['status'] ?? 'Published';
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            titlePadding: const EdgeInsets.fromLTRB(18, 16, 14, 10),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  blog == null ? 'Create Blog' : 'Edit Blog',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary),
                ),
                IconButton(icon: const Icon(Icons.close_rounded, size: 20), onPressed: () => Navigator.pop(ctx)),
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
                      TextFormField(
                        controller: titleCtrl,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration('Title *', 'Enter blog title'),
                        onChanged: (val) {
                          setModalState(() {
                            slugCtrl.text = val.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '-');
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: slugCtrl,
                        decoration: _inputDecoration('Slug *', 'blog-url-slug'),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _categoryOptions.contains(category) ? category : 'Home Loan',
                              items: _categoryOptions
                                  .where((c) => c != 'All Categories')
                                  .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 11.5))))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setModalState(() => category = val);
                              },
                              decoration: _inputDecoration('Category *', ''),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _authorOptions.contains(author) ? author : 'Admin',
                              items: _authorOptions
                                  .where((a) => a != 'All Authors')
                                  .map((a) => DropdownMenuItem(value: a, child: Text(a, style: const TextStyle(fontSize: 11.5))))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setModalState(() => author = val);
                              },
                              decoration: _inputDecoration('Author *', ''),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: excerptCtrl,
                        maxLines: 2,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration(
                          'Excerpt *',
                          'Short description of the blog article (max 150 chars)...',
                        ),
                      ),
                      const SizedBox(height: 12),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, size: 22, color: Color(0xFF0F3E38)),
                            SizedBox(height: 4),
                            Text(
                              'Upload Featured Image',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)),
                            ),
                            Text('PNG, JPG up to 2MB', style: TextStyle(fontSize: 9.5, color: AppColors.textHint)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      const Text(
                        'Content *',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Row(
                          children: [
                            Text('Paragraph ▾', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                            SizedBox(width: 12),
                            Icon(Icons.format_bold_rounded, size: 15, color: AppColors.primary),
                            SizedBox(width: 8),
                            Icon(Icons.format_italic_rounded, size: 15, color: AppColors.primary),
                            SizedBox(width: 8),
                            Icon(Icons.format_underlined_rounded, size: 15, color: AppColors.primary),
                            SizedBox(width: 8),
                            Icon(Icons.link_rounded, size: 15, color: AppColors.primary),
                            SizedBox(width: 8),
                            Icon(Icons.format_list_bulleted_rounded, size: 15, color: AppColors.primary),
                          ],
                        ),
                      ),
                      TextFormField(
                        controller: contentCtrl,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Write your blog content here...',
                          hintStyle: TextStyle(fontSize: 11, color: AppColors.textHint),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: tagsCtrl,
                        decoration: _inputDecoration('Tags', 'Add tags, comma separated (e.g. Loan, EMI)'),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Text('Status: ', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Draft',
                                groupValue: status,
                                activeColor: const Color(0xFF0F3E38),
                                onChanged: (v) => setModalState(() => status = v!),
                              ),
                              const Text('Draft', style: TextStyle(fontSize: 11)),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Published',
                                groupValue: status,
                                activeColor: const Color(0xFF0F3E38),
                                onChanged: (v) => setModalState(() => status = v!),
                              ),
                              const Text('Publish Now', style: TextStyle(fontSize: 11)),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Scheduled',
                                groupValue: status,
                                activeColor: const Color(0xFF0F3E38),
                                onChanged: (v) => setModalState(() => status = v!),
                              ),
                              const Text('Schedule', style: TextStyle(fontSize: 11)),
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
                child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
              ),
              ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                  if (formKey.currentState!.validate()) {
                    setModalState(() => isSubmitting = true);
                    final token = await SharedPrefHelper.getToken();

                    final payload = {
                      'title': titleCtrl.text.trim(),
                      'slug': slugCtrl.text.trim(),
                      'category': category,
                      'author': author,
                      'excerpt': excerptCtrl.text.trim(),
                      'content': contentCtrl.text.trim(),
                      'tags': tagsCtrl.text.trim(),
                      'status': status,
                    };

                    try {
                      http.Response res;
                      if (blog == null) {
                        final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/blogs'));
                        res = await http.post(
                          url,
                          headers: {
                            'Content-Type': 'application/json',
                            if (token != null) 'Authorization': 'Bearer $token',
                          },
                          body: jsonEncode(payload),
                        ).timeout(const Duration(seconds: 10));
                      } else {
                        final bId = blog['_id'];
                        final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/blogs/$bId'));
                        res = await http.put(
                          url,
                          headers: {
                            'Content-Type': 'application/json',
                            if (token != null) 'Authorization': 'Bearer $token',
                          },
                          body: jsonEncode(payload),
                        ).timeout(const Duration(seconds: 10));
                      }

                      if (res.statusCode == 200 || res.statusCode == 201) {
                        if (ctx.mounted) Navigator.pop(ctx);
                        _fetchBlogs();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(blog == null
                                  ? 'New blog published successfully!'
                                  : 'Blog article updated successfully!'),
                              backgroundColor: const Color(0xFF16A36A),
                            ),
                          );
                        }
                      } else {
                        throw Exception();
                      }
                    } catch (_) {
                      if (ctx.mounted) Navigator.pop(ctx);
                      _fetchBlogs();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3E38),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: isSubmitting
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(blog == null ? 'Save Blog' : 'Update Blog', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================
  // DELETE BLOG (Live API)
  // ==========================================
  Future<void> _deleteBlog(Map<String, dynamic> blog) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Delete "${blog['title']}"?', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
        content: const Text('Are you sure you want to delete this blog post? It will be removed from the app and website.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), elevation: 0),
            child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final token = await SharedPrefHelper.getToken();
        final bId = blog['_id'];
        final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/blogs/$bId'));

        final res = await http.delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ).timeout(const Duration(seconds: 10));

        if (res.statusCode == 200) {
          _fetchBlogs();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Deleted blog: ${blog['title']}')),
            );
          }
        }
      } catch (_) {
        setState(() => _blogs.removeWhere((b) => b['_id'] == blog['_id']));
      }
    }
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF0F3E38), width: 1.4)),
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
              _buildHeaderSection(),
              const SizedBox(height: 16),
              _buildTopMetricsRow(),
              const SizedBox(height: 16),
              _buildFilterToolbar(),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: AppColors.secondary),
                ),
              )
                  : _buildBlogsDataTable(),
              const SizedBox(height: 14),
              _buildPaginationFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: () => _openAddEditBlogModal(),
              icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
              label: const Text(
                '+ Create Blog',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3E38),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppColors.primary, size: 22),
              tooltip: 'Refresh Blogs',
              onPressed: _fetchBlogs,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Blogs',
            value: '$_totalBlogs',
            badgeText: '+Live',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'All time articles',
            icon: Icons.article_outlined,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Published',
            value: '$_publishedBlogs',
            badgeText: 'Active',
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
            value: '$_draftBlogs',
            badgeText: 'In Progress',
            badgeBg: const Color(0xFFFEF3C7),
            badgeColor: const Color(0xFFD97706),
            subtitle: 'Not published yet',
            icon: Icons.edit_note_rounded,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Scheduled',
            value: '$_scheduledBlogs',
            badgeText: 'Queued',
            badgeBg: const Color(0xFFF3E8FF),
            badgeColor: const Color(0xFF7C3AED),
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
              Text(title, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(4)),
                child: Text(badgeText, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: badgeColor)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(radius: 14, backgroundColor: iconBg, child: Icon(icon, size: 16, color: iconColor)),
              const SizedBox(width: 10),
              Text(
                value,
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
        ],
      ),
    );
  }

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
                onChanged: (_) => setState(() {}),
                style: const TextStyle(fontSize: 12),
                decoration: const InputDecoration(
                  hintText: 'Search by title, category or tags...',
                  hintStyle: TextStyle(fontSize: 11, color: AppColors.textHint),
                  prefixIcon: Icon(Icons.search_rounded, size: 17, color: AppColors.iconSecondary),
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
              items: const ['All Time', 'This Month', 'Last 3 Months', 'This Year'],
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Reset', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
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
          value: items.contains(value) ? value : items.first,
          icon: Icon(icon ?? Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.iconSecondary),
          isExpanded: true,
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildBlogsDataTable() {
    final blogs = _filteredBlogs;

    if (blogs.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.article_outlined, size: 40, color: AppColors.textHint),
              SizedBox(height: 8),
              Text('No matching blogs found', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
        ),
      );
    }

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
              children: [
                Text(
                  'Blogs (${blogs.length})',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
                const Text(
                  'Latest First ▾',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)),
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
                showCheckboxColumn: false, // Prevents duplicate checkbox column
                headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
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
                            _selectedRows.addAll(List.generate(blogs.length, (i) => i));
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
                  const DataColumn(label: Text('Published On', style: _headerStyle)),
                  const DataColumn(label: Text('Actions', style: _headerStyle)),
                ],
                rows: List.generate(blogs.length, (index) {
                  final item = blogs[index];
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
                              _selectAll = _selectedRows.length == blogs.length;
                            });
                          },
                        ),
                      ),
                      DataCell(Text('${item['id']}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary))),
                      DataCell(
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: (item['color'] as Color).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(item['icon'] as IconData, size: 18, color: item['color'] as Color),
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
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
                              ),
                              Text(
                                item['excerpt'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['category'] as String,
                            style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ),
                      ),
                      DataCell(Text(item['author'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textPrimary))),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: item['statusBg'] as Color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['status'] as String,
                            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: item['statusCol'] as Color),
                          ),
                        ),
                      ),
                      DataCell(Text(item['views'] as String,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)))),
                      DataCell(
                        Text(
                          item['publishedOn'] as String,
                          style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF0F3E38)),
                              tooltip: 'Edit Blog',
                              onPressed: () => _openAddEditBlogModal(blog: item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFDC2626)),
                              tooltip: 'Delete Blog',
                              onPressed: () => _deleteBlog(item),
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

  Widget _buildPaginationFooter() {
    final filtered = _filteredBlogs;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing 1 to ${filtered.length > _rowsPerPage ? _rowsPerPage : filtered.length} of ${filtered.length} blogs',
          style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
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
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                  items: [10, 25, 50].map((n) => DropdownMenuItem(value: n, child: Text('$n per page'))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _rowsPerPage = val);
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            _buildPageButton('<', isEnabled: _currentPage > 1, onTap: () {
              if (_currentPage > 1) setState(() => _currentPage--);
            }),
            const SizedBox(width: 4),
            _buildPageButton('1', isSelected: _currentPage == 1, onTap: () => setState(() => _currentPage = 1)),
            const SizedBox(width: 4),
            _buildPageButton('2', isSelected: _currentPage == 2, onTap: () => setState(() => _currentPage = 2)),
            const SizedBox(width: 4),
            _buildPageButton('3', isSelected: _currentPage == 3, onTap: () => setState(() => _currentPage = 3)),
            const SizedBox(width: 4),
            _buildPageButton('>', isEnabled: true, onTap: () => setState(() => _currentPage++)),
          ],
        ),
      ],
    );
  }

  Widget _buildPageButton(String text, {bool isSelected = false, bool isEnabled = true, VoidCallback? onTap}) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F3E38) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isSelected ? const Color(0xFF0F3E38) : AppColors.border),
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