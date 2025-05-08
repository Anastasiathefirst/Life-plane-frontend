import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:life_plane_go/services/storage_service.dart';

class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key});

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _confirmationSent = false;

  Future<void> _sendConfirmation() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final signupUrl = Uri.parse('https://life-plane-backend-production.up.railway.app/api/v1/auth/signup');
    final emailUrl = Uri.parse('https://life-plane-backend-production.up.railway.app/api/v1/auth/send-verification-email');

    final signupResponse = await http.post(
      signupUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "firstName": "User",
        "lastName": "Anonymous",
        "userName": email.split('@').first
      }),
    );

    if (signupResponse.statusCode == 200 || signupResponse.statusCode == 409) {
      final accessToken = jsonDecode(signupResponse.body)['data']?['tokens']?['accessToken']?['token'];
      if (accessToken != null) {
        final storage = StorageService();
        await storage.setUserEmail(email);
        await storage.setString('accessToken', accessToken);

        final emailResponse = await http.post(
          emailUrl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          },
        );

        if (emailResponse.statusCode == 200) {
          setState(() {
            _confirmationSent = true;
          });
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  InputDecoration _inputStyle(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white.withOpacity(0.85),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  );

  Widget _glassButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF003366),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/clouds_static.png', fit: BoxFit.cover),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Введите ваш Email',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputStyle('example@domain.com'),
                  ),
                  const SizedBox(height: 24),
                  if (_isLoading)
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF003366)),
                    )
                  else if (_confirmationSent)
                    const Text(
                      'Письмо отправлено!\nПроверьте почту и перейдите по ссылке.\nНе переходите, если это были не вы.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF003366), fontSize: 16),
                    )
                  else
                    _glassButton('Отправить подтверждение', _sendConfirmation),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Назад',
                      style: TextStyle(color: Color(0xFF003366)),
                    ),
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
