
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.showBackButton = false,
    this.centerTitle = false,
    this.backgroundColor = Colors.white,
    this.titleColor = AppColors.primary,
    this.elevation = 0,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool centerTitle;
  final Color backgroundColor;
  final Color titleColor;
  final double elevation;

  @override
  Size get preferredSize => Size.fromHeight(
    subtitle == null ? 64 : 76,
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: titleColor,
      surfaceTintColor: Colors.transparent,
      elevation: elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: showBackButton,
      leading: leading,
      actions: actions,
      titleSpacing: 16,
      title: Column(
        crossAxisAlignment:
        centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: titleColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 3),
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: titleColor.withValues(alpha: 0.65),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.border.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
