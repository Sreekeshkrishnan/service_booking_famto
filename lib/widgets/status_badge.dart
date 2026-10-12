import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final BookingStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;

    switch (status) {
      case BookingStatus.confirmed:
        bg = AppTheme.primaryLight;
        fg = AppTheme.primaryColor;
        icon = Icons.event_available_rounded;
        break;
      case BookingStatus.inProgress:
        bg = AppTheme.warningLight;
        fg = AppTheme.warningColor;
        icon = Icons.timelapse_rounded;
        break;
      case BookingStatus.completed:
        bg = AppTheme.successLight;
        fg = AppTheme.successColor;
        icon = Icons.check_circle_rounded;
        break;
      case BookingStatus.cancelled:
        bg = AppTheme.errorLight;
        fg = AppTheme.errorColor;
        icon = Icons.cancel_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
