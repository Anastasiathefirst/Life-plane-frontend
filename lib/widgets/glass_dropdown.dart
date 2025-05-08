import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';

class GlassDropdown extends StatefulWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const GlassDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  State<GlassDropdown> createState() => _GlassDropdownState();
}

class _GlassDropdownState extends State<GlassDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showOverlay() {
    _overlayEntry = _buildOverlayEntry();
    // 👇 Важно: теперь добавляем оверлей в rootOverlay, а не в локальный контекст
    Overlay.of(context, rootOverlay: true)?.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _buildOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final spaceBelow = screenHeight - offset.dy - size.height;
    final spaceAbove = offset.dy;
    final dropdownHeight = min(250.0, widget.options.length * 48.0 + 16);
    final showBelow = spaceBelow > dropdownHeight || spaceBelow > spaceAbove;
    final top = showBelow
        ? offset.dy + size.height + 5
        : offset.dy - dropdownHeight - 5;
    final dropdownWidth = size.width - 0.99;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: dropdownWidth,
        left: offset.dx,
        top: top,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: showBelow
              ? Offset(0, size.height - 73)
              : Offset(0, -dropdownHeight + 73),
          showWhenUnlinked: false,
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: dropdownHeight,
                  ),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shrinkWrap: true,
                    children: widget.options.map((option) {
                      return ListTile(
                        title: Text(
                          option,
                          style: const TextStyle(color: Color(0xFF003366)),
                        ),
                        onTap: () {
                          widget.onChanged(option);
                          _hideOverlay();
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 4),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Color(0xFF003366),
              fontSize: 14,
            ),
          ),
        ),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: () {
              if (_overlayEntry == null) {
                _showOverlay();
              } else {
                _hideOverlay();
              }
            },
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF003366)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.value,
                    style: const TextStyle(color: Color(0xFF003366)),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Color(0xFF003366)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }
}
