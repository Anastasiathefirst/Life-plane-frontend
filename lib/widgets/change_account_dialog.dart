import 'dart:ui';
import 'package:flutter/material.dart';

class ChangeAccountDialog extends StatefulWidget {
  final Function(String newAccount) onSave;

  const ChangeAccountDialog({super.key, required this.onSave});

  @override
  State<ChangeAccountDialog> createState() => _ChangeAccountDialogState();
}

class _ChangeAccountDialogState extends State<ChangeAccountDialog> {
  final TextEditingController _accountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      behavior: HitTestBehavior.opaque,
      child: Dialog(
        alignment: Alignment.topCenter,
        insetPadding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40),
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () {}, // чтобы диалог не закрывался при тапе внутрь
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Сменить аккаунт',
                        style: TextStyle(
                          color: Color(0xFF003366),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField('Новый e-mail или телефон', _accountController),
                      const SizedBox(height: 20),
                      _buildSaveButton(),
                      const SizedBox(height: 20),
                      _buildGoogleButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Color(0xFF003366)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF003366)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF003366)),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF003366), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveManualAccount,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      child: const Text('Сохранить'),
    );
  }

  Widget _buildGoogleButton() {
    return OutlinedButton(
      onPressed: _changeWithGoogle,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF003366)),
      ),
      child: const Text(
        'Сменить через Google',
        style: TextStyle(color: Color(0xFF003366)),
      ),
    );
  }

  void _saveManualAccount() {
    final newAccount = _accountController.text.trim();
    if (newAccount.isNotEmpty) {
      widget.onSave(newAccount);
      Navigator.of(context).pop();
    }
  }

  void _changeWithGoogle() async {
    // Тут будет реальный логин через Google (пока заглушка)
    // В будущем сюда подключим GoogleSignIn
    final fakeGoogleAccount = 'google_user@example.com';
    widget.onSave(fakeGoogleAccount);
    Navigator.of(context).pop();
  }
}
