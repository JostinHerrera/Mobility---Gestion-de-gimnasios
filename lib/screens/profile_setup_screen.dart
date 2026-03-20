import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main_navigation.dart';
import 'login_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

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

  final List<String> genderOptions = ['Masculino', 'Femenino'];
  final List<String> bodyTypeOptions = ['Ectomorfo', 'Mesomorfo', 'Endomorfo'];
  final List<String> objectiveOptions = ['Ganancia muscular', 'Pérdida de peso', 'Mantenimiento'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != birthDate) {
      setState(() {
        birthDate = picked;
      });
      _updateCanSave();
    }
  }

  void _updateCanSave() {
    setState(() {
      final w = double.tryParse(weightController.text.trim());
      final h = double.tryParse(heightController.text.trim());
      _canSave = (w != null && w > 0) && (h != null && h > 0);
    });
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    weightController.addListener(_updateCanSave);
    heightController.addListener(_updateCanSave);
    _updateCanSave();
  }

  @override
  Widget build(BuildContext context) {
    const kPrimaryIndigo = Color(0xFF4F46E5);
    const kSlate500 = Color(0xFF64748B);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completa tu perfil'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: kPrimaryIndigo,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Datos Físicos', style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),

            // Peso y Altura en contenedores lado a lado
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(right: 6, bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE6EEF8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Peso (kg)', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: kSlate500)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(left: 6, bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE6EEF8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Altura (cm)', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: kSlate500)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: heightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Fecha de nacimiento en contenedor
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE6EEF8)),
              ),
              child: Row(
                children: [
                  Expanded(child: Text('Fecha de nacimiento: ${birthDate.toLocal().toString().split(' ')[0]}', style: TextStyle(color: kSlate500))),
                  TextButton(onPressed: () => _selectDate(context), child: const Text('Seleccionar')),
                ],
              ),
            ),

            // Contenedor solo para Sexo
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE6EEF8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sexo', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: gender,
                    items: genderOptions.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (v) => setState(() { gender = v ?? gender; _updateCanSave(); }),
                    decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                  ),
                ],
              ),
            ),

            // Contenedor para Tipo de cuerpo
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE6EEF8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tipo de cuerpo', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: bodyType,
                    items: bodyTypeOptions.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                    onChanged: (v) => setState(() { bodyType = v ?? bodyType; _updateCanSave(); }),
                    decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                  ),
                ],
              ),
            ),

            // Contenedor sólo para Objetivo
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE6EEF8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Objetivo', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: objective,
                    items: objectiveOptions.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
                    onChanged: (v) => setState(() { objective = v ?? objective; _updateCanSave(); }),
                    decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: SwitchListTile(
                title: const Text('Perfil público'),
                subtitle: const Text('Permite que otros vean tu perfil'),
                value: _publicProfile,
                onChanged: (v) => setState(() { _publicProfile = v; _updateCanSave(); }),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _canSave
                    ? () {
                        // Simular guardado local / backend
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Perfil guardado')),
                        );
                        // Al completar, navegar a la pantalla de Inicio de Sesión
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryIndigo,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: kPrimaryIndigo.withOpacity(0.6),
                  disabledForegroundColor: Colors.white70,
                ),
                child: Text(_canSave ? 'Completar' : 'Completa peso y altura', style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
