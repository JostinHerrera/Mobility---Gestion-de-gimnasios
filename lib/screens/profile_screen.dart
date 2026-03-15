import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main_navigation.dart';
import 'trainers_list_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _publicProfile = true;

  @override
  Widget build(BuildContext context) {
    const kPrimaryIndigo = Color(0xFF4F46E5);
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      Theme.of(context).textTheme,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF4F46E5)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
       
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                // ...existing code...
                const Divider(),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation(initialIndex: 0)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.fitness_center),
                title: const Text('Rutinas'),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation(initialIndex: 1)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('Chat'),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation(initialIndex: 2)));
                },
              ),
             
              const Spacer(),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(6)),
                  child: const Icon(Icons.exit_to_app, color: Color(0xFFDC2626)),
                ),
                title: Text('Cerrar Sesión', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: const Color(0xFFDC2626))),
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Cerrar sesión'),
                      content: const Text('¿Estás seguro que deseas cerrar sesión?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
                        TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Cerrar sesión')),
                      ],
                    ),
                  );
                  if (!mounted) return;
                  if (confirmed == true) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mi Perfil',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const TrainersListScreen(),
                      ),
                    ),
                    icon: const Icon(Icons.group, size: 18, color: Color.fromARGB(255, 255, 255, 255)),
                    label: Text('Entrenadores', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, color: const Color.fromARGB(255, 255, 255, 255))),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F46E5), foregroundColor: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Header card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: const Color(0xFFF3F4FF),
                          child: Icon(
                            Icons.person,
                            size: 36,
                            color: kPrimaryIndigo,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: kPrimaryIndigo,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.flash_on,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Alex Johnson',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'MIEMBRO PREMIUM',
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),

                    const Divider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _smallInfo('Nivel', 'Intermedio', kPrimaryIndigo),
                        _smallInfo('Racha', '12 Días', Colors.green),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Public profile toggle
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    'Perfil Público',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: const Text('Visibilidad de rutinas'),
                  value: _publicProfile,
                  activeThumbColor: kPrimaryIndigo,
                  onChanged: (v) => setState(() => _publicProfile = v),
                ),
              ),

              const SizedBox(height: 18),

              // Datos Físicos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Datos Físicos',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _openEditPhysical(context),
                    child: const Text('Editar'),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _PhysCard(
                          icon: Icons.monitor_weight,
                          label: 'Peso',
                          value: '75 kg',
                        ),
                        _PhysCard(
                          icon: Icons.height,
                          label: 'Altura',
                          value: '178 cm',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _PhysCard(
                          icon: Icons.cake,
                          label: 'Edad',
                          value: '28 años',
                        ),
                        _PhysCard(
                          icon: Icons.flag,
                          label: 'Objetivo',
                          value: 'Ganancia muscular',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // List of settings
              _buildListTile(
                context,
                icon: Icons.payment,
                title: 'Métodos de Pago',
                subtitle: 'Gestiona tus tarjetas',
                onTap: () => _openPlaceholder(context, 'Métodos de Pago'),
              ),
              _buildListTile(
                context,
                icon: Icons.notifications,
                title: 'Notificaciones',
                subtitle: 'Configura tus avisos',
                onTap: () => _openPlaceholder(context, 'Notificaciones'),
              ),
              _buildListTile(
                context,
                icon: Icons.shield,
                title: 'Seguridad',
                subtitle: 'Contraseña y acceso',
                onTap: () => _openPlaceholder(context, 'Seguridad'),
              ),
              _buildListTile(
                context,
                icon: Icons.help_outline,
                title: 'Soporte',
                subtitle: 'Centro de ayuda',
                onTap: () => _openPlaceholder(context, 'Soporte'),
              ),

              const SizedBox(height: 18),

              // Cerrar sesión (ListTile rojo)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Cerrar sesión'),
                        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
                          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Cerrar sesión')),
                        ],
                      ),
                    );
                    if (!mounted) return;
                    if (confirmed == true) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    }
                  },
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.exit_to_app, color: Color(0xFFDC2626)),
                  ),
                  title: Text('Cerrar Sesión', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: const Color(0xFFDC2626))),
                ),
              ),

              // Upgrade card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF4F46E5)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.flash_on, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Upgrade a PRO',
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Desbloquea rutinas exclusivas y seguimiento 24/7 con IA.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () =>
                            _openPlaceholder(context, 'Planes PRO'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: kPrimaryIndigo,
                        ),
                        child: const Text('Ver Planes'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _openEditPhysical(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const EditPhysicalDataScreen()));
  }

  void _openPlaceholder(BuildContext context, String title) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => PlaceholderScreen(title: title)));
  }
}

Widget _smallInfo(String title, String value, Color color) {
  return Column(
    children: [
      Text(
        title,
        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey),
      ),
      const SizedBox(height: 6),
      Text(
        value,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    ],
  );
}

class _PhysCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _PhysCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF6B7280)),
            const SizedBox(height: 8),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildListTile(
  BuildContext context, {
  required IconData icon,
  required String title,
  String? subtitle,
  VoidCallback? onTap,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 6),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF4F46E5)),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
    ),
  );
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Pantalla: $title')),
    );
  }
}

class EditPhysicalDataScreen extends StatelessWidget {
  const EditPhysicalDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Datos Físicos')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: Text('Formulario de edición (placeholder)')),
      ),
    );
  }
}
