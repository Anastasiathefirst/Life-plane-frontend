import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PlaneCabinSettings extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSave;

  const PlaneCabinSettings({
    super.key,
    required this.initialData,
    required this.onSave,
  });

  @override
  State<PlaneCabinSettings> createState() => _PlaneCabinSettingsState();
}

class _PlaneCabinSettingsState extends State<PlaneCabinSettings> {
  final List<_Passenger> _passengers = List.generate(10, (_) => _Passenger.empty());
  final ImagePicker _picker = ImagePicker();

  void _addPassengerAt(int index) async {
    final nameController = TextEditingController();
    File? imageFile;

    await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => Dialog(
        backgroundColor: const Color(0xEE001F3F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StatefulBuilder(
            builder: (context, setInnerState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Добавить пассажира',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final picked = await _picker.pickImage(source: ImageSource.gallery);
                    if (picked != null) {
                      setInnerState(() {
                        imageFile = File(picked.path);
                      });
                    }
                  },
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                      image: imageFile != null
                          ? DecorationImage(
                        image: FileImage(imageFile!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: imageFile == null
                        ? const Icon(Icons.person, color: Colors.white, size: 60)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Имя',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (nameController.text.isNotEmpty) {
                          setState(() {
                            _passengers[index] = _Passenger(
                              name: nameController.text,
                              imagePath: imageFile?.path,
                            );
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Добавить', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editPassenger(int index) async {
    final passenger = _passengers[index];
    final nameController = TextEditingController(text: passenger.name);
    File? imageFile = passenger.imagePath != null ? File(passenger.imagePath!) : null;

    await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => Dialog(
        backgroundColor: const Color(0xEE001F3F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StatefulBuilder(
            builder: (context, setInnerState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Информация о пассажире',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final picked = await _picker.pickImage(source: ImageSource.gallery);
                    if (picked != null) {
                      setInnerState(() {
                        imageFile = File(picked.path);
                      });
                    }
                  },
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                      image: imageFile != null
                          ? DecorationImage(
                        image: FileImage(imageFile!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: imageFile == null
                        ? const Icon(Icons.person, color: Colors.white, size: 60)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Имя',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() => _passengers[index] = _Passenger.empty());
                        Navigator.pop(context);
                      },
                      child: const Text('Удалить', style: TextStyle(color: Colors.redAccent)),
                    ),
                    TextButton(
                      onPressed: () {
                        if (nameController.text.isNotEmpty) {
                          setState(() {
                            _passengers[index] = _Passenger(
                              name: nameController.text,
                              imagePath: imageFile?.path,
                            );
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Сохранить', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.onSave({
      'passengers': _passengers
          .map((p) => {'name': p.name, 'imagePath': p.imagePath})
          .toList(),
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 60),
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
            ),
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Салон самолёта',
                  style: TextStyle(
                    color: Color(0xFF003366),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 40,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final passenger = _passengers[index];

                      return GestureDetector(
                        onTap: () {
                          if (passenger.isEmpty) {
                            _addPassengerAt(index);
                          } else {
                            _editPassenger(index);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: passenger.isEmpty
                              ? const Center(
                            child: Icon(Icons.add, size: 40, color: Color(0xFF003366)),
                          )
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(8),
                                  image: passenger.imagePath != null
                                      ? DecorationImage(
                                    image: FileImage(File(passenger.imagePath!)),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                child: passenger.imagePath == null
                                    ? const Icon(Icons.person, color: Color(0xFF003366))
                                    : null,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                passenger.name,
                                style: const TextStyle(
                                  color: Color(0xFF003366),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Passenger {
  final String name;
  final String? imagePath;

  const _Passenger({required this.name, this.imagePath});

  bool get isEmpty => name.isEmpty && imagePath == null;

  factory _Passenger.empty() => const _Passenger(name: '', imagePath: null);
}
