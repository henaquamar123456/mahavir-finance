import 'package:flutter/material.dart';

class FinancialServiceModel {
  final String id;
  final String title;
  final String subtitle;
  final String category; // 'Consulting', 'Planning', 'Guidance', 'Investment'
  final String about;
  final IconData icon;
  final Color iconColor;
  final List<Map<String, dynamic>> features;
  final List<String> benefits;

  const FinancialServiceModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.about,
    required this.icon,
    required this.iconColor,
    required this.features,
    required this.benefits,
  });

  static List<FinancialServiceModel> get sampleServices => [
    const FinancialServiceModel(
      id: '1',
      title: 'Financial Consulting',
      subtitle: 'Get expert advice for your financial goals.',
      category: 'Consulting',
      about:
      'Our financial consulting service helps you make the right decisions for your money. Whether you\'re planning for a big purchase, managing your investments, or securing your family\'s future, our experts provide personalized guidance based on your goals and risk profile.',
      icon: Icons.psychology_alt_outlined,
      iconColor: Color(0xFF0284C7),
      features: [
        {'title': 'Expert\nAdvisors', 'icon': Icons.verified_user_outlined},
        {'title': 'Personalized\nSolutions', 'icon': Icons.tune_rounded},
        {'title': 'Goal-Based\nPlanning', 'icon': Icons.trending_up_rounded},
        {'title': 'Ongoing\nSupport', 'icon': Icons.support_agent_rounded},
      ],
      benefits: [
        'Personalized financial advice',
        'Goal-based planning strategies',
        'Risk assessment and portfolio guidance',
        'Regular review and support',
        'Trusted and experienced advisors',
      ],
    ),
    const FinancialServiceModel(
      id: '2',
      title: 'Investment Planning',
      subtitle: 'Plan and grow your wealth with the right strategies.',
      category: 'Investment',
      about:
      'Maximize your returns with strategic mutual funds, fixed income assets, and market-linked instruments tailored to match your specific timeline and risk tolerance.',
      icon: Icons.trending_up_rounded,
      iconColor: Color(0xFF16A36A),
      features: [
        {'title': 'Portfolio\nReview', 'icon': Icons.pie_chart_outline_rounded},
        {'title': 'High Return\nStrategies', 'icon': Icons.auto_graph_rounded},
        {'title': 'Tax\nEfficiency', 'icon': Icons.account_balance_outlined},
        {'title': 'Market\nInsights', 'icon': Icons.insights_rounded},
      ],
      benefits: [
        'Diversified asset allocation strategies',
        'Inflation-beating growth c_models',
        'Disciplined systematic investment planning (SIP)',
        'Quarterly rebalancing and health checks',
      ],
    ),
    const FinancialServiceModel(
      id: '3',
      title: 'Financial Guidance',
      subtitle: 'Make informed decisions with expert support.',
      category: 'Guidance',
      about:
      'Clear guidance through complex financial decisions including debt consolidation, emergency fund creation, and budgeting for families and young professionals.',
      icon: Icons.verified_user_outlined,
      iconColor: Color(0xFF7C3AED),
      features: [
        {'title': 'Budgeting\nHelp', 'icon': Icons.account_balance_wallet_outlined},
        {'title': 'Debt\nReduction', 'icon': Icons.money_off_rounded},
        {'title': 'Emergency\nPrep', 'icon': Icons.security_rounded},
        {'title': '1-on-1\nSessions', 'icon': Icons.record_voice_over_outlined},
      ],
      benefits: [
        'Actionable step-by-step cashflow plans',
        'Debt-relief and optimization roadmaps',
        'Protection against unplanned emergencies',
        'Certified advisor availability on call',
      ],
    ),
    const FinancialServiceModel(
      id: '4',
      title: 'Loan Advisory',
      subtitle: 'Find the right loan solution as per your needs.',
      category: 'Consulting',
      about:
      'Compare multiple lenders, understand hidden fees, and choose competitive interest rates with tailored guidance across all major banks and NBFCs.',
      icon: Icons.request_quote_outlined,
      iconColor: Color(0xFFD97706),
      features: [
        {'title': 'Lowest\nRates', 'icon': Icons.percent_rounded},
        {'title': 'Fast\nApproval', 'icon': Icons.bolt_rounded},
        {'title': 'Multi-Bank\nOptions', 'icon': Icons.account_balance_rounded},
        {'title': 'No Hidden\nCost', 'icon': Icons.visibility_outlined},
      ],
      benefits: [
        'Unbiased loan comparison across 10+ banks',
        'Credit profile assessment before applying',
        'Negotiation support for lower processing fees',
        'Dedicated relationship manager till disbursal',
      ],
    ),
    const FinancialServiceModel(
      id: '5',
      title: 'Tax Planning',
      subtitle: 'Optimize your taxes and save more.',
      category: 'Planning',
      about:
      'Legally optimize your direct and indirect tax liabilities through legitimate deductions, tax-saving investment vehicles, and proactive annual planning.',
      icon: Icons.receipt_long_outlined,
      iconColor: Color(0xFFEA580C),
      features: [
        {'title': 'Section 80C\nMaximizer', 'icon': Icons.savings_outlined},
        {'title': 'Capital\nGains', 'icon': Icons.show_chart_rounded},
        {'title': 'ITR\nGuidance', 'icon': Icons.description_outlined},
        {'title': 'Year-End\nAudit', 'icon': Icons.event_available_outlined},
      ],
      benefits: [
        'Complete tax-saving portfolio structuring',
        'Capital gains tax minimization guidance',
        'Hassle-free preparation for ITR filing',
        'Year-round tax updates and advisories',
      ],
    ),
    const FinancialServiceModel(
      id: '6',
      title: 'Retirement Planning',
      subtitle: 'Plan for a secure and comfortable future.',
      category: 'Planning',
      about:
      'Build an independent retirement corpus that guarantees steady post-retirement monthly cashflows and healthcare security without dependency.',
      icon: Icons.elderly_rounded,
      iconColor: Color(0xFF0D9488),
      features: [
        {'title': 'Pension\nSchemes', 'icon': Icons.account_balance_outlined},
        {'title': 'Corpus\nEstimate', 'icon': Icons.calculate_outlined},
        {'title': 'Health\nCoverage', 'icon': Icons.health_and_safety_outlined},
        {'title': 'Wealth\nTransfer', 'icon': Icons.family_restroom_rounded},
      ],
      benefits: [
        'Precise retirement corpus calculation based on inflation',
        'NPS, PPF, and annuity product selection',
        'Healthcare cost hedging strategies',
        'Estate and succession planning assistance',
      ],
    ),
  ];
}