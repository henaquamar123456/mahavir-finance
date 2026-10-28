import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/theme/app_text_styles.dart';
import '../loans/inquiry_status_screen.dart';

enum NotificationType { inquiry, offer, system }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final NotificationType type;
  bool isRead;
  final String? relatedInquiryId;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
    this.relatedInquiryId,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Document Required for Personal Loan',
      message:
      'Please upload your latest 3 months salary slips for inquiry ID: MF202610200001.',
      timeAgo: '10 mins ago',
      type: NotificationType.inquiry,
      isRead: false,
      relatedInquiryId: 'MF202610200001',
    ),
    NotificationItem(
      id: '2',
      title: 'Loan Inquiry Under Review',
      message:
      'Our financial team has started reviewing your Home Loan inquiry (ID: MF202610150003).',
      timeAgo: '2 hours ago',
      type: NotificationType.inquiry,
      isRead: false,
      relatedInquiryId: 'MF202610150003',
    ),
    NotificationItem(
      id: '3',
      title: 'Special Pre-Approved Offer!',
      message:
      'Get an instant Business Loan of up to ₹10 Lakhs at special reduced rates of 9.99% p.a.',
      timeAgo: '1 day ago',
      type: NotificationType.offer,
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Car Loan Approved!',
      message:
      'Congratulations! Your Car Loan inquiry MF202610100005 has been approved by our lending partner.',
      timeAgo: '3 days ago',
      type: NotificationType.inquiry,
      isRead: true,
      relatedInquiryId: 'MF202610100005',
    ),
    NotificationItem(
      id: '5',
      title: 'New Financial Blog Published',
      message:
      'Read our new guide on "How to Improve Your CIBIL Score Before Applying for a Loan".',
      timeAgo: '5 days ago',
      type: NotificationType.system,
      isRead: true,
    ),
  ];

  List<NotificationItem> get _filteredNotifications {
    if (_selectedFilter == 'Unread') {
      return _notifications.where((n) => !n.isRead).toList();
    } else if (_selectedFilter == 'Inquiries') {
      return _notifications.where((n) => n.type == NotificationType.inquiry).toList();
    } else if (_selectedFilter == 'Offers') {
      return _notifications.where((n) => n.type == NotificationType.offer).toList();
    }
    return _notifications;
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

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
          'Notifications',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Pills
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: ['All', 'Unread', 'Inquiries', 'Offers'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedFilter = filter),
                      selectedColor: AppColors.secondary,
                      backgroundColor: const Color(0xFFF1F5F9),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppColors.secondary : Colors.transparent,
                        ),
                      ),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),

            // Notification List
            Expanded(
              child: _filteredNotifications.isEmpty
                  ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications_off_outlined,
                        size: 48, color: AppColors.iconSecondary.withValues(alpha: 0.5)),
                    const SizedBox(height: 12),
                    const Text(
                      'No notifications found',
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              )
                  : ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _filteredNotifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = _filteredNotifications[index];
                  return _buildNotificationCard(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item) {
    IconData icon;
    Color iconColor;
    Color iconBg;

    switch (item.type) {
      case NotificationType.inquiry:
        icon = Icons.assignment_outlined;
        iconColor = const Color(0xFF0284C7);
        iconBg = const Color(0xFFEFF6FF);
        break;
      case NotificationType.offer:
        icon = Icons.local_offer_outlined;
        iconColor = const Color(0xFFD97706);
        iconBg = const Color(0xFFFEF3C7);
        break;
      case NotificationType.system:
        icon = Icons.article_outlined;
        iconColor = AppColors.secondary;
        iconBg = const Color(0xFFDCFCE7);
        break;
    }

    return InkWell(
      onTap: () {
        setState(() => item.isRead = true);
        if (item.relatedInquiryId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => InquiryStatusScreen(inquiryId: item.relatedInquiryId!),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.white : const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: item.isRead ? AppColors.border : const Color(0xFFBBF7D0),
            width: item.isRead ? 1 : 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      if (!item.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.timeAgo,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}