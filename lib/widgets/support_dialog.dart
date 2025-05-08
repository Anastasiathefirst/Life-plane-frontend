import 'dart:ui';
import 'package:flutter/material.dart';

class SupportDialog extends StatefulWidget {
  final Function(String message) onSend;

  const SupportDialog({super.key, required this.onSend});

  @override
  State<SupportDialog> createState() => _SupportDialogState();
}

class _SupportDialogState extends State<SupportDialog> {
  final TextEditingController _messageController = TextEditingController();

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Поддержка',
                      style: TextStyle(
                        color: Color(0xFF003366),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildMessageField(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _send,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Отправить'),
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

  Widget _buildMessageField() {
    return TextField(
      controller: _messageController,
      maxLines: 5,
      style: const TextStyle(color: Color(0xFF003366)),
      decoration: InputDecoration(
        hintText: 'Опишите свою проблему или вопрос',
        hintStyle: const TextStyle(color: Color(0xFF003366)),
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

  void _send() {
    widget.onSend(_messageController.text);
    Navigator.of(context).pop();
  }
}
