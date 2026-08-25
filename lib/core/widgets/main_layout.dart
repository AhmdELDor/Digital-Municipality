import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/theme_provider.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/dashboard/widgets/dashboard_sidebar.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool _isSidebarCollapsed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Auto-collapse sidebar on initial load for small screens
    if (screenWidth < 1200 && !_isSidebarCollapsed) {
      setState(() {
        _isSidebarCollapsed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentRoute = GoRouterState.of(context).uri.toString();
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Auto-collapse sidebar on smaller screens, but allow manual toggle
    final isSmallScreen = screenWidth < 1200;
    final shouldCollapse = _isSidebarCollapsed;
    final sidebarWidth = shouldCollapse ? 0.0 : (screenWidth < 1400 ? 200.0 : 260.0);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar with responsive width and animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: sidebarWidth,
            child: shouldCollapse
                ? const SizedBox.shrink()
                : DashboardSidebar(
                    currentRoute: currentRoute,
                    isCompact: screenWidth < 1400,
                  ),
          ),

          // Main Content
          Expanded(
            child: Container(
              color: theme.scaffoldBackgroundColor,
              child: Column(
                children: [
                  // App Bar
                  Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Sidebar toggle button  
                        IconButton(
                          icon: Icon(shouldCollapse ? Icons.menu : Icons.menu_open),
                          onPressed: () {
                            setState(() {
                              _isSidebarCollapsed = !_isSidebarCollapsed;
                            });
                          },
                          tooltip: shouldCollapse ? 'فتح القائمة' : 'إغلاق القائمة',
                        ),
                        const Spacer(),
                        // Theme toggle button
                        Consumer<ThemeProvider>(
                          builder: (context, themeProvider, _) {
                            return IconButton(
                              icon: Icon(
                                themeProvider.isDarkMode 
                                    ? Icons.light_mode_outlined 
                                    : Icons.dark_mode_outlined,
                              ),
                              onPressed: () => themeProvider.toggleTheme(),
                              tooltip: themeProvider.isDarkMode 
                                  ? 'الوضع الفاتح' 
                                  : 'الوضع الداكن',
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          onPressed: () => context.go('/notifications'),
                          tooltip: 'الإشعارات',
                        ),
                        const SizedBox(width: 8),
                        // User Avatar Dropdown
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                            final user = authProvider.user;
                            final isDarkMode = Theme.of(context).brightness == Brightness.dark;
                            return PopupMenuButton<String>(
                              offset: const Offset(0, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: isDarkMode 
                                        ? theme.primaryColor.withValues(alpha: 0.3)
                                        : theme.primaryColor.withValues(alpha: 0.2),
                                    child: Text(
                                      user?.fullName.substring(0, 1).toUpperCase() ?? 'A',
                                      style: TextStyle(
                                        color: isDarkMode 
                                            ? Colors.white
                                            : theme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_drop_down, size: 20),
                                ],
                              ),
                              itemBuilder: (context) => <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  enabled: false,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      user?.fullName ?? 'مسؤول',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const PopupMenuDivider(),
                                PopupMenuItem<String>(
                                  value: 'profile',
                                  child: const Row(
                                    children: [
                                      Icon(Icons.person, size: 20),
                                      SizedBox(width: 12),
                                      Text('الملف الشخصي'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'settings',
                                  child: const Row(
                                    children: [
                                      Icon(Icons.settings, size: 20),
                                      SizedBox(width: 12),
                                      Text('الإعدادات'),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'profile') {
                                  context.go('/settings');
                                } else if (value == 'settings') {
                                  context.go('/settings');
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Page Content
                  Expanded(
                    child: widget.child,
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
