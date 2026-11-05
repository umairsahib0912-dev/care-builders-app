import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/helpers.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../models/user_model.dart';
import '../../widgets/dashboard/stats_card.dart';
import '../../widgets/dashboard/quick_action_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _currentUser;
  int _totalProjects = 0;
  int _activeProjects = 0;
  int _totalWorkers = 0;
  double _totalIncome = 0.0;
  double _totalExpenses = 0.0;
  double _profitLoss = 0.0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadDashboardData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _authService.getCurrentUserData();
      if (mounted) {
        setState(() {
          _currentUser = userData;
        });
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<void> _loadDashboardData() async {
    try {
      // Get projects count
      final projectsSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .get();

      final activeProjectsSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .where('status', isEqualTo: 'In Progress')
          .get();

      // Get workers count
      final workersSnapshot = await FirebaseFirestore.instance
          .collection('labour')
          .where('isActive', isEqualTo: true)
          .get();

      // Get total income
      final incomeSnapshot = await FirebaseFirestore.instance
          .collection('income')
          .get();

      double totalIncome = 0;
      for (var doc in incomeSnapshot.docs) {
        totalIncome += (doc.data()['amount'] ?? 0).toDouble();
      }

      // Get total expenses
      final expensesSnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .get();

      double totalExpenses = 0;
      for (var doc in expensesSnapshot.docs) {
        totalExpenses += (doc.data()['amount'] ?? 0).toDouble();
      }

      if (mounted) {
        setState(() {
          _totalProjects = projectsSnapshot.docs.length;
          _activeProjects = activeProjectsSnapshot.docs.length;
          _totalWorkers = workersSnapshot.docs.length;
          _totalIncome = totalIncome;
          _totalExpenses = totalExpenses;
          _profitLoss = totalIncome - totalExpenses;
        });
      }
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppHelpers.getGreeting(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            Text(
              _currentUser?.fullName ?? 'User',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadDashboardData();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Cards
              Text(
                'Overview',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Row 1: Projects and Workers
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      title: AppStrings.totalProjects,
                      value: _totalProjects.toString(),
                      icon: Icons.business_center,
                      color: AppColors.primaryGreen,
                      onTap: () => Navigator.pushNamed(context, '/projects'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatsCard(
                      title: AppStrings.activeProjects,
                      value: _activeProjects.toString(),
                      icon: Icons.work,
                      color: AppColors.info,
                      onTap: () => Navigator.pushNamed(context, '/projects'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Row 2: Total Workers
              StatsCard(
                title: AppStrings.totalWorkers,
                value: _totalWorkers.toString(),
                icon: Icons.people,
                color: AppColors.gold,
                onTap: () => Navigator.pushNamed(context, '/labour'),
              ),
              const SizedBox(height: 12),

              // Row 3: Financial Stats
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      title: AppStrings.totalIncome,
                      value: AppHelpers.formatCurrencyShort(_totalIncome),
                      icon: Icons.trending_up,
                      color: AppColors.success,
                      onTap: () => Navigator.pushNamed(context, '/income'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatsCard(
                      title: AppStrings.totalExpenses,
                      value: AppHelpers.formatCurrencyShort(_totalExpenses),
                      icon: Icons.trending_down,
                      color: AppColors.error,
                      onTap: () => Navigator.pushNamed(context, '/expenses'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Profit/Loss Card
              StatsCard(
                title: AppStrings.profitLoss,
                value: AppHelpers.formatCurrencyShort(_profitLoss),
                icon: _profitLoss >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                color: _profitLoss >= 0 ? AppColors.success : AppColors.error,
                onTap: () => Navigator.pushNamed(context, '/reports'),
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Text(
                AppStrings.quickActions,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  QuickActionButton(
                    icon: Icons.add_business,
                    label: 'Add Project',
                    onTap: () => Navigator.pushNamed(context, '/add-project'),
                  ),
                  QuickActionButton(
                    icon: Icons.person_add,
                    label: 'Add Worker',
                    onTap: () => Navigator.pushNamed(context, '/add-labour'),
                  ),
                  QuickActionButton(
                    icon: Icons.check_circle_outline,
                    label: 'Attendance',
                    onTap: () => Navigator.pushNamed(context, '/attendance'),
                  ),
                  QuickActionButton(
                    icon: Icons.inventory,
                    label: 'Inventory',
                    onTap: () => Navigator.pushNamed(context, '/inventory'),
                  ),
                  QuickActionButton(
                    icon: Icons.shopping_cart,
                    label: 'Purchase',
                    onTap: () => Navigator.pushNamed(context, '/purchases'),
                  ),
                  QuickActionButton(
                    icon: Icons.assessment,
                    label: 'Reports',
                    onTap: () => Navigator.pushNamed(context, '/reports'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.white,
                    child: Text(
                      AppHelpers.getInitials(_currentUser?.fullName ?? 'User'),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentUser?.fullName ?? 'User',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currentUser?.email ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _currentUser?.role.toUpperCase() ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.dashboard, 'Dashboard', '/dashboard'),
                _buildDrawerItem(Icons.business, 'Projects', '/projects'),
                _buildDrawerItem(Icons.people, 'Labour', '/labour'),
                _buildDrawerItem(Icons.check_circle, 'Attendance', '/attendance'),
                _buildDrawerItem(Icons.inventory_2, 'Inventory', '/inventory'),
                _buildDrawerItem(Icons.shopping_bag, 'Purchases', '/purchases'),
                _buildDrawerItem(Icons.attach_money, 'Income', '/income'),
                _buildDrawerItem(Icons.money_off, 'Expenses', '/expenses'),
                _buildDrawerItem(Icons.bar_chart, 'Reports', '/reports'),
                const Divider(),
                _buildDrawerItem(Icons.settings, 'Settings', '/settings'),
                _buildDrawerItem(Icons.help_outline, 'Help', null),
                _buildDrawerItem(Icons.logout, 'Logout', null, isLogout: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, String? route,
      {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? AppColors.error : AppColors.primaryGreen),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? AppColors.error : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () async {
        Navigator.pop(context);
        if (isLogout) {
          await _authService.signOut();
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        } else if (route != null) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
