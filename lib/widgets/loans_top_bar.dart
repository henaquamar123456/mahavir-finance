import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/asset_constants.dart';

class LoansTopBar extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback onLeadingTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const LoansTopBar({
    super.key,
    this.showBackButton = false,
    required this.onLeadingTap,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu ya Back button
          IconButton(
            onPressed: onLeadingTap,
            icon: Icon(
              showBackButton ? Icons.arrow_back_rounded : Icons.menu_rounded,
              color: AppColors.primary,
              size: 26,
            ),
            splashRadius: 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),

          // Mahavir Finance Logo
          Image.asset(
            AssetsConstants.mahavirLogo,
            height: 38,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'M',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'MAHAVIR',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'FINANCE',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Notification aur Profile Avatar
          Row(
            children: [
              Stack(
                children: [
                  IconButton(
                    onPressed: onNotificationTap,
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.primary,
                      size: 26,
                    ),
                    splashRadius: 24,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.border,
                      width: 1.5,
                    ),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=120&q=80',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}