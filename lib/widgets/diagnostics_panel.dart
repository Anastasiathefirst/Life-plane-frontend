import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiagnosticsPanel extends StatefulWidget {
  final VoidCallback onClose;
  final Map<String, dynamic> wingData;
  final Function(int)? onPageChanged;

  const DiagnosticsPanel({
    super.key,
    required this.onClose,
    required this.wingData,
    this.onPageChanged,
  });

  @override
  State<DiagnosticsPanel> createState() => _DiagnosticsPanelState();
}

class _DiagnosticsPanelState extends State<DiagnosticsPanel>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(
    viewportFraction: 0.25,
    initialPage: 1000,
  );
  late List<String> spheres;
  late Map<String, double> sphereValues;
  late Map<String, String> frequency;
  late Map<String, int> criticality;
  late Map<String, DateTime> _lastUpdated;
  late Map<String, double> _degradationRates;
  int _currentIndex = 0;
  Timer? holdTimer;
  bool isHolding = false;
  bool showMaxText = false;
  bool _alertActive = false;
  bool compositeMode = false;
  bool _isSphereActive = true;
  bool _isAtMax = false;
  bool _isAtMin = false;
  late AnimationController _pulseController;
  late AnimationController _valueChangeController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _valueChangeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _initSphereData();
    _pageController.addListener(_pageListener);
    _startAlertAnimation();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadData();
    });
  }

  void _initSphereData() {
    spheres = [
      'Работа',
      'Саморазвитие',
      'Здоровье',
      'Семья',
      'Ценности',
    ];

    sphereValues = {
      spheres[0]: (widget.wingData['value'] as num).toDouble(),
      spheres[1]: 7.2,
      spheres[2]: 5.8,
      spheres[3]: 1.9,
      spheres[4]: 6.5,
    };

    frequency = {
      spheres[0]: widget.wingData['frequency'] ?? 'Каждый день',
      spheres[1]: '5 дней в неделю',
      spheres[2]: 'раз в 2 дня',
      spheres[3]: 'раз в неделю',
      spheres[4]: 'раз в месяц',
    };

    criticality = {
      spheres[0]: widget.wingData['criticality'] ?? 2,
      spheres[1]: 4,
      spheres[2]: 6,
      spheres[3]: 7,
      spheres[4]: 8,
    };

    _degradationRates = {
      for (var s in spheres) s: criticality[s]!.toDouble(),
    };

    _lastUpdated = {
      for (var s in spheres) s: DateTime.now(),
    };
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final sphere = spheres[_currentIndex];
    await prefs.setString('last_updated_$sphere', _lastUpdated[sphere]!.toIso8601String());
    await prefs.setDouble('current_value_$sphere', sphereValues[sphere]!);
    await prefs.setInt('criticality_$sphere', criticality[sphere]!);
    await prefs.setString('frequency_$sphere', frequency[sphere]!);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final sphere = spheres[_currentIndex];

    final savedDate = prefs.getString('last_updated_$sphere');
    if (savedDate != null) {
      _lastUpdated[sphere] = DateTime.parse(savedDate);
    }

    final savedValue = prefs.getDouble('current_value_$sphere');
    if (savedValue != null) {
      sphereValues[sphere] = savedValue;
    }

    final savedCriticality = prefs.getInt('criticality_$sphere');
    if (savedCriticality != null) {
      criticality[sphere] = savedCriticality;
      _degradationRates[sphere] = savedCriticality.toDouble();
    }

    final savedFrequency = prefs.getString('frequency_$sphere');
    if (savedFrequency != null) {
      frequency[sphere] = savedFrequency;
    }

    setState(() {
      _isAtMax = sphereValues[sphere]! >= 10.0;
      _isAtMin = sphereValues[sphere]! <= 0.0;
    });
  }

  double _calculateCurrentValue(int index) {
    final sphere = spheres[index];
    final hoursPassed = DateTime.now().difference(_lastUpdated[sphere]!).inHours;
    final hourlyDegradation = _degradationRates[sphere]! / 24;
    return max(
      sphereValues[sphere]! - (hourlyDegradation * hoursPassed),
      0.0,
    );
  }

  Color _getValueColor(double value) {
    if (value >= 7.1) return Colors.green;
    if (value >= 5.1) return Colors.orange;
    if (value >= 2.0) return Colors.red[800]!;
    return Colors.red[900]!;
  }

  void _pageListener() {
    final newPage = _pageController.page?.round() ?? 0;
    final newIndex = newPage % spheres.length;
    if (newIndex != _currentIndex) {
      setState(() {
        _currentIndex = newIndex;
        compositeMode = false;
        _isSphereActive = true;
      });
      widget.onPageChanged?.call(_currentIndex);
      _loadData();
    }
  }

  void _startAlertAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _alertActive = !_alertActive;
      });
      _startAlertAnimation();
    });
  }

  Future<void> _adjustValue(bool increase) async {
    final key = spheres[_currentIndex];
    final double newValue = (sphereValues[key]! + (increase ? 0.1 : -0.1)).clamp(0.0, 10.0);

    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: 20);
    }

    _valueChangeController.forward(from: 0);

    setState(() {
      sphereValues[key] = newValue;
      _lastUpdated[key] = DateTime.now();
      _isAtMax = newValue >= 10.0;
      _isAtMin = newValue <= 0.0;
    });

    if (_isAtMax || _isAtMin) {
      _pulseController.forward(from: 0);
      if (await Vibration.hasVibrator() ?? false) {
        await Vibration.vibrate(duration: 100);
      }
    }

    await _saveData();
  }

  Future<void> _startHolding(bool increase) async {
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: 50);
    }

    setState(() => isHolding = true);

    holdTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      await _adjustValue(increase);
    });
  }

  void _stopHolding() {
    setState(() => isHolding = false);
    holdTimer?.cancel();
  }

  Widget _buildControlButton({required bool increase}) {
    return GestureDetector(
      onTap: () async => await _adjustValue(increase),
      onLongPress: () async => await _startHolding(increase),
      onLongPressUp: _stopHolding,
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.9).animate(
          CurvedAnimation(
            parent: _pulseController,
            curve: Curves.easeOut,
          ),
        ),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: (increase && _isAtMax) || (!increase && _isAtMin)
                  ? Colors.red
                  : Colors.white,
              width: 2,
            ),
          ),
          child: Icon(
            increase ? Icons.add : Icons.remove,
            color: (increase && _isAtMax) || (!increase && _isAtMin)
                ? Colors.red
                : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSphere(int index, bool isActive) {
    final sphereIndex = index % spheres.length;
    final value = _calculateCurrentValue(sphereIndex);
    final hasAlert = value < 5.1;
    final bool isSelected = sphereIndex == _currentIndex && _isSphereActive;

    return GestureDetector(
      onTap: () {
        if (sphereIndex == _currentIndex) {
          setState(() {
            _isSphereActive = !_isSphereActive;
            compositeMode = !_isSphereActive;
          });
          widget.onPageChanged?.call(_isSphereActive ? _currentIndex : -1);
        } else {
          setState(() {
            _currentIndex = sphereIndex;
            _isSphereActive = true;
            compositeMode = false;
          });
          _animateToSphere(sphereIndex);
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSelected ? 115 : 85,
            height: isSelected ? 115 : 85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(isSelected ? 0.12 : 0.05),
              border: Border.all(
                color: Colors.white.withOpacity(isSelected ? 0.4 : 0.2),
                width: isSelected ? 2.5 : 1.5,
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
                  : [],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  spheres[sphereIndex].replaceAll(' ', '\n'),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: isSelected ? 19 : 15,
                    color: const Color(0xFF003366),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          if (hasAlert && !compositeMode)
            Positioned(
              top: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _alertActive ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orangeAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.7),
                        blurRadius: 4,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSpheresCarousel() {
    return SizedBox(
      height: 145,
      child: PageView.builder(
        controller: _pageController,
        padEnds: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return _buildSphere(index, index % spheres.length == _currentIndex);
        },
      ),
    );
  }

  Widget _buildIndividualMode() {
    final selectedSphere = spheres[_currentIndex];
    final value = _calculateCurrentValue(_currentIndex);
    final freq = frequency[selectedSphere]!;
    final crit = criticality[selectedSphere]!;
    final valueColor = _getValueColor(value);

    return Column(
      children: [
        const SizedBox(height: 8),
        _buildSpheresCarousel(),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: Text(
                        value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2),
                        key: ValueKey(value),
                        style: TextStyle(
                          color: valueColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildControlButton(increase: false),
                    const SizedBox(width: 20),
                    _buildControlButton(increase: true),
                  ],
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Необходимая\nчастота обновления:\n$freq',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Критичность:\n$crit',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Обновлено: ${_lastUpdated[selectedSphere]!.toString().substring(0, 16)}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompositeMode() {
    return Column(
      children: [
        const SizedBox(height: 8),
        _buildSpheresCarousel(),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Общая диагностика состояния',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: spheres.map((sphere) {
                      final value = _calculateCurrentValue(spheres.indexOf(sphere));
                      final freq = frequency[sphere]!;
                      final crit = criticality[sphere]!;
                      final valueColor = _getValueColor(value);
                      final textColor = valueColor.withOpacity(0.9);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sphere,
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Частота: $freq",
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "Критичность: $crit",
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "Текущее значение: ${value.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: valueColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Обновлено: ${_lastUpdated[sphere]!.toString().substring(0, 16)}",
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _animateToSphere(int targetIndex) {
    final currentPage = _pageController.page?.round() ?? 0;
    final currentIndex = currentPage % spheres.length;
    var diff = targetIndex - currentIndex;

    if (diff.abs() > spheres.length / 2) {
      diff += (diff > 0) ? -spheres.length : spheres.length;
    }

    _pageController.animateToPage(
      currentPage + diff,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: compositeMode ? _buildCompositeMode() : _buildIndividualMode(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _valueChangeController.dispose();
    _pageController.removeListener(_pageListener);
    holdTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}