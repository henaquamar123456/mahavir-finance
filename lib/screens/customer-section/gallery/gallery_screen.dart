import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/theme/app_text_styles.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Offices',
    'Seminars',
    'Events',
    'Customer Meets',
  ];

  final List<Map<String, dynamic>> _galleryItems = [
    {
      'title': 'Corporate Headquarters',
      'location': 'Noida Sector 62',
      'category': 'Offices',
      'icon': Icons.business_rounded,
      'color': const Color(0xFF0284C7),
      'date': 'Oct 2026',
    },
    {
      'title': 'Financial Literacy Camp',
      'location': 'Greater Noida Center',
      'category': 'Seminars',
      'icon': Icons.co_present_rounded,
      'color': AppColors.secondary,
      'date': 'Sep 2026',
    },
    {
      'title': 'Annual Banking Partners Meet',
      'location': 'New Delhi',
      'category': 'Events',
      'icon': Icons.handshake_rounded,
      'color': const Color(0xFFD97706),
      'date': 'Aug 2026',
    },
    {
      'title': 'Customer Financial Guidance Day',
      'location': 'Ghaziabad Branch',
      'category': 'Customer Meets',
      'icon': Icons.groups_rounded,
      'color': const Color(0xFF7C3AED),
      'date': 'Jul 2026',
    },
    {
      'title': 'Loan Disbursal Milestone Summit',
      'location': 'Corporate HQ',
      'category': 'Events',
      'icon': Icons.emoji_events_rounded,
      'color': const Color(0xFFDC2626),
      'date': 'May 2026',
    },
    {
      'title': 'Advisory Consulting Center',
      'location': 'Delhi Connaught Place',
      'category': 'Offices',
      'icon': Icons.storefront_rounded,
      'color': const Color(0xFF0D9488),
      'date': 'Mar 2026',
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    if (_selectedCategory == 'All') return _galleryItems;
    return _galleryItems
        .where((item) => item['category'] == _selectedCategory)
        .toList();
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
        title: const Text(
          'Our Gallery',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Moments & Milestones',
                style: AppTextStyles.headingLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Explore our offices, financial literacy events, and institutional milestones.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 14),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedCategory = cat),
                        selectedColor: AppColors.secondary,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? AppColors.secondary : AppColors.border,
                          ),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Gallery Cards Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  final Color iconColor = item['color'] as Color;

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Illustration / Image Mock Area
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: iconColor.withValues(alpha: 0.10),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                            ),
                            child: Center(
                              child: Icon(
                                item['icon'] as IconData,
                                size: 40,
                                color: iconColor,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['category'] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: iconColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['title'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${item['location']} • ${item['date']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}