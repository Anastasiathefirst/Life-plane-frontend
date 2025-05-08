import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:life_plane_go/screens/login_options_screen.dart';
import 'package:life_plane_go/screens/auth_screen.dart';
import 'package:life_plane_go/screens/main_screen.dart';
import 'package:life_plane_go/widgets/settings_dialog.dart';

class WelcomeScreen extends StatefulWidget {
  final void Function(Locale)? onLocaleChange;

  const WelcomeScreen({super.key, this.onLocaleChange});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/clouds_static.png',
            fit: BoxFit.cover,
          ),
          // === КНОПКА НАСТРОЕК ===
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.settings, color: Color(0xFF003366)),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.transparent,
                  builder: (context) => SettingsDialog(
                    userData: {
                      'method': 'guest',
                      'value': 'Guest',
                    },
                    onLanguageChanged: (locale) {
                      if (widget.onLocaleChange != null) {
                        widget.onLocaleChange!(locale);
                      }
                    },
                    onLogout: () {},
                  ),
                );
              },
            ),
          ),
          // === ЛОГО И НАДПИСЬ ===
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Life Plane',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                ),
              ),
            ),
          ),
          Positioned(
            top: 450,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Вы готовы лететь?',
                style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFF003366),
                ),
              ),
            ),
          ),
          // === КНОПКИ ВХОДА ===
          Positioned(
            bottom: 400,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GlassButton(
                  text: 'Войти',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginOptionsScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 20),
                _GlassButton(
                  text: 'Зарегистрироваться',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // === ПРОДОЛЖИТЬ БЕЗ ВХОДА ===
          Positioned(
            bottom: 320,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainScreen(guestMode: true),
                    ),
                  );
                },
                child: const Text(
                  'Продолжить без входа',
                  style: TextStyle(
                    color: Color(0xFF003366),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _GlassButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF003366),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
