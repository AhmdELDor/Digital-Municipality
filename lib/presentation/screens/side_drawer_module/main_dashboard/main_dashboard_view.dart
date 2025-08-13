part of 'main_dashboard_imports.dart';
class MainDashboardView extends StatefulWidget {
  final Widget child;
  const MainDashboardView({super.key, required this.child});

  @override
  State<MainDashboardView> createState() => _MainDashboardViewState();
}

class _MainDashboardViewState extends State<MainDashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (ResponsiveView.isDesktop(context))
            SizedBox(
                width: 260,
                height: MediaQuery.sizeOf(context).height,
                child: SideDrawerMenu()),

          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
