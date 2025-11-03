/// Welcome Card Widget
/// Reusable welcome card for both Mother and Nurse screens
library;

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class WelcomeCard extends StatelessWidget {
  final String userName;
  final String? subtitle;
  final List<WelcomeStat>? stats;
  final Widget? badge;
  final List<Color>? gradientColors;

  const WelcomeCard({
    super.key,
    required this.userName,
    this.subtitle,
    this.stats,
    this.badge,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? [
      AppColors.primaryPink,
      AppColors.primaryPinkDark,
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back,',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (badge != null) badge!,
            ],
          ),
          if (stats != null && stats!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: stats!.map((stat) => _buildStatItem(stat)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(WelcomeStat stat) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(stat.icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stat.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              stat.label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class WelcomeStat {
  final IconData icon;
  final String value;
  final String label;

  const WelcomeStat({
    required this.icon,
    required this.value,
    required this.label,
  });
}