import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/helpers.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../models/user_model.dart';

class EnhancedDashboardScreen extends StatefulWidget {
  const EnhancedDashboardScreen({super.key});

  @override
  State<EnhancedDashboardScreen> createState() => _EnhancedDashboardScreenState();
}

class _EnhancedDashboardScreenState extends State<EnhancedDashboardScreen>
    with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _currentUser;
  int _totalProjects = 0;
  int _activeProjects = 0;
  int _totalWorkers = 0;
  double _totalIncome = 0.0;
  double _totalExpenses = 0.0;
  double _profitLoss = 0.0;

  late AnimationController _headerController;
  late AnimationController _statsController;
  late Animation<double> _headerAnimation;
  late Animation<double> _statsAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadDashboardData();
    _setupAnimations();
  }

  void _setupAnimations() {
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _statsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    );

    _statsAnimation = CurvedAnimation(
      parent: _statsController,
      curve: Curves.easeOutCubic,
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _statsController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _statsController.dispose();
    super.dispose();
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
      final projectsSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .get();

      final activeProjectsSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .where('status', isEqualTo: 'In Progress')
          .get();

      final workersSnapshot = await FirebaseFirestore.instance
          .collection('labour')
          .where('isActive', isEqualTo: true)
          .get();

      final incomeSnapshot = await FirebaseFirestore.instance
          .collection('income')
          .get();

      double totalIncome = 0;
      for (var doc in incomeSnapshot.docs) {
        totalIncome += (doc.data()['amount'] ?? 0).toDouble();
      }

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.offWhite,
              AppColors.white,
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadDashboardData();
          },
          child: CustomScrollView(
            slivers: [
              // Premium App Bar
              _buildPremiumAppBar(),

              // Dashboard Content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Statistics Cards
                    _buildStatisticsSection(),
                    const SizedBox(height: 24),

                    // Quick Actions
                    _buildQuickActionsSection(),
                    const SizedBox(height: 24),

                    // Recent Activity
                    _buildRecentActivitySection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: _buildPremiumDrawer(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildPremiumAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryGreen,
              AppColors.darkGreen,
              AppColors.charcoal,
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: FlexibleSpaceBar(
          background: Stack(
            children: [
              // Animated pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: PatternPainter(),
                ),
              ),

              // Content
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: FadeTransition(
                    opacity: _headerAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            // Avatar with gold ring
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppColors.goldGradient,
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppHelpers.getInitials(
                                        _currentUser?.fullName ?? 'User',
                                      ),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppHelpers.getGreeting(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _currentUser?.fullName ?? 'User',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Role Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.goldGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            _currentUser?.role.toUpperCase() ?? 'USER',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.charcoal,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          titlePadding: EdgeInsets.zero,
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_rounded, color: AppColors.white),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/notifications');
          },
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.settings_rounded, color: AppColors.white),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildStatisticsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Financial Summary Card
          _buildFinancialSummaryCard(),
          const SizedBox(height: 16),

          // Project & Worker Stats
          Row(
            children: [
              Expanded(
                child: _buildAnimatedStatCard(
                  title: 'Total Projects',
                  value: _totalProjects.toString(),
                  icon: Icons.business_center_rounded,
                  color: AppColors.primaryGreen,
                  index: 0,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnimatedStatCard(
                  title: 'Active',
                  value: _activeProjects.toString(),
                  icon: Icons.work_rounded,
                  color: AppColors.info,
                  index: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _buildAnimatedStatCard(
            title: 'Total Workers',
            value: _totalWorkers.toString(),
            icon: Icons.people_rounded,
            color: AppColors.gold,
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummaryCard() {
    return AnimatedBuilder(
      animation: _statsAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _statsAnimation.value,
          child: Opacity(
            opacity: _statsAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _profitLoss >= 0 ? AppColors.success : AppColors.error,
                    _profitLoss >= 0 ? AppColors.primaryGreen : AppColors.error.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (_profitLoss >= 0 ? AppColors.success : AppColors.error)
                        .withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Profit/Loss',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        _profitLoss >= 0
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: AppColors.white,
                        size: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppHelpers.formatCurrency(_profitLoss),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.white, thickness: 0.5),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Income',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppHelpers.formatCurrencyShort(_totalIncome),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.white.withOpacity(0.3),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Expenses',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppHelpers.formatCurrencyShort(_totalExpenses),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required int index,
  }) {
    return AnimatedBuilder(
      animation: _statsAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _statsAnimation.value) * 50),
          child: Opacity(
            opacity: _statsAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
            children: [
              _buildQuickActionCard(
                icon: Icons.add_business_rounded,
                label: 'Add Project',
                gradient: LinearGradient(
                  colors: [AppColors.primaryGreen, AppColors.lightGreen],
                ),
                onTap: () => Navigator.pushNamed(context, '/add-project'),
              ),
              _buildQuickActionCard(
                icon: Icons.person_add_rounded,
                label: 'Add Worker',
                gradient: LinearGradient(
                  colors: [AppColors.info, AppColors.info.withOpacity(0.7)],
                ),
                onTap: () => Navigator.pushNamed(context, '/add-labour'),
              ),
              _buildQuickActionCard(
                icon: Icons.check_circle_rounded,
                label: 'Attendance',
                gradient: AppColors.goldGradient,
                onTap: () => Navigator.pushNamed(context, '/attendance'),
              ),
              _buildQuickActionCard(
                icon: Icons.inventory_rounded,
                label: 'Inventory',
                gradient: LinearGradient(
                  colors: [AppColors.warning, AppColors.warning.withOpacity(0.7)],
                ),
                onTap: () => Navigator.pushNamed(context, '/inventory'),
              ),
              _buildQuickActionCard(
                icon: Icons.shopping_cart_rounded,
                label: 'Purchase',
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.purple.withOpacity(0.7)],
                ),
                onTap: () => Navigator.pushNamed(context, '/purchases'),
              ),
              _buildQuickActionCard(
                icon: Icons.assessment_rounded,
                label: 'Reports',
                gradient: LinearGradient(
                  colors: [AppColors.error, AppColors.error.withOpacity(0.7)],
                ),
                onTap: () => Navigator.pushNamed(context, '/reports'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.white, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.charcoal,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.lightGrey,
                width: 1,
              ),
            ),
            child: const Center(
              child: Text(
                'No recent activity',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryGreen,
              AppColors.darkGreen,
              AppColors.charcoal,
            ],
          ),
        ),
        child: Column(
          children: [
            // Premium Header
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.goldGradient,
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              AppHelpers.getInitials(
                                _currentUser?.fullName ?? 'User',
                              ),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                        fontSize: 13,
                        color: AppColors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currentUser?.role.toUpperCase() ?? 'USER',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.charcoal,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Menu Items
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  children: [
                    _buildDrawerItem(
                      Icons.dashboard_rounded,
                      'Dashboard',
                      '/dashboard',
                    ),
                    _buildDrawerItem(
                      Icons.business_rounded,
                      'Projects',
                      '/projects',
                    ),
                    _buildDrawerItem(
                      Icons.people_rounded,
                      'Labour',
                      '/labour',
                    ),
                    _buildDrawerItem(
                      Icons.check_circle_rounded,
                      'Attendance',
                      '/attendance',
                    ),
                    _buildDrawerItem(
                      Icons.inventory_2_rounded,
                      'Inventory',
                      '/inventory',
                    ),
                    _buildDrawerItem(
                      Icons.shopping_bag_rounded,
                      'Purchases',
                      '/purchases',
                    ),
                    _buildDrawerItem(
                      Icons.attach_money_rounded,
                      'Income',
                      '/income',
                    ),
                    _buildDrawerItem(
                      Icons.money_off_rounded,
                      'Expenses',
                      '/expenses',
                    ),
                    _buildDrawerItem(
                      Icons.bar_chart_rounded,
                      'Reports',
                      '/reports',
                    ),
                    const Divider(height: 32),
                    _buildDrawerItem(
                      Icons.settings_rounded,
                      'Settings',
                      '/settings',
                    ),
                    _buildDrawerItem(
                      Icons.help_outline_rounded,
                      'Help',
                      null,
                    ),
                    _buildDrawerItem(
                      Icons.logout_rounded,
                      'Logout',
                      null,
                      isLogout: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    String? route, {
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isLogout
              ? AppColors.error.withOpacity(0.1)
              : AppColors.primaryGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isLogout ? AppColors.error : AppColors.primaryGreen,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? AppColors.error : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 15,
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

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.pushNamed(context, '/add-project');
      },
      backgroundColor: AppColors.primaryGreen,
      icon: const Icon(Icons.add_rounded),
      label: const Text(
        'New Project',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      elevation: 8,
    );
  }
}

// Custom painter for header pattern
class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.3),
        50.0 + (i * 20),
        paint,
      );
    }

    for (int i = 0; i < 4; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.2, size.height * 0.7),
        40.0 + (i * 15),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
