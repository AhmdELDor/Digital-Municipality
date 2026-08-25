import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/providers/theme_provider.dart';

class DashboardSidebar extends StatelessWidget {
  final String currentRoute;
  final bool isCompact;

  const DashboardSidebar({
    super.key,
    required this.currentRoute,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sidebarWidth = isCompact ? 200.0 : 260.0;
    final iconSize = isCompact ? 20.0 : 24.0;
    final fontSize = isCompact ? 13.0 : 14.0;

    return Container(
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: isCompact ? 12 : 16),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isCompact ? 8 : 12),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.account_balance,
                        size: isCompact ? 28 : 32,
                        color: themeProvider.isDarkMode 
                          ? Colors.white 
                          : theme.primaryColor,
                      ),
                    ),
                    SizedBox(height: isCompact ? 8 : 12),
                    Text(
                      isCompact ? 'البلدية' : 'البلدية الرقمية',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isCompact ? 14 : null,
                        color: themeProvider.isDarkMode 
                          ? Colors.white 
                          : theme.textTheme.titleMedium?.color,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(height: 1),

          // Navigation Menu
          Expanded(
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                final isSuperAdmin = authProvider.user?.role == 'superadmin';
                
                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.dashboard,
                      title: 'لوحة المعلومات',
                      route: '/dashboard',
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.people,
                      title: 'المستخدمين',
                      route: '/users',
                      isLocked: !isSuperAdmin,
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.business,
                      title: 'الخدمات',
                      route: '/services',
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.report_problem,
                      title: 'الشكاوى',
                      route: '/complaints',
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.receipt,
                      title: 'الاستحقاقات المالية',
                      route: '/bills',
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.campaign,
                      title: 'التعاميم',
                      route: '/circulars',
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.work,
                      title: 'المشاريع',
                      route: '/projects',
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.poll,
                      title: 'الاستطلاعات',
                      route: '/polls',
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.comment,
                      title: 'الاقتراحات',
                      route: '/suggestions',
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.assignment,
                      title: 'نماذج المعاملات',
                      route: '/request-forms',
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.inbox,
                      title: 'معاملات المواطنين',
                      route: '/user-requests',
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.explore,
                      title: 'اكسبلور',
                      route: '/explore',
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.notifications,
                      title: 'الإشعارات',
                      route: '/notifications',
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.history,
                      title: 'سجل الأنشطة',
                      route: '/logs',
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.settings,
                      title: 'الإعدادات',
                      route: '/settings',
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                  ],
                );
              },
            ),
          ),

          const Divider(height: 1),

          // Logout Button
          Padding(
            padding: EdgeInsets.all(isCompact ? 6 : 8),
            child: Material(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  context.read<AuthProvider>().logout();
                  context.go('/login');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 8 : 12, 
                    vertical: isCompact ? 8 : 12,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: iconSize),
                      SizedBox(width: isCompact ? 8 : 12),
                      Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    bool isLocked = false,
    required double iconSize,
    required double fontSize,
  }) {
    final isSelected = currentRoute == route;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        selected: isSelected,
        selectedTileColor: isDarkMode 
            ? theme.primaryColor.withValues(alpha: 0.25)
            : theme.primaryColor.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        leading: Icon(
          icon,
          size: iconSize,
          color: isSelected 
              ? (isDarkMode ? Colors.white : theme.primaryColor)
              : (isLocked ? Colors.grey.shade400 : null),
        ),
        trailing: isLocked ? Icon(Icons.lock, size: isCompact ? 14 : 16, color: Colors.grey.shade400) : null,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
            color: isSelected 
                ? (isDarkMode ? Colors.white : theme.primaryColor)
                : (isLocked ? Colors.grey.shade400 : null),
          ),
        ),
        onTap: isLocked 
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('هذه الصفحة مخصصة للمدير العام فقط'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            : () => context.go(route),
      ),
    );
  }
}
