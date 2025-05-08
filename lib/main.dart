import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:life_plane_go/screens/main_screen.dart';
import 'package:life_plane_go/screens/welcome_screen.dart';
import 'package:life_plane_go/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService().init();
  runApp(const LifePlaneGoApp());
}

class LifePlaneGoApp extends StatefulWidget {
  const LifePlaneGoApp({super.key});

  @override
  State<LifePlaneGoApp> createState() => _LifePlaneGoAppState();
}

class _LifePlaneGoAppState extends State<LifePlaneGoApp> {
  Locale _locale = const Locale('en');
  bool _initialized = false;

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadStorage();
  }

  Future<void> _loadStorage() async {
    await StorageService().init();
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final isLoggedIn = StorageService().isLoggedIn;

    return MaterialApp(
      title: 'Life Plane Go',
      theme: ThemeData(primarySwatch: Colors.blue),
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
        Locale('es'),
        Locale('it'),
        Locale('de'),
        Locale('fr'),
        Locale('zh'),
        Locale('hi'),
        Locale('ar'),
      ],
      home: isLoggedIn
          ? const MainScreen()
          : WelcomeScreen(onLocaleChange: setLocale),
    );
  }
}
