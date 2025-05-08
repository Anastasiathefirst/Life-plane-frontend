import 'dart:ui';
import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'package:life_plane_go/services/storage_service.dart';

class EmailLoginVerificationScreen extends StatefulWidget {
  const EmailLoginVerificationScreen({super.key});

  @override
  State<EmailLoginVerificationScreen> createState() => _EmailLoginVerificationScreenState();
}

class _EmailLoginVerificationScreenState extends State<EmailLoginVerificationScreen> {
  @override
  void initState() {
    super.initState();

    // Имитация успешного входа
    Future.delayed(const Duration(seconds: 4), () async {
      final storage = StorageService();
      await storage.setIsLoggedIn(true);
      // Тут можно: await storage.setString('userEmail', email);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/clouds_static.png', fit: BoxFit.cover),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Входим по Email...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003366),
                  ),
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF003366)),
                ),
                const SizedBox(height: 40),
                _GlassButton(
                  text: 'Назад',
                  onTap: () => Navigator.pop(context),
                ),
              ],
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
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
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
