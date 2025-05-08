import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:life_plane_go/widgets/glass_dropdown.dart';
import 'package:life_plane_go/widgets/change_password_dialog.dart';
import 'package:life_plane_go/widgets/change_account_dialog.dart';
import 'package:life_plane_go/widgets/support_dialog.dart';

class SettingsDialog extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function(Locale) onLanguageChanged;
  final Function() onLogout;

  const SettingsDialog({
    super.key,
    required this.userData,
    required this.onLanguageChanged,
    required this.onLogout,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  String _selectedLanguage = 'Русский';

  final List<String> _languages = [
    'Русский',
    'English',
    'Español',
    'Italiano',
    'Deutsch',
    'Français',
    '中文',
    'हिंदी',
    'العربية',
  ];

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
          onTap: () {},
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
                        'Настройки',
                        style: TextStyle(
                          color: Color(0xFF003366),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildLanguageSelector(),
                      const SizedBox(height: 16),
                      _buildUserInfo(),
                      const SizedBox(height: 16),
                      _buildAction('Сменить пароль', _openChangePasswordDialog),
                      const SizedBox(height: 8),
                      _buildAction('Сменить аккаунт', _openChangeAccountDialog),
                      const SizedBox(height: 8),
                      _buildAction('Поддержка', _openSupportDialog),
                      const SizedBox(height: 8),
                      _buildLogoutButton(),
                      const SizedBox(height: 16),
                      const Text(
                        'Версия приложения: 1.0.0',
                        style: TextStyle(
                          color: Color(0xFF003366),
                          fontSize: 12,
                        ),
                      ),
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

  Widget _buildLanguageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Язык интерфейса',
          style: TextStyle(
            color: Color(0xFF003366),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        GlassDropdown(
          label: '',
          value: _selectedLanguage,
          options: _languages,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedLanguage = value;
              });
              widget.onLanguageChanged(_mapLanguageToLocale(value));
              Navigator.of(context).pop(); // 👈 Закрываем диалог после смены языка
            }
          },
        ),
      ],
    );
  }

  Locale _mapLanguageToLocale(String language) {
    switch (language) {
      case 'Русский':
        return const Locale('ru');
      case 'English':
        return const Locale('en');
      case 'Español':
        return const Locale('es');
      case 'Italiano':
        return const Locale('it');
      case 'Deutsch':
        return const Locale('de');
      case 'Français':
        return const Locale('fr');
      case '中文':
        return const Locale('zh');
      case 'हिंदी':
        return const Locale('hi');
      case 'العربية':
        return const Locale('ar');
      default:
        return const Locale('en');
    }
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Аккаунт',
          style: TextStyle(
            color: Color(0xFF003366),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Text(
            '${widget.userData['method'].toUpperCase()}: ${widget.userData['value']}',
            style: const TextStyle(color: Color(0xFF003366)),
          ),
        ),
      ],
    );
  }

  Widget _buildAction(String label, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF003366),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: widget.onLogout,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: const Text(
          'Выйти из аккаунта',
          style: TextStyle(
            color: Color(0xFF003366),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _openChangePasswordDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => ChangePasswordDialog(
        onSave: (oldPassword, newPassword) {
          // Здесь вставить реальную логику смены пароля
        },
      ),
    );
  }

  void _openChangeAccountDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => ChangeAccountDialog(
        onSave: (newAccount) {
          // Здесь вставить реальную логику смены аккаунта
        },
      ),
    );
  }

  void _openSupportDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => SupportDialog(
        onSend: (message) {
          // Здесь вставить реальную логику отправки сообщения
        },
      ),
    );
  }
}
