import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/error_widget.dart' as error_widget;
import '../providers/dashboard_provider.dart';
import '../widgets/stat_card.dart';

class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({super.key});

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboardStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.stats == null) {
            return const Center(
              child: LoadingWidget(message: 'جاري تحميل الإحصائيات...'),
            );
          }

          if (provider.error != null && provider.stats == null) {
            return Center(
              child: error_widget.ErrorDisplayWidget(
                message: provider.error!,
                onRetry: () => provider.fetchDashboardStats(),
              ),
            );
          }

          final stats = provider.stats;
          if (stats == null) {
            return const Center(
              child: Text('لا توجد بيانات'),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                              // Welcome Section
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.primaryColor,
                                      theme.primaryColor.withValues(alpha: 0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.dashboard,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'مرحباً بك في لوحة التحكم',
                                            style: theme.textTheme.headlineSmall?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'إليك نظرة عامة على إحصائيات النظام',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Statistics Grid
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 4,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.3,
                                children: [
                                  StatCard(
                                    title: 'إجمالي المستخدمين',
                                    value: stats.totalUsers.toString(),
                                    icon: Icons.people,
                                    color: Colors.blue,
                                    onTap: () => context.go('/users'),
                                  ),
                                  StatCard(
                                    title: 'الشكاوى النشطة',
                                    value: stats.totalComplaints.toString(),
                                    icon: Icons.report_problem,
                                    color: Colors.orange,
                                    onTap: () => context.go('/complaints'),
                                  ),
                                  StatCard(
                                    title: 'الطلبات المعلقة',
                                    value: stats.pendingRequests.toString(),
                                    icon: Icons.pending_actions,
                                    color: Colors.amber,
                                    onTap: () => context.go('/requests'),
                                  ),
                                  StatCard(
                                    title: 'الاستحقاقات المالية النشطة',
                                    value: stats.activeBills.toString(),
                                    icon: Icons.receipt,
                                    color: Colors.green,
                                    onTap: () => context.go('/bills'),
                                  ),
                                  StatCard(
                                    title: 'المشاريع الجارية',
                                    value: stats.totalProjects.toString(),
                                    icon: Icons.work,
                                    color: Colors.purple,
                                    onTap: () => context.go('/projects'),
                                  ),
                                  StatCard(
                                    title: 'الاستطلاعات النشطة',
                                    value: stats.activePolls.toString(),
                                    icon: Icons.poll,
                                    color: Colors.teal,
                                    onTap: () => context.go('/polls'),
                                  ),
                                  StatCard(
                                    title: 'إجمالي التعاميم',
                                    value: stats.totalCirculars.toString(),
                                    icon: Icons.campaign,
                                    color: Colors.indigo,
                                    onTap: () => context.go('/circulars'),
                                  ),
                                  StatCard(
                                    title: 'إشعارات اليوم',
                                    value: stats.todayNotifications.toString(),
                                    icon: Icons.notifications,
                                    color: Colors.red,
                                    onTap: () => context.go('/notifications'),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Quick Actions
                              Text(
                                'إجراءات سريعة',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  _buildQuickActionButton(
                                    context,
                                    icon: Icons.person_add,
                                    label: 'إضافة مستخدم',
                                    color: Colors.blue,
                                    onTap: () => context.go('/users/create'),
                                  ),
                                  _buildQuickActionButton(
                                    context,
                                    icon: Icons.campaign,
                                    label: 'إنشاء تعميم',
                                    color: Colors.indigo,
                                    onTap: () => context.go('/circulars/create'),
                                  ),
                                  _buildQuickActionButton(
                                    context,
                                    icon: Icons.work,
                                    label: 'إضافة مشروع',
                                    color: Colors.purple,
                                    onTap: () => context.go('/projects/create'),
                                  ),
                                  _buildQuickActionButton(
                                    context,
                                    icon: Icons.poll,
                                    label: 'إنشاء استطلاع',
                                    color: Colors.teal,
                                    onTap: () => context.go('/polls/create'),
                                  ),
                                  _buildQuickActionButton(
                                    context,
                                    icon: Icons.notifications_active,
                                    label: 'إرسال إشعار',
                                    color: Colors.red,
                                    onTap: () => context.go('/notifications/send'),
                                  ),
                                ],
                              ),
                            ],
                          );
                    },
                  ),
                );
              }
            }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
