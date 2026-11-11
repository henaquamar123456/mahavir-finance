import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../core/servicess/shared_pref_helper.dart';

class CmsContentManagementScreen extends StatefulWidget {
  const CmsContentManagementScreen({super.key});

  @override
  State<CmsContentManagementScreen> createState() =>
      _CmsContentManagementScreenState();
}

class _CmsContentManagementScreenState
    extends State<CmsContentManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryTab = 0;
  bool _isLoading = false;

  final List _categoryTabs = [
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

  List  _banners = [];
  Map<String, dynamic>? _selectedBanner;

  @override
  void initState() {
    super.initState();
    _fetchBanners();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchBanners() async {
    setState(() => _isLoading = true);

    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/cms/banners'));

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> rawList = body['data'] ?? [];

        if (rawList.isNotEmpty) {
          final List loaded = [];
    for (int i = 0; i < rawList.length; i++) {
    final b = rawList[i];
    final title = b['title'] ?? 'Banner';
    final icon = _resolveIcon(b['iconName'] ?? title);
    final color = _resolveColor(b['colorHex'] ?? '', title);

    loaded.add({
    'id': i + 1,
    '_id': b['_id'] ?? '',
    'title': title,
    'subtitle': b['subtitle'] ?? '',
    'desc': b['desc'] ?? '',
    'btnText': b['btnText'] ?? 'Apply Now',
    'action': b['action'] ?? 'Open Loan Page',
    'status': b['status'] ?? 'Active',
    'order': b['order'] ?? (i + 1),
    'color': color,
    'icon': icon,
    });
    }

    if (mounted) {
    setState(() {
    _banners = loaded;
    _selectedBanner = _banners.firstWhere(
    (b) => b['status'] == 'Active',
    orElse: () => _banners.first,
    );
    _isLoading = false;
    });
    return;
    }
    }
    }
    _setFallbackBanners();
    } catch (_) {
    _setFallbackBanners();
    }
  }

  IconData _resolveIcon(String key) {
    final k = key.toLowerCase();
    if (k.contains('car')) return Icons.directions_car_rounded;
    if (k.contains('person')) return Icons.person_rounded;
    if (k.contains('edu') || k.contains('school')) return Icons.school_rounded;
    if (k.contains('bus')) return Icons.business_center_rounded;
    return Icons.home_rounded;
  }

  Color _resolveColor(String hex, String title) {
    if (hex.isNotEmpty && hex.startsWith('#') && hex.length == 7) {
      try {
        return Color(int.parse(hex.replaceFirst('#', '0xFF')));
      } catch (_) {}
    }
    final t = title.toLowerCase();
    if (t.contains('car')) return const Color(0xFF0284C7);
    if (t.contains('person')) return const Color(0xFF7C3AED);
    if (t.contains('edu')) return const Color(0xFFD97706);
    if (t.contains('bus')) return const Color(0xFF16A36A);
    return const Color(0xFF0F3E38);
  }

  void _setFallbackBanners() {
    if (!mounted) return;
    setState(() {
      _banners = [
        {
          'id': 1,
          '_id': 'b1',
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
          '_id': 'b2',
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
      ];
      _selectedBanner = _banners.first;
      _isLoading = false;
    });
  }

  // ==========================================
  // ADD & EDIT BANNER MODAL (Live API)
  // ==========================================
  void _openAddEditBannerModal({Map<String, dynamic>? banner}) {
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController(text: banner?['title'] ?? '');
    final subtitleCtrl = TextEditingController(text: banner?['subtitle'] ?? '');
    final descCtrl = TextEditingController(text: banner?['desc'] ?? '');
    final btnTextCtrl =
    TextEditingController(text: banner?['btnText'] ?? 'Apply Now');

    String buttonAction = banner?['action'] ?? 'Open Loan Page';
    String status = banner?['status'] ?? 'Active';
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
                      TextFormField(
                        controller: titleCtrl,
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration('Title *', 'Home Loan'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: subtitleCtrl,
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration(
                            'Subtitle *', 'Make Your Dream Home a Reality'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descCtrl,
                        maxLines: 2,
                        decoration: _inputDecoration('Description',
                            'Get low interest rates and flexible EMI options...'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: btnTextCtrl,
                              decoration:
                              _inputDecoration('Button Text', 'Apply Now'),
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
                                      style: const TextStyle(fontSize: 11.5))))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setModalState(() => buttonAction = val);
                              },
                              decoration: _inputDecoration('Button Action', ''),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
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
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Column(
                          children: [
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
                onPressed: isSubmitting
                    ? null
                    : () async {
                  if (formKey.currentState!.validate()) {
                    setModalState(() => isSubmitting = true);
                    final token = await SharedPrefHelper.getToken();

                    final payload = {
                      'title': titleCtrl.text.trim(),
                      'subtitle': subtitleCtrl.text.trim(),
                      'desc': descCtrl.text.trim(),
                      'btnText': btnTextCtrl.text.trim(),
                      'action': buttonAction,
                      'status': status,
                    };

                    try {
                      http.Response res;
                      if (banner == null) {
                        final url = Uri.parse(
                            MFUrls.mfBaseUrl('api/v1/cms/banners'));
                        res = await http.post(
                          url,
                          headers: {
                            'Content-Type': 'application/json',
                            if (token != null)
                              'Authorization': 'Bearer $token',
                          },
                          body: jsonEncode(payload),
                        ).timeout(const Duration(seconds: 10));
                      } else {
                        final bId = banner['_id'];
                        final url = Uri.parse(
                            MFUrls.mfBaseUrl('api/v1/cms/banners/$bId'));
                        res = await http.put(
                          url,
                          headers: {
                            'Content-Type': 'application/json',
                            if (token != null)
                              'Authorization': 'Bearer $token',
                          },
                          body: jsonEncode(payload),
                        ).timeout(const Duration(seconds: 10));
                      }

                      if (res.statusCode == 200 || res.statusCode == 201) {
                        if (ctx.mounted) Navigator.pop(ctx);
                        _fetchBanners();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(banner == null
                                  ? 'New banner slider added!'
                                  : 'Banner details updated successfully!'),
                              backgroundColor: const Color(0xFF16A36A),
                            ),
                          );
                        }
                      } else {
                        throw Exception();
                      }
                    } catch (_) {
                      if (ctx.mounted) Navigator.pop(ctx);
                      _fetchBanners();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3E38),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: isSubmitting
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                )
                    : Text(
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

  // ==========================================
  // DELETE BANNER (Live API)
  // ==========================================
  Future<void> _deleteBanner(Map<String, dynamic> banner) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Delete ${banner['title']}?',
            style: const TextStyle(
                fontWeight: FontWeight.w800, color: AppColors.primary)),
        content: Text(
            'Are you sure you want to delete "${banner['title']}" banner from the app home screen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626), elevation: 0),
            child: const Text('Delete',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final token = await SharedPrefHelper.getToken();
        final bId = banner['_id'];
        final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/cms/banners/$bId'));

        final res = await http.delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ).timeout(const Duration(seconds: 10));

        if (res.statusCode == 200) {
          _fetchBanners();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Deleted banner: ${banner['title']}')),
            );
          }
        }
      } catch (_) {
        setState(() => _banners.removeWhere((b) => b['_id'] == banner['_id']));
      }
    }
  }

  // ==========================================
  // REORDER BANNER (Live PUT API)
  // ==========================================
  Future<void> _changeBannerOrder(Map<String, dynamic> banner, int delta) async {
    final currentOrder = banner['order'] as int;
    final newOrder = (currentOrder + delta).clamp(1, _banners.length);
    if (newOrder == currentOrder) return;

    try {
      final token = await SharedPrefHelper.getToken();
      final bId = banner['_id'];
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/cms/banners/$bId'));

      await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'order': newOrder}),
      );
      _fetchBanners();
    } catch (_) {}
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
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Color(0xFF0F3E38), width: 1.4)),
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
              _buildCategoryHubCards(),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 980;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _buildHomeBannersCard()),
                        const SizedBox(width: 14),
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

  Widget _buildHeaderSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

  Widget _buildCategoryHubCards() {
    return Row(
      children: List.generate(_categoryTabs.length, (index) {
        final cat = _categoryTabs[index];
        final isSelected = _selectedCategoryTab == index;

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
                right: index == _categoryTabs.length - 1 ? 0 : 8),
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
                      color: isSelected
                          ? const Color(0xFF5EEAD4)
                          : const Color(0xFF0F3E38),
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
                        color:
                        isSelected ? Colors.white70 : AppColors.textSecondary,
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
                children: [
                  Text(
                    'Home Banners (${_banners.length})',
                    style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary),
                  ),
                  const Text(
                    'Click on any banner row to live preview on the app screen.',
                    style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded,
                        color: AppColors.primary, size: 20),
                    tooltip: 'Refresh Banners',
                    onPressed: _fetchBanners,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _openAddEditBannerModal(),
                    icon: const Icon(Icons.add_rounded,
                        size: 15, color: Colors.white),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _isLoading
              ? const Center(
            child: Padding(
              padding: EdgeInsets.all(28),
              child: CircularProgressIndicator(color: AppColors.secondary),
            ),
          )
              : ClipRRect(
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
                  final isCurrentSelected =
                      _selectedBanner?['_id'] == item['_id'];

                  return DataRow(
                    selected: isCurrentSelected,
                    onSelectChanged: (_) {
                      setState(() => _selectedBanner = item);
                    },
                    cells: [
                      DataCell(
                        Container(
                          width: 44,
                          height: 28,
                          decoration: BoxDecoration(
                            color: (item['color'] as Color)
                                .withValues(alpha: 0.15),
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
                                fontSize: 10.5,
                                color: AppColors.textSecondary),
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
                              children: [
                                InkWell(
                                  onTap: () =>
                                      _changeBannerOrder(item, -1),
                                  child: const Icon(
                                      Icons.arrow_drop_up_rounded,
                                      size: 16,
                                      color: AppColors.iconSecondary),
                                ),
                                InkWell(
                                  onTap: () =>
                                      _changeBannerOrder(item, 1),
                                  child: const Icon(
                                      Icons.arrow_drop_down_rounded,
                                      size: 16,
                                      color: AppColors.iconSecondary),
                                ),
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
                              onPressed: () => _deleteBanner(item),
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

  Widget _buildLiveAppPreviewCard() {
    final preview = _selectedBanner ?? (_banners.isNotEmpty ? _banners.first : null);
    final color = preview?['color'] as Color? ?? const Color(0xFF0F3E38);

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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.85)],
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
                      child: Text(
                        preview?['title'] ?? 'Special Scheme',
                        style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF5EEAD4)),
                      ),
                    ),
                    Icon(preview?['icon'] as IconData? ?? Icons.home_work_rounded,
                        color: Colors.white70, size: 20),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  preview?['subtitle'] ?? 'Build Your Dream\nHome Today',
                  style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.2),
                ),
                const SizedBox(height: 4),
                Text(
                  preview?['desc'] ??
                      'Get low interest rates and flexible EMI options.',
                  style: const TextStyle(fontSize: 9.5, color: Colors.white70),
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
                  child: Text(
                    preview?['btnText'] ?? 'Apply Now',
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
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
    required List items,
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