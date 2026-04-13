import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../firebase_options.dart';
import '../main_navigation.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String? initialName;
  final String? initialEmail;

  const ProfileSetupScreen({super.key, this.initialName, this.initialEmail});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  DateTime birthDate = DateTime(1996, 1, 1);
  String gender = 'Masculino';
  String bodyType = 'Ectomorfo';
  String objective = 'Ganancia muscular';
  bool _publicProfile = true;

  bool _canSave = false;
  bool _isSaving = false;
  String? _error;

  final List<String> genderOptions = ['Masculino', 'Femenino'];
  final List<String> bodyTypeOptions = ['Ectomorfo', 'Mesomorfo', 'Endomorfo'];
  final List<String> objectiveOptions = [
    'Ganancia muscular',
    'Pérdida de peso',
    'Mantenimiento',
  ];

  @override
  void initState() {
    super.initState();
    weightController.addListener(_updateCanSave);
    heightController.addListener(_updateCanSave);
    _updateCanSave();
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  void _updateCanSave() {
    final w = double.tryParse(weightController.text.trim());
    final h = double.tryParse(heightController.text.trim());

    setState(() {
      _canSave = (w != null && w > 0) && (h != null && h > 0);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      helpText: 'Selecciona tu fecha de nacimiento',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      fieldHintText: 'DD/MM/YYYY',
      fieldLabelText: 'Fecha de nacimiento',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4F46E5),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != birthDate) {
      setState(() => birthDate = picked);
    }
  }

  Future<void> _guardarPerfil() async {
    setState(() {
      _isSaving = true;
      _error = null;
    });

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        _error = "No hay usuario autenticado";
        _isSaving = false;
      });
      return;
    }

    try {
      final idToken = await user.getIdToken();
      final projectId = DefaultFirebaseOptions.currentPlatform.projectId;

      final url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/profiles/${user.uid}',
      );

      final weightVal = double.tryParse(weightController.text.trim());
      final heightVal = double.tryParse(heightController.text.trim());

      final body = {
        'fields': {
          'id': {'stringValue': user.uid},
          'name': {'stringValue': widget.initialName ?? user.displayName ?? ''},
          'email': {'stringValue': widget.initialEmail ?? user.email ?? ''},
          'weight': {'doubleValue': weightVal ?? 0},
          'height': {'doubleValue': heightVal ?? 0},
          'birth_date': {'stringValue': birthDate.toIso8601String()},
          'gender': {'stringValue': gender},
          'body_type': {'stringValue': bodyType},
          'objective': {'stringValue': objective},
          'public_profile': {'booleanValue': _publicProfile},
        },
      };

      final resp = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil guardado correctamente')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      } else {
        setState(() {
          _error = 'Error: ${resp.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const kPrimary = Color(0xFF4F46E5);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completa tu perfil'),
        backgroundColor: Colors.white,
        foregroundColor: kPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Datos físicos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Agrega tu peso, altura y demás datos para personalizar tu perfil.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),

            _inputCard(label: 'Peso (kg)', controller: weightController),
            _inputCard(label: 'Altura (cm)', controller: heightController),

            _dateCard(),

            _dropdownCard(
              'Sexo',
              gender,
              genderOptions,
              (v) => setState(() => gender = v!),
            ),

            _dropdownCard(
              'Tipo de cuerpo',
              bodyType,
              bodyTypeOptions,
              (v) => setState(() => bodyType = v!),
            ),

            _dropdownCard(
              'Objetivo',
              objective,
              objectiveOptions,
              (v) => setState(() => objective = v!),
            ),

            const SizedBox(height: 12),

            Card(
              margin: const EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 1,
              child: SwitchListTile(
                title: const Text('Perfil público'),
                value: _publicProfile,
                onChanged: (v) => setState(() => _publicProfile = v),
              ),
            ),

            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),

            if (_error != null) const SizedBox(height: 10),

            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _canSave && !_isSaving ? _guardarPerfil : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2937),
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text('Completar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputCard({
    required String label,
    required TextEditingController controller,
  }) {
    IconData getIconForLabel(String label) {
      switch (label.toLowerCase()) {
        case 'peso (kg)':
          return Icons.monitor_weight;
        case 'altura (cm)':
          return Icons.height;
        default:
          return Icons.edit;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            prefixIcon: Icon(
              getIconForLabel(label),
              color: const Color(0xFF4F46E5),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: InkWell(
        onTap: () => _selectDate(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: Color(0xFF4F46E5),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fecha de nacimiento',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${birthDate.day.toString().padLeft(2, '0')}/${birthDate.month.toString().padLeft(2, '0')}/${birthDate.year}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownCard(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    IconData getIconForLabel(String label) {
      switch (label.toLowerCase()) {
        case 'sexo':
          return Icons.person;
        case 'tipo de cuerpo':
          return Icons.fitness_center;
        case 'objetivo':
          return Icons.flag;
        default:
          return Icons.arrow_drop_down;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: DropdownButtonFormField<String>(
          initialValue: value,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            prefixIcon: Icon(
              getIconForLabel(label),
              color: const Color(0xFF4F46E5),
              size: 20,
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
