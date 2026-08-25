import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'app/theme/app_theme.dart';
import 'app/routes.dart';
import 'core/services/storage_service.dart';
import 'core/providers/theme_provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/dashboard/providers/dashboard_provider.dart';
import 'features/users/providers/users_provider.dart';
import 'features/users/services/users_service.dart';
import 'features/services/providers/services_provider.dart';
import 'features/services/services/services_service.dart';
import 'features/bills/providers/bills_provider.dart';
import 'features/bills/services/bills_service.dart';
import 'features/circulars/providers/circulars_provider.dart';
import 'features/circulars/services/circulars_service.dart';
import 'features/projects/providers/projects_provider.dart';
import 'features/projects/services/projects_service.dart';
import 'features/complaints/providers/complaints_provider.dart';
import 'features/complaints/services/complaints_service.dart';
import 'features/polls/providers/polls_provider.dart';
import 'features/polls/services/polls_service.dart';
import 'features/suggestions/providers/suggestions_provider.dart';
import 'features/suggestions/services/suggestions_service.dart';
import 'features/request_forms/providers/request_forms_provider.dart';
import 'features/request_forms/providers/user_requests_provider.dart';
import 'features/request_forms/services/request_forms_service.dart';
import 'features/request_forms/services/user_requests_service.dart';
import 'features/notifications/providers/notifications_provider.dart';
import 'features/explores/providers/explores_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  final storageService = await StorageService.getInstance();
  
  // Initialize theme provider
  final themeProvider = await ThemeProvider.create(storageService);
  
  // Initialize auth provider
  final authProvider = await AuthProvider.create();
  
  // Initialize dashboard provider
  final dashboardProvider = await DashboardProvider.create();
  
  // Initialize users service and provider
  final usersService = UsersService(storageService);
  final usersProvider = await UsersProvider.create(usersService);
  
  // Initialize services provider
  final servicesService = ServicesService(storageService);
  final servicesProvider = await ServicesProvider.create(servicesService);

  // Initialize bills provider
  final billsService = BillsService(storageService);
  final billsProvider = await BillsProvider.create(billsService);

  // Initialize circulars provider
  final circularsService = CircularsService(storageService);
  final circularsProvider = await CircularsProvider.create(circularsService);

  // Initialize projects provider
  final projectsService = ProjectsService(storageService);
  final projectsProvider = await ProjectsProvider.create(projectsService);

  // Initialize complaints provider
  final complaintsService = ComplaintsService(storageService);
  final complaintsProvider = await ComplaintsProvider.create(complaintsService);

  // Initialize polls provider
  final pollsService = PollsService(storageService);
  final pollsProvider = PollsProvider.create(pollsService);

  // Initialize suggestions provider
  final suggestionsService = SuggestionsService(storageService);
  final suggestionsProvider = SuggestionsProvider.create(suggestionsService);

  // Initialize request forms provider
  final requestFormsService = RequestFormsService(storageService);
  final requestFormsProvider = RequestFormsProvider.create(requestFormsService);

  // Initialize user requests provider
  final userRequestsService = UserRequestsService(storageService);
  final userRequestsProvider = UserRequestsProvider.create(userRequestsService);

  // Initialize notifications provider
  final notificationsProvider = NotificationsProvider(storageService);

  // Initialize explores provider
  final exploresProvider = ExploresProvider(storageService);
  
  // Set preferred orientations (tablet/desktop primarily)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(MyApp(
    themeProvider: themeProvider,
    authProvider: authProvider,
    dashboardProvider: dashboardProvider,
    usersProvider: usersProvider,
    servicesProvider: servicesProvider,
    billsProvider: billsProvider,
    circularsProvider: circularsProvider,
    projectsProvider: projectsProvider,
    complaintsProvider: complaintsProvider,
    pollsProvider: pollsProvider,
    notificationsProvider: notificationsProvider,
    suggestionsProvider: suggestionsProvider,
    requestFormsProvider: requestFormsProvider,
    userRequestsProvider: userRequestsProvider,
    exploresProvider: exploresProvider,
  ));
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  final AuthProvider authProvider;
  final DashboardProvider dashboardProvider;
  final UsersProvider usersProvider;
  final ServicesProvider servicesProvider;
  final BillsProvider billsProvider;
  final CircularsProvider circularsProvider;
  final ProjectsProvider projectsProvider;
  final ComplaintsProvider complaintsProvider;
  final PollsProvider pollsProvider;
  final SuggestionsProvider suggestionsProvider;
  final RequestFormsProvider requestFormsProvider;
  final UserRequestsProvider userRequestsProvider;
  final NotificationsProvider notificationsProvider;
  final ExploresProvider exploresProvider;

  const MyApp({
    super.key,
    required this.themeProvider,
    required this.authProvider,
    required this.dashboardProvider,
    required this.usersProvider,
    required this.servicesProvider,
    required this.billsProvider,
    required this.circularsProvider,
    required this.projectsProvider,
    required this.complaintsProvider,
    required this.pollsProvider,
    required this.suggestionsProvider,
    required this.requestFormsProvider,
    required this.userRequestsProvider,
    required this.notificationsProvider,
    required this.exploresProvider,
  });

  @override
  Widget build(BuildContext context) {
    // Create router once, outside of Consumer to prevent recreation on theme changes
    final router = AppRouter.createRouter(authProvider);
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: dashboardProvider),
        ChangeNotifierProvider.value(value: usersProvider),
        ChangeNotifierProvider.value(value: servicesProvider),
        ChangeNotifierProvider.value(value: billsProvider),
        ChangeNotifierProvider.value(value: circularsProvider),
        ChangeNotifierProvider.value(value: projectsProvider),
        ChangeNotifierProvider.value(value: complaintsProvider),
        ChangeNotifierProvider.value(value: pollsProvider),
        ChangeNotifierProvider.value(value: suggestionsProvider),
        ChangeNotifierProvider.value(value: requestFormsProvider),
        ChangeNotifierProvider.value(value: userRequestsProvider),
        ChangeNotifierProvider.value(value: notificationsProvider),
        ChangeNotifierProvider.value(value: exploresProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: 'البلدية الرقمية',
            debugShowCheckedModeBanner: false,
            
            // Arabic RTL support
            locale: const Locale('ar', 'SA'),
            supportedLocales: const [
              Locale('ar', 'SA'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            
            // Theme with dynamic dark mode
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeProvider.themeMode,
        
            // Router
            routerConfig: router,
        
            // RTL text direction
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}


