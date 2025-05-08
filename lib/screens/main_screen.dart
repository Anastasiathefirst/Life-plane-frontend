import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:life_plane_go/widgets/diagnostics_panel.dart';
import 'package:life_plane_go/widgets/plane_wing_L.dart';
import 'package:life_plane_go/widgets/plane_wing_R.dart';
import 'package:life_plane_go/widgets/plane_cockpit.dart';
import 'package:life_plane_go/widgets/plane_tail.dart';
import 'package:life_plane_go/widgets/plane_cabin.dart';
import 'package:life_plane_go/screens/welcome_screen.dart';
import 'package:life_plane_go/widgets/plane_wing_L_SETTINGS.dart';
import 'package:life_plane_go/widgets/plane_wing_R_SETTINGS.dart';
import 'package:life_plane_go/widgets/plane_tail_settings.dart';
import 'package:life_plane_go/widgets/plane_cabin_settings.dart';
import 'package:life_plane_go/widgets/plane_cockpit_settings.dart';
import 'package:life_plane_go/widgets/settings_dialog.dart';
import 'package:life_plane_go/widgets/change_password_dialog.dart';
import 'package:life_plane_go/widgets/change_account_dialog.dart';
import 'package:life_plane_go/widgets/support_dialog.dart';

class MainScreen extends StatefulWidget {
  final bool guestMode;

  const MainScreen({super.key, this.guestMode = false});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late VideoPlayerController _controller;
  bool _showDiagnostics = false;
  final double _planeWidthFactor = 0.95;
  int _currentDiagnosticsPage = 0;

  Map<String, dynamic> wingDataL = {
    'name': 'Левое крыло',
    'frequency': 'Каждый день',
    'criticality': 2,
    'value': 5.0,
  };

  Map<String, dynamic> wingDataR = {
    'name': 'Правое крыло',
    'frequency': '3 дня в неделю',
    'criticality': 4,
    'value': 6.0,
  };

  Map<String, dynamic> tailData = {
    'name': 'Ценности',
    'frequency': 'раз в неделю',
    'criticality': 3,
    'value': 4.5,
  };

  Map<String, dynamic> cockpitData = {
    'name': 'Здоровье',
    'frequency': '2 раза в неделю',
    'criticality': 5,
    'value': 7.0,
  };

  Map<String, dynamic> cabinData = {
    'name': 'Семья',
    'frequency': '1 раз в неделю',
    'criticality': 6,
    'value': 6.5,
  };

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/clouds_gw.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        if (mounted) setState(() {});
      });
  }

  void _handleDiagnosticsPageChange(int page) {
    setState(() {
      _currentDiagnosticsPage = page;
    });
  }

  Map<String, dynamic> _getCurrentPartData() {
    switch (_currentDiagnosticsPage) {
      case 0:
        return wingDataL;
      case 1:
        return wingDataR;
      case 2:
        return cockpitData;
      case 3:
        return cabinData;
      case 4:
        return tailData;
      default:
        return wingDataL;
    }
  }

  void _openSettingsDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => SettingsDialog(
        userData: {'method': 'email', 'value': 'user@example.com'}, // заглушка
        onLanguageChanged: (lang) {
          // тут можно добавить смену языка
        },
        onLogout: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (route) => false,
          );
        },
      ),
    );
  }

  void _openChangePasswordDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => ChangePasswordDialog(
        onSave: (oldPassword, newPassword) {
          // здесь сохранить новый пароль
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
          // здесь сохранить новый аккаунт
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
          // здесь отправить сообщение в поддержку
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final planeWidth = MediaQuery.of(context).size.width * _planeWidthFactor;
    final isSelectedL = _showDiagnostics && _currentDiagnosticsPage == 0;
    final isSelectedR = _showDiagnostics && _currentDiagnosticsPage == 1;
    final isSelectedCockpit = _showDiagnostics && _currentDiagnosticsPage == 2;
    final isSelectedCabin = _showDiagnostics && _currentDiagnosticsPage == 3;
    final isSelectedTail = _showDiagnostics && _currentDiagnosticsPage == 4;
    final isCompositeMode = _showDiagnostics && _currentDiagnosticsPage == -1;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_controller.value.isInitialized)
            Transform.rotate(
              angle: -1.5708,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/plane_main.png',
                  width: planeWidth,
                  fit: BoxFit.contain,
                ),
                PlaneCockpit(
                  width: planeWidth,
                  isActive: isSelectedCockpit,
                  isSelected: isSelectedCockpit,
                  isCompositeMode: isCompositeMode,
                ),
                PlaneCabin(
                  width: planeWidth,
                  isActive: isSelectedCabin,
                  isSelected: isSelectedCabin,
                  isCompositeMode: isCompositeMode,
                ),
                PlaneTail(
                  width: planeWidth,
                  isActive: isSelectedTail,
                  isSelected: isSelectedTail,
                  isCompositeMode: isCompositeMode,
                ),
                PlaneWing_L(
                  width: planeWidth,
                  isActive: isSelectedL,
                  isSelected: isSelectedL,
                  isCompositeMode: isCompositeMode,
                ),
                PlaneWing_R(
                  width: planeWidth,
                  isActive: isSelectedR,
                  isSelected: isSelectedR,
                  isCompositeMode: isCompositeMode,
                ),
                _TapZonesOverlay(
                  planeWidth: planeWidth,
                  onTapLeftWing: () => _openSettings(
                    context,
                    PlaneWingL_SETTINGS(
                      initialData: wingDataL,
                      onSave: (data) => setState(() => wingDataL = {...wingDataL, ...data}),
                    ),
                  ),
                  onTapRightWing: () => _openSettings(
                    context,
                    PlaneWingR_SETTINGS(
                      initialData: wingDataR,
                      onSave: (data) => setState(() => wingDataR = {...wingDataR, ...data}),
                    ),
                  ),
                  onTapTail: () => _openSettings(
                    context,
                    PlaneTailSettings(
                      initialData: tailData,
                      onSave: (data) => setState(() => tailData = {...tailData, ...data}),
                    ),
                  ),
                  onTapCockpit: () => _openSettings(
                    context,
                    PlaneCockpitSettings(
                      initialData: cockpitData,
                      onSave: (data) => setState(() => cockpitData = {...cockpitData, ...data}),
                    ),
                  ),
                  onTapCabin: () => _openSettings(
                    context,
                    PlaneCabinSettings(
                      initialData: cabinData,
                      onSave: (data) => setState(() => cabinData = {...cabinData, ...data}),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: widget.guestMode
                ? const SizedBox()
                : IconButton(
              icon: const Icon(Icons.settings, color: Colors.grey, size: 28),
              onPressed: _openSettingsDialog,
            ),
          ),
          if (!_showDiagnostics)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: GlassButton(
                text: widget.guestMode ? 'Смотреть' : 'Диагностика',
                onTap: () => setState(() => _showDiagnostics = true),
              ),
            ),
          if (_showDiagnostics)
            GestureDetector(
              onTap: () => setState(() => _showDiagnostics = false),
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          if (_showDiagnostics)
            DiagnosticsPanel(
              onClose: () => setState(() => _showDiagnostics = false),
              wingData: _getCurrentPartData(),
              onPageChanged: _handleDiagnosticsPageChange,
            ),
          if (widget.guestMode)
            Positioned(
              top: 52,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                        (route) => false,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Text(
                    'Выйти',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openSettings(BuildContext context, Widget settingsWidget) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => settingsWidget,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _TapZonesOverlay extends StatelessWidget {
  final double planeWidth;
  final VoidCallback onTapLeftWing;
  final VoidCallback onTapRightWing;
  final VoidCallback onTapTail;
  final VoidCallback onTapCockpit;
  final VoidCallback onTapCabin;

  const _TapZonesOverlay({
    required this.planeWidth,
    required this.onTapLeftWing,
    required this.onTapRightWing,
    required this.onTapTail,
    required this.onTapCockpit,
    required this.onTapCabin,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: planeWidth,
      height: planeWidth,
      child: Stack(
        children: [
          _buildZone(0, 188, 236, 244, onTapLeftWing),
          _buildZone(330, 188, 236, 244, onTapRightWing),
          _buildZone(200, 430, 170, 134, onTapTail),
          _buildZone(220, 10, 130, 120, onTapCockpit),
          _buildZone(230, 150, 100, 260, onTapCabin),
        ],
      ),
    );
  }

  Widget _buildZone(
      double left,
      double top,
      double width,
      double height,
      VoidCallback onTap,
      ) {
    return Positioned(
      left: planeWidth * left / 570,
      top: planeWidth * top / 570,
      width: planeWidth * width / 570,
      height: planeWidth * height / 570,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(color: Colors.transparent),
      ),
    );
  }
}

class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const GlassButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
            ),
            alignment: Alignment.center,
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
