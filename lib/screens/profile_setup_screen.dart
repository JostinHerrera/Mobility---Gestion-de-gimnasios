import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../firebase_options.dart';
import '../main_navigation.dart';
import 'login_screen.dart';

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
    );

    if (picked != null) {
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
          children: [
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
              child: SwitchListTile(
                title: const Text('Perfil público'),
                value: _publicProfile,
                onChanged: (v) => setState(() => _publicProfile = v),
              ),
            ),

            const SizedBox(height: 20),

            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _canSave && !_isSaving ? _guardarPerfil : null,
                style: ElevatedButton.styleFrom(backgroundColor: kPrimary),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Completar'),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label, border: InputBorder.none),
      ),
    );
  }

  Widget _dateCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Fecha: ${birthDate.toLocal().toString().split(' ')[0]}',
            ),
          ),
          TextButton(
            onPressed: () => _selectDate(context),
            child: const Text('Seleccionar'),
          ),
        ],
      ),
    );
  }

  Widget _dropdownCard(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(labelText: label, border: InputBorder.none),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
