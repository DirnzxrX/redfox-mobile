import 'package:flutter/material.dart';
import '../../core/theme.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color dotColor;

  const StatCard({
    super.key, 
    required this.title, 
    required this.value, 
    required this.dotColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title, 
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value, 
            style: TextStyle(
              color: dotColor == AppColors.textSecondary ? AppColors.textMain : dotColor, 
              fontSize: 24, 
              fontWeight: FontWeight.bold
            )
          ),
        ],
      ),
    );
  }
}