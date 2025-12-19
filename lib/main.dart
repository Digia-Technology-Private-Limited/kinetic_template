import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_colors.dart';
import 'core/router/app_router.dart';
import 'data/services/dio_client.dart';
import 'data/services/api_service.dart';
import 'data/services/storage_service.dart';
import 'data/services/analytics_service.dart';
import 'providers/store_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = await StorageService.init();

  // Initialize Analytics
  await AnalyticsService().initialize();

  runApp(KineticApp(storageService: storageService));
}

class KineticApp extends StatelessWidget {
  final StorageService storageService;

  const KineticApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        Provider<DioClient>(create: (_) => DioClient()),
        ProxyProvider<DioClient, ApiService>(
          update: (_, dioClient, __) => ApiService(dioClient),
        ),
        ChangeNotifierProxyProvider2<ApiService, StorageService, StoreProvider>(
          create: (context) => StoreProvider(
            Provider.of<ApiService>(context, listen: false),
            storageService,
          ),
          update: (_, apiService, storageService, previous) =>
              StoreProvider(apiService, storageService),
        ),
        ChangeNotifierProxyProvider2<ApiService, StorageService, CartProvider>(
          create: (context) => CartProvider(
            Provider.of<ApiService>(context, listen: false),
            storageService,
          ),
          update: (_, apiService, storageService, previous) => CartProvider(
            apiService,
            storageService,
          )..init(), // attempt init on update if needed or handle internal check
        ),
        ChangeNotifierProvider<WishlistProvider>(
          create: (context) => WishlistProvider(storageService),
        ),
      ],
      child: MaterialApp.router(
        title: 'Digia E-Commerce',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary100,
          scaffoldBackgroundColor: AppColors.white100,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary100),
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
