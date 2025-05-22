import 'package:flutter/material.dart';

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
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 1.1,
          children: [
            _buildOptionCard(
              context,
              'Mensaje',
              Icons.tablet_android,
              const Color(0xFF4A90E2),
            ),
            _buildOptionCard(
              context,
              'Calendario',
              Icons.calendar_today,
              const Color(0xFF4A90E2),
            ),
            _buildOptionCard(
              context,
              'Logros',
              Icons.emoji_events,
              const Color(0xFF4A90E2),
            ),
            _buildOptionCard(
              context,
              'Perfil',
              Icons.person,
              const Color(0xFF4A90E2),
            ),
            _buildOptionCard(
              context,
              'Ayuda',
              Icons.help_outline,
              const Color(0xFF4A90E2),
            ),
            _buildOptionCard(
              context,
              'Salir',
              Icons.exit_to_app,
              const Color(0xFF4A90E2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, String title, IconData icon, Color color) {
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
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 48,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
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
        _showSnackBar(context, 'Navegando a Mensajes');
        break;
      case 'Calendario':
        _showSnackBar(context, 'Navegando a Calendario');
        break;
      case 'Logros':
        _showSnackBar(context, 'Navegando a Logros');
        break;
      case 'Perfil':
        _showSnackBar(context, 'Navegando a Perfil');
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