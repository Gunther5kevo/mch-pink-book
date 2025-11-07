/// lib/presentation/screens/nurse/patient_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/core/constants/app_constants.dart';

import 'package:mch_pink_book/domain/entities/patient_entity.dart' as domain;

import 'tabs/pregnancy_tab.dart';
import 'tabs/children_tab.dart';
import 'tabs/appointments_tab.dart';
import 'record_visit_bottom_sheet.dart';

class PatientProfileScreen extends ConsumerStatefulWidget {
  final domain.Patient patient;
  const PatientProfileScreen({super.key, required this.patient});

  @override
  ConsumerState<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends ConsumerState<PatientProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    final isMother = widget.patient.type == 'mother';
    _tabController = TabController(length: isMother ? 3 : 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openRecordVisit() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecordVisitBottomSheet(patient: widget.patient),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMother = widget.patient.type == 'mother';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 210,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsetsDirectional.only(start: 80, bottom: 16),
              title: Text(
                widget.patient.name,
                style: AppTextStyles.h3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    )
                  ],
                ),
              ),
              collapseMode: CollapseMode.parallax,
              background: _HeaderBackground(patient: widget.patient),
            ),
            bottom: isMother
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(56),
                    child: _WhiteTabBar(controller: _tabController),
                  )
                : null,
          ),
        ],
        body: Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: isMother
              ? TabBarView(
                  controller: _tabController,
                  children: [
                    PregnancyTab(motherId: widget.patient.id),
                    ChildrenTab(motherId: widget.patient.id),
                    AppointmentsTab(userId: widget.patient.id),
                  ],
                )
              : AppointmentsTab(userId: widget.patient.id),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openRecordVisit,
        backgroundColor: AppColors.accentGreen,
        foregroundColor: Colors.white,
        elevation: 6,
        highlightElevation: 12,
        icon: const Icon(AppIcons.noteAdd, size: 20),
        label: Text('Record Visit', style: AppTextStyles.button),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. Header – lighter gradient + white overlay for readability
// ---------------------------------------------------------------------------
class _HeaderBackground extends StatelessWidget {
  final domain.Patient patient;
  const _HeaderBackground({required this.patient});

  @override
  Widget build(BuildContext context) {
    final isMother = patient.type == 'mother';
    final primary = isMother ? AppColors.primaryPink : AppColors.accentBlue;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primary,
            primary.withOpacity(0.85),
            primary.withOpacity(0.65),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Light texture – no asset required
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.07),
            ),
          ),
          // Avatar + info
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 54),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Hero(
                    tag: 'avatar-${patient.id}',
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: primary,
                        child: Text(
                          patient.name.isNotEmpty
                              ? patient.name[0].toUpperCase()
                              : '?',
                          style: AppTextStyles.h2.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID: ${patient.id}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          shadows: const [
                            Shadow(
                              color: Colors.black38,
                              offset: Offset(0, 1),
                              blurRadius: 2,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      _StatusChip(
                        label: isMother ? 'Mother' : 'Child',
                        color: Colors.white,
                        backgroundOpacity: 0.3,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. TabBar – white background, rounded top, shadow
// ---------------------------------------------------------------------------
class _WhiteTabBar extends StatelessWidget {
  final TabController controller;
  const _WhiteTabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: TabBar(
        controller: controller,
        indicatorColor: AppColors.primaryPink,
        indicatorWeight: 3,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
        labelColor: AppColors.primaryPink,
        unselectedLabelColor: AppColors.textMedium,
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.bodyMedium,
        tabs: const [
          Tab(icon: Icon(AppIcons.pregnant, size: 20), text: 'Pregnancy'),
          Tab(icon: Icon(AppIcons.child, size: 20), text: 'Children'),
          Tab(icon: Icon(AppIcons.calendar, size: 20), text: 'Appointments'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Re‑usable status chip (white text on semi‑transparent background)
// ---------------------------------------------------------------------------
class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final double backgroundOpacity;

  const _StatusChip({
    required this.label,
    required this.color,
    this.backgroundOpacity = 0.25,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(backgroundOpacity),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}