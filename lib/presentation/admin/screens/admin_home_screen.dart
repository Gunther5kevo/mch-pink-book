/// Admin Home Screen - Complete Version
/// Main dashboard for administrators
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/providers.dart';

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              _showComingSoon(context, 'Notifications');
            },
          ),
        ],
      ),
      body: currentUser.when(
        data: (user) => _buildContent(context, user),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryPink, AppColors.primaryPinkDark],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.admin_panel_settings, color: Colors.white, size: 48),
                SizedBox(height: 8),
                Text(
                  'Admin Portal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.dashboard,
            title: 'Dashboard',
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.people,
            title: 'Manage Users',
            onTap: () => _showComingSoon(context, 'Manage Users'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.local_hospital,
            title: 'Manage Clinics',
            onTap: () => _showComingSoon(context, 'Manage Clinics'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.article,
            title: 'Health Articles',
            onTap: () => _showComingSoon(context, 'Health Articles'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.bar_chart,
            title: 'Analytics',
            onTap: () => _showComingSoon(context, 'Analytics'),
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => _showComingSoon(context, 'Settings'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              // TODO: Implement logout
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildContent(BuildContext context, user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          _buildWelcomeCard(user),
          const SizedBox(height: 24),

          // System Stats
          const Text('System Overview', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          _buildSystemStats(),
          const SizedBox(height: 24),

          // Quick Admin Actions
          const Text('Admin Actions', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          _buildAdminActions(context),
          const SizedBox(height: 24),

          // Recent Activity
          const Text('Recent Activity', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryPink, AppColors.primaryPinkDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'System Administrator',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemStats() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          icon: Icons.people,
          label: 'Total Users',
          value: '1,234',
          color: AppColors.accentBlue,
          trend: '+12%',
        ),
        _buildStatCard(
          icon: Icons.local_hospital,
          label: 'Clinics',
          value: '45',
          color: AppColors.accentGreen,
          trend: '+3',
        ),
        _buildStatCard(
          icon: Icons.child_care,
          label: 'Children',
          value: '2,567',
          color: AppColors.primaryPink,
          trend: '+28%',
        ),
        _buildStatCard(
          icon: Icons.vaccines,
          label: 'Vaccines Given',
          value: '8,432',
          color: AppColors.accentOrange,
          trend: '+156',
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required String trend,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 28),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    trend,
                    style: const TextStyle(
                      color: AppColors.success,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminActions(BuildContext context) {
    return Column(
      children: [
        _buildActionCard(
          context,
          icon: Icons.person_add,
          title: 'Add New User',
          subtitle: 'Register mother or nurse',
          onTap: () => _showComingSoon(context, 'Add User'),
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          context,
          icon: Icons.add_business,
          title: 'Add Clinic',
          subtitle: 'Register new health facility',
          onTap: () => _showComingSoon(context, 'Add Clinic'),
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          context,
          icon: Icons.article,
          title: 'Publish Article',
          subtitle: 'Add health education content',
          onTap: () => _showComingSoon(context, 'Publish Article'),
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          context,
          icon: Icons.download,
          title: 'Export Data',
          subtitle: 'Download system reports',
          onTap: () => _showComingSoon(context, 'Export Data'),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryPinkLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryPink),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      children: [
        _buildActivityItem(
          icon: Icons.person_add,
          title: 'New user registered',
          subtitle: 'Grace Muthoni joined as Mother',
          time: '2 hours ago',
          color: AppColors.accentBlue,
        ),
        const Divider(),
        _buildActivityItem(
          icon: Icons.edit,
          title: 'Article updated',
          subtitle: 'Breastfeeding Benefits (Swahili)',
          time: '5 hours ago',
          color: AppColors.accentGreen,
        ),
        const Divider(),
        _buildActivityItem(
          icon: Icons.add_business,
          title: 'Clinic added',
          subtitle: 'Kiambu District Hospital',
          time: 'Yesterday',
          color: AppColors.accentOrange,
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textLight,
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}