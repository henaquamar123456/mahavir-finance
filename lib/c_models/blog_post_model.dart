import 'package:flutter/material.dart';

class BlogPostModel {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String category;
  final String authorName;
  final String authorRole;
  final String date;
  final String readTime;
  final IconData icon;
  final Color categoryColor;

  const BlogPostModel({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.category,
    required this.authorName,
    required this.authorRole,
    required this.date,
    required this.readTime,
    required this.icon,
    required this.categoryColor,
  });

  static List<BlogPostModel> get samplePosts => [
    const BlogPostModel(
      id: '1',
      title: 'How to Improve Your CIBIL Score Before Applying for a Loan',
      excerpt:
      'A higher credit score unlocks lower interest rates and faster loan approvals. Learn actionable steps to boost your score in 90 days.',
      content:
      'Your credit score is one of the most critical factors lenders assess when evaluating a loan application. A score above 750 positions you as a low-risk borrower, enabling access to competitive interest rates, higher sanction amounts, and expedited processing.\n\n'
          '1. Timely Repayments\nAlways pay credit card bills and existing EMIs on or before the due date. Payment history accounts for roughly 35% of your overall credit score calculation.\n\n'
          '2. Maintain a Low Credit Utilization Ratio (CUR)\nAim to keep your monthly credit card usage below 30% of your sanctioned credit limit. Maxing out cards suggests financial stress.\n\n'
          '3. Avoid Multiple Hard Inquiries in Short Windows\nApplying for loans simultaneously with several institutions triggers multiple hard credit checks, which negatively impacts your score.',
      category: 'Loans',
      authorName: 'Sanjay Mehta',
      authorRole: 'Senior Financial Advisor',
      date: '20 Oct 2026',
      readTime: '4 min read',
      icon: Icons.speed_rounded,
      categoryColor: Color(0xFF0284C7),
    ),
    const BlogPostModel(
      id: '2',
      title: 'Fixed Rate vs Floating Rate Loans: Which One Should You Choose?',
      excerpt:
      'Understand the mechanics, risk factors, and long-term cost differences between fixed and floating interest rate structures.',
      content:
      'Choosing between a fixed and a floating interest rate impacts your total interest outflow over the loan tenure.\n\n'
          'Fixed Rate Loans offer predictability: your EMI remains constant regardless of market fluctuations. However, lenders typically charge a slight premium over prevailing market rates for this certainty.\n\n'
          'Floating Rate Loans fluctuate in line with the Reserve Bank of India’s repo rate adjustments. When benchmark rates fall, your EMI or tenure reduces automatically. Floating rates are typically lower initially and have zero prepayment penalties for individual borrowers on home loans.',
      category: 'Loans',
      authorName: 'Priya Sharma',
      authorRole: 'Credit Risk Analyst',
      date: '16 Oct 2026',
      readTime: '5 min read',
      icon: Icons.balance_rounded,
      categoryColor: Color(0xFF16A36A),
    ),
    const BlogPostModel(
      id: '3',
      title: 'Tax-Saving Investment Strategies for Salaried Professionals',
      excerpt:
      'Maximize your take-home salary by utilizing Section 80C, 80D, and National Pension Scheme (NPS) provisions efficiently.',
      content:
      'Proactive tax planning prevents last-minute financial strain in the final quarter of the financial year.\n\n'
          'Section 80C allows deductions up to ₹1.5 Lakhs through ELSS mutual funds, PPF, and EPF. Additionally, under Section 80CCD(1B), you can claim an additional deduction of up to ₹50,000 through voluntary contributions to the National Pension Scheme (NPS).\n\n'
          'Health insurance premiums for self, spouse, children, and senior-citizen parents provide further deductions under Section 80D.',
      category: 'Tax Saving',
      authorName: 'Vikram Singhal',
      authorRole: 'Tax Consultant',
      date: '12 Oct 2026',
      readTime: '6 min read',
      icon: Icons.savings_outlined,
      categoryColor: Color(0xFFD97706),
    ),
    const BlogPostModel(
      id: '4',
      title: 'The Power of Compounding: Starting Your SIP Early',
      excerpt:
      'Discover how regular monthly investments through Systematic Investment Plans (SIP) generate exponential wealth over time.',
      content:
      'Albert Einstein famously called compound interest the eighth wonder of the world. In wealth creation, time in the market is vastly more impactful than timing the market.\n\n'
          'A monthly SIP of ₹10,000 started at age 25 can grow significantly larger than a ₹20,000 monthly SIP started at age 35, purely due to an extra decade of compound growth cycles.',
      category: 'Investments',
      authorName: 'Ananya Roy',
      authorRole: 'Wealth Manager',
      date: '08 Oct 2026',
      readTime: '3 min read',
      icon: Icons.trending_up_rounded,
      categoryColor: Color(0xFF7C3AED),
    ),
  ];
}