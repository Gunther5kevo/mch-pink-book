/// lib/presentation/screens/nurse/patient_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/core/constants/app_constants.dart';
import 'package:mch_pink_book/domain/entities/patient_entity.dart' as domain;
import 'package:mch_pink_book/presentation/nurse/screens/add_child_screen.dart';
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

    // Listen to tab changes → update FAB
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {}); // Rebuild to show correct FAB
      }
    });
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

  void _navigateToAddChild() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddChildScreen(
          motherId: widget.patient.id,
          motherName: widget.patient.name,
        ),
      ),
    );
  }

  void _showPatientActions() {
    final isMother = widget.patient.type == 'mother';
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Patient Actions',
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: 16),
                    
                    if (isMother) ...[
                      _buildActionTile(
                        icon: Icons.edit,
                        title: 'Edit Profile',
                        subtitle: 'Update patient information',
                        color: AppColors.primaryPink,
                        onTap: () {
                          Navigator.pop(context);
                          _navigateToEditProfile();
                        },
                      ),
                      const Divider(),
                    ],
                    
                    _buildActionTile(
                      icon: Icons.history,
                      title: 'View Full History',
                      subtitle: 'All visits and records',
                      color: AppColors.accentBlue,
                      onTap: () {
                        Navigator.pop(context);
                        _showComingSoon('View Full History');
                      },
                    ),
                    const Divider(),
                    
                    _buildActionTile(
                      icon: Icons.description,
                      title: 'Generate Report',
                      subtitle: 'Export patient summary',
                      color: AppColors.accentOrange,
                      onTap: () {
                        Navigator.pop(context);
                        _showComingSoon('Generate Report');
                      },
                    ),
                    const Divider(),
                    
                    _buildActionTile(
                      icon: Icons.share,
                      title: 'Share Information',
                      subtitle: 'Send details to another provider',
                      color: AppColors.accentGreen,
                      onTap: () {
                        Navigator.pop(context);
                        _showComingSoon('Share Information');
                      },
                    ),
                    
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _navigateToEditProfile() {
    // Navigate to mother profile screen in edit mode
    // You'll need to import the mother profile screen
    // import 'package:mch_pink_book/presentation/mother/screens/mother_profile_screen.dart';
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditMotherProfileScreen(
          motherId: widget.patient.id,
          motherName: widget.patient.name,
        ),
      ),
    ).then((_) {
      // Refresh data when returning
      setState(() {});
    });
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMother = widget.patient.type == 'mother';
    final currentTabIndex = _tabController.index;

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
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: _showPatientActions,
                tooltip: 'More actions',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(start: 80, bottom: 16),
              title: Text(
                widget.patient.name,
                style: AppTextStyles.h3.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
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
                    ChildrenTab(motherId: widget.patient.id, motherName: widget.patient.name),
                    AppointmentsTab(userId: widget.patient.id),
                  ],
                )
              : AppointmentsTab(userId: widget.patient.id),
        ),
      ),

      // ———————— DYNAMIC FAB ————————
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: (isMother && currentTabIndex == 1)
            ? FloatingActionButton.extended(
                key: const ValueKey('add_child'),
                onPressed: _navigateToAddChild,
                backgroundColor: AppColors.primaryPink,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add),
                label: const Text('Add Child'),
              )
            : FloatingActionButton.extended(
                key: const ValueKey('record_visit'),
                onPressed: _openRecordVisit,
                backgroundColor: AppColors.accentGreen,
                foregroundColor: Colors.white,
                icon: const Icon(AppIcons.noteAdd, size: 20),
                label: const Text('Record Visit'),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// ---------------------------------------------------------------------------
// Edit Mother Profile Screen Wrapper
// ---------------------------------------------------------------------------
class EditMotherProfileScreen extends StatefulWidget {
  final String motherId;
  final String motherName;
  
  const EditMotherProfileScreen({
    super.key,
    required this.motherId,
    required this.motherName,
  });

  @override
  State<EditMotherProfileScreen> createState() => _EditMotherProfileScreenState();
}

class _EditMotherProfileScreenState extends State<EditMotherProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // This is a nurse-initiated edit, so we'll need to create a custom edit screen
    // or adapt the mother profile screen to work for nurses editing mother profiles
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        title: Text('Edit ${widget.motherName}'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 64, color: AppColors.textLight),
              SizedBox(height: 16),
              Text(
                'Profile Editing',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Nurse profile editing screen coming soon!\n\nFor now, mothers can edit their own profiles from the Mother App.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMedium),
              ),
            ],
          ),
        ),
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
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (patient.phone != null) ...[
                          Row(
                            children: [
                              const Icon(Icons.phone, size: 14, color: Colors.white70),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  patient.phone!,
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
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],
                        if (patient.nationalId != null) ...[
                          Row(
                            children: [
                              const Icon(Icons.badge, size: 14, color: Colors.white70),
                              const SizedBox(width: 4),
                              Text(
                                'ID: ${patient.nationalId}',
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
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],
                        _StatusChip(
                          label: isMother ? 'Mother' : 'Child',
                          color: Colors.white,
                          backgroundOpacity: 0.3,
                        ),
                      ],
                    ),
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