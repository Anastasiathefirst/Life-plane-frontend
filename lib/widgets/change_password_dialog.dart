import 'dart:ui';
import 'package:flutter/material.dart';

class ChangePasswordDialog extends StatefulWidget {
  final Function(String oldPassword, String newPassword) onSave;

  const ChangePasswordDialog({super.key, required this.onSave});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
          onTap: () {}, // Чтобы не закрывался при нажатии внутри
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Сменить пароль',
                      style: TextStyle(
                        color: Color(0xFF003366),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField('Старый пароль', _oldPasswordController, obscure: true),
                    const SizedBox(height: 16),
                    _buildTextField('Новый пароль', _newPasswordController, obscure: true),
                    const SizedBox(height: 16),
                    _buildTextField('Подтвердить новый пароль', _confirmPasswordController, obscure: true),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Сохранить'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
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

  void _save() {
    if (_newPasswordController.text == _confirmPasswordController.text) {
      widget.onSave(_oldPasswordController.text, _newPasswordController.text);
      Navigator.of(context).pop();
    } else {
      // Можешь тут добавить ошибку в будущем
    }
  }
}
