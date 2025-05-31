import 'package:conextea/screens/calendar_page.dart';
import 'package:conextea/screens/message_page.dart';
import 'package:flutter/material.dart';
import 'achievements_page.dart';
import 'package:conextea/screens/profile_page.dart';
import 'package:conextea/screens/achievements_page.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ConexTEA',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4A90E2), // Azul similar al de la imagen
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFE8F4FD), // Fondo azul claro
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.85,
                children: [
            _buildOptionCard(
              context,
              'Mensaje',
              'assets/images/mensaje.png',
              const Color(0xFF4A90E2),
            ),
            _buildOptionCard(
              context,
              'Calendario',
              'assets/images/calendario.png',
              const Color(0xFF4A90E2),
            ),
            _buildOptionCard(
              context,
              'Logros',
              'assets/images/logros.png',
              const Color(0xFF4A90E2),
            ),
            _buildOptionCard(
              context,
              'Perfil',
              'assets/images/perfil.png',
              const Color(0xFF4A90E2),
            ),
            _buildOptionCard(
              context,
              'Ayuda',
              'assets/images/ayuda.png',
              const Color(0xFF4A90E2),
            ),
            _buildOptionCard(
              context,
              'Salir',
              'assets/images/salir.png',
              const Color(0xFF4A90E2),
            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, String title, String imagePath, Color color) {
    return GestureDetector(
      onTap: () {
        // Aquí puedes agregar la navegación específica para cada opción
        _handleOptionTap(context, title);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD1D1D1), // Fondo gris claro de las tarjetas
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                imagePath,
                width: 256,
                height: 256,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: const Color.fromARGB(255, 97, 97, 97),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleOptionTap(BuildContext context, String option) {
    // Manejo de las diferentes opciones
    switch (option) {
      case 'Mensaje':
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MessagePage()),
        ); // Navigator -> message_page.dart  
        break;
      case 'Calendario':
        Navigator.push(context, 
        MaterialPageRoute(builder: (context) => CalendarPage()),
        );//Navigator -> achievements_page.dart
        break;
      case 'Logros':
        Navigator.push(context, 
        MaterialPageRoute(builder: (context) => const AchievementsPage()),
        );//Navigator -> achievements_page.dart
        break;
      case 'Perfil':
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
        ); // Navigator -> profile_page.dart
        break;
      case 'Ayuda':
        _showSnackBar(context, 'Navegando a Ayuda');
        break;
      case 'Salir':
        _showExitDialog(context);
        break;
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Salir'),
          content: const Text('¿Estás seguro de que quieres salir?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salir'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                Navigator.of(context).pop(); // Regresa a la pantalla anterior
              },
            ),
          ],
        );
      },
    );
  }
}