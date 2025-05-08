import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_plane_go/widgets/glass_dropdown.dart';

class PlaneCockpitSettings extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSave;

  const PlaneCockpitSettings({
    super.key,
    required this.initialData,
    required this.onSave,
  });

  @override
  State<PlaneCockpitSettings> createState() => _PlaneCockpitSettingsState();
}

class _PlaneCockpitSettingsState extends State<PlaneCockpitSettings> {
  late TextEditingController _nameController;
  late TextEditingController _criticalityController;
  late String _frequency;

  final List<String> _frequencyOptions = [
    'Каждый день',
    '6 дней в неделю',
    '5 дней в неделю',
    '4 дня в неделю',
    '3 дня в неделю',
    '2 дня в неделю',
    '1 день в неделю',
    'Два раза в месяц',
    'Один раз в месяц',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData['name']);
    _criticalityController = TextEditingController(
      text: widget.initialData['criticality'].toString(),
    );
    _frequency = widget.initialData['frequency'];
  }

  void _saveData() {
    widget.onSave({
      'name': _nameController.text,
      'frequency': _frequency,
      'criticality': int.tryParse(_criticalityController.text) ?? 2,
    });
  }

  @override
  void dispose() {
    _saveData();
    _nameController.dispose();
    _criticalityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDialog(context, 'Здоровье');
  }

  Widget _buildDialog(BuildContext context, String title) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      behavior: HitTestBehavior.opaque,
      child: Dialog(
        alignment: Alignment.topCenter,
        insetPadding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 40, // Сдвиг на 40 пикселей вниз
        ),
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF003366),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField('Название', _nameController),
                      const SizedBox(height: 16),
                      _buildFrequencyPicker(),
                      const SizedBox(height: 16),
                      _buildNumberField('Критичность (1-10)', _criticalityController),
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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

  Widget _buildNumberField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(color: Color(0xFF003366)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF003366)),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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

  Widget _buildFrequencyPicker() {
    return GlassDropdown(
      label: 'Частота обновления',
      value: _frequency,
      options: _frequencyOptions,
      onChanged: (newValue) {
        setState(() {
          _frequency = newValue;
        });
      },
    );
  }
}
