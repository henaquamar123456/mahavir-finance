import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/theme/app_text_styles.dart';
import '../../../../widgets/inquiry_card.dart';
import '../../../../widgets/filter_inquiry_bottom_sheet.dart';
import '../providers/inquiry_provider.dart';
import 'inquiry_details_screen.dart';

class InquiryHistoryScreen extends StatefulWidget {
  const InquiryHistoryScreen({super.key});

  @override
  State<InquiryHistoryScreen> createState() => _InquiryHistoryScreenState();
}

class _InquiryHistoryScreenState extends State<InquiryHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InquiryProvider(),
      child: Consumer<InquiryProvider>(
        builder: (context, provider, _) {
          final inquiries = provider.filteredInquiries;

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
                'Inquiry History',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Inquiry History',
                      style: AppTextStyles.headingLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Track all your loan inquiries and check the latest status.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Search & Filter Bar
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: provider.setSearchQuery,
                              style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
                              decoration: const InputDecoration(
                                hintText: 'Search by loan type or inquiry ID...',
                                hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13),
                                prefixIcon: Icon(Icons.search_rounded, color: AppColors.iconSecondary, size: 20),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () => FilterInquiryBottomSheet.show(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Inquiries List
                    Expanded(
                      child: inquiries.isEmpty
                          ? const Center(
                        child: Text(
                          'No inquiries found.',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      )
                          : ListView.builder(
                        itemCount: inquiries.length,
                        itemBuilder: (context, index) {
                          final inquiry = inquiries[index];
                          return InquiryCard(
                            inquiry: inquiry,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => InquiryDetailsScreen(inquiry: inquiry),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}