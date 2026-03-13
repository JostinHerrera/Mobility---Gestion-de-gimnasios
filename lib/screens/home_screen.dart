import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; // Importa tu dashboard anterior


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const DashboardScreen(),
    );
  }
}
