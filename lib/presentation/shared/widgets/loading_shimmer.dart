/// lib/presentation/shared/widgets/loading_shimmer.dart
library;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_constants.dart';

class LoadingShimmer extends StatelessWidget {
  /// Number of shimmer items to show.
  final int count;

  /// Height of each item (used when `compact` is **false** or when a custom
  /// height is required for a non‑list use‑case).
  final double height;

  /// Width of each item – **optional**.  
  /// When omitted the item stretches to the full width of the parent.
  final double? width;

  /// Border radius of the container – **optional**.  
  /// Defaults to `12` (the original card radius).
  final BorderRadius? borderRadius;

  /// When `true` the skeleton collapses to a compact list‑item style.
  final bool compact;

  const LoadingShimmer({
    super.key,
    this.count = 3,
    this.height = 120,
    this.width,
    this.borderRadius,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    // If a custom width / radius is supplied we render a *single* shimmer box.
    // This is perfect for card‑style placeholders (e.g. the pregnancy card).
    if (width != null || borderRadius != null) {
      return _buildSingleShimmer();
    }

    // Otherwise we keep the original list‑item skeleton.
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      primary: false,
      itemCount: count,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Shimmer.fromColors(
          baseColor: AppColors.primaryPink.withOpacity(0.1),
          highlightColor: AppColors.primaryPink.withOpacity(0.05),
          child: _listItemSkeleton(),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Single‑box shimmer (used for custom width / radius)
  // -------------------------------------------------------------------------
  Widget _buildSingleShimmer() {
    return Column(
      children: List.generate(
        count,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Shimmer.fromColors(
            baseColor: AppColors.primaryPink.withOpacity(0.1),
            highlightColor: AppColors.primaryPink.withOpacity(0.05),
            child: Container(
              height: compact ? 72 : height,
              width: width ?? double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: borderRadius ?? BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // The original list‑item skeleton (unchanged)
  // -------------------------------------------------------------------------
  Widget _listItemSkeleton() {
    return Container(
      height: compact ? 72 : height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Icon placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),

          // Text lines
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: 180,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: 120,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}