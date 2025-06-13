import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pharma/provider/auth_provider.dart';
import 'package:pharma/provider/cart_provider.dart';
import 'package:pharma/provider/notificaciones_provider.dart';
import 'package:pharma/provider/payment_provider.dart';
import 'package:pharma/provider/provider.dart';
import 'package:pharma/provider/theme.dart';
import 'package:pharma/provider/wishlist_provider.dart';
import 'package:pharma/screens/home.dart';
import 'package:pharma/screens/listview_builder.dart';
import 'package:pharma/services/firebase_messaging_service.dart';
import 'package:pharma/services/notificaction.dart';
import 'package:pharma/splash_screen.dart';
import 'package:pharma/widget/theme_mode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('bannerShown');
  // Inicializar el servicio de notificaciones
  FirebaseMessagingService messagingService = FirebaseMessagingService();
  await messagingService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ContadorProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => NotificacionesProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(create: (context) => PaymentProvider()),
      ],
      child: MyApp(),
    ),
  );
  NotifHelper.initNotif();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      themeMode: themeProvider.themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: 'SplashScreenState',
      routes: {
        'ListViewBuilder': (context) => const ListViewBuilder(),
        'MyHomePage': (context) => const MyHomePage(),
        'SplashScreenState': (context) => SplashScreen(),
      },
    );
  }
}
