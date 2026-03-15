import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'trainer_screen.dart';

class TrainersListScreen extends StatelessWidget {
  const TrainersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trainers = _sampleTrainers();
    return Scaffold(
      appBar: AppBar(title: const Text('Entrenadores')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: trainers.length,
        itemBuilder: (context, index) {
          final t = trainers[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TrainerScreen(trainer: t))),
              leading: Container(width: 56, height: 56, decoration: BoxDecoration(color: const Color(0xFFF3F4FF), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.person, color: Color(0xFF4F46E5))),
              title: Text(t.name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
              subtitle: Text(t.title),
              trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(t.rating.toString(), style: const TextStyle(fontWeight: FontWeight.w700)), const Icon(Icons.chevron_right)]),
            ),
          );
        },
      ),
    );
  }

  List<Trainer> _sampleTrainers() {
    return const [
      Trainer(name: 'Cristian López', title: 'Entrenador personal · Fuerza', rating: 4.9, years: 8, certifications: 4, clients: '120+', languages: 'ES, EN', about: 'Especialista en fuerza y acondicionamiento.'),
      Trainer(name: 'María Gómez', title: 'Nutrición deportiva', rating: 4.8, years: 6, certifications: 3, clients: '90+', languages: 'ES', about: 'Entrenadora con enfoque en nutrición y composición corporal.'),
      Trainer(name: 'Alex Torres', title: 'Acondicionamiento y movilidad', rating: 4.7, years: 5, certifications: 2, clients: '60+', languages: 'ES, EN', about: 'Programas de movilidad y prevención de lesiones.'),
    ];
  }
}
