import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/theme/app_text_styles.dart';
import '../contact/contact_us_screen.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = ['All', 'Loans', 'Eligibility', 'Repayment', 'Security'];

  final List<Map<String, String>> _faqItems = [
    {
      'category': 'Loans',
      'q': 'What loan products does Mahavir Finance provide?',
      'a':
      'We offer Personal Loans, Home Loans, Business Loans, Car Loans, Education Loans, Gold Loans, and Loan Against Property in partnership with leading RBI-registered Banks and NBFCs.',
    },
    {
      'category': 'Loans',
      'q': 'How long does loan disbursal typically take?',
      'a':
      'Once all verified documents are submitted and approved by the lending institution, personal loans can be disbursed within 24 to 48 hours. Secured loans like Home Loans generally take 7 to 14 business days.',
    },
    {
      'category': 'Eligibility',
      'q': 'What is the minimum credit score required to apply?',
      'a':
      'While a CIBIL score of 650 or higher is preferred for competitive interest rates, applicants with lower scores can still explore loan options with customized criteria through select partner NBFCs.',
    },
    {
      'category': 'Eligibility',
      'q': 'Can self-employed individuals apply for loans?',
      'a':
      'Yes. Self-employed individuals, business owners, and professionals with a minimum of 1-year business operational history and valid ITR documentation are fully eligible.',
    },
    {
      'category': 'Repayment',
      'q': 'Can I prepay or foreclose my loan early?',
      'a':
      'Yes. Floating rate personal and home loans taken by individuals typically attract zero foreclosure charges as per regulatory guidelines. Fixed rate loans may have nominal prepayment charges based on the lender policy.',
    },
    {
      'category': 'Security',
      'q': 'Is my financial and personal data safe with Mahavir Finance?',
      'a':
      'Yes. We use 256-bit bank-grade encryption to protect your data. Your information is only shared with authorized partner banks for loan processing upon your explicit consent.',
    },
  ];

  List<Map<String, String>> get _filteredFaqs {
    return _faqItems.where((item) {
      if (_selectedCategory != 'All' && item['category'] != _selectedCategory) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchQ = item['q']!.toLowerCase().contains(query);
        final matchA = item['a']!.toLowerCase().contains(query);
        if (!matchQ && !matchA) return false;
      }
      return true;
    }).toList();
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
          'Frequently Asked Questions',
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
                'How Can We Help?',
                style: AppTextStyles.headingLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Find answers to common questions about loans, documents, and repayment.',
                style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.35),
              ),
              const SizedBox(height: 14),

              // Search Box
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Search questions, keywords...',
                    hintStyle: TextStyle(fontSize: 12.5, color: AppColors.textHint),
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.iconSecondary, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Category Pills
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

              // Accordion List
              if (_filteredFaqs.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text('No answers match your query.',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  ),
                )
              else
                ..._filteredFaqs.map((faq) => _buildFaqTile(faq)),

              const SizedBox(height: 20),

              // Support Callout
              _buildSupportCta(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqTile(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          title: Text(
            item['q']!,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Text(
                item['a']!,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCta(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Didn\'t find your answer?',
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          const Text(
            'Our loan and financial advisory experts are available to guide you directly.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.35),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactUsScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Contact Support Team', style: TextStyle(fontSize: 12.5)),
            ),
          ),
        ],
      ),
    );
  }
}