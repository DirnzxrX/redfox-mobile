import 'package:flutter/material.dart';
import '../../core/theme.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const DashboardCard({
    super.key, 
    required this.title, 
    this.subtitle,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg, // Warna background kartu gelap
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)), // Sedikit garis luar biar elegan
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, 
                    style: const TextStyle(
                      color: AppColors.textMain, 
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!, 
                      style: const TextStyle(
                        color: AppColors.textSecondary, 
                        fontSize: 12,
                      )
                    ),
                  ]
                ],
              ),
              const Icon(Icons.more_horiz, color: AppColors.textSecondary, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}