import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

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
        backgroundColor: const Color(0xFF4A90E2),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFE8F4FD),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            _buildMenuButton(
              context,
              title: 'Mensaje',
              imagePath: 'assets/icons/mensaje.png',
            ),
            _buildMenuButton(
              context,
              title: 'Calendario',
              imagePath: 'assets/icons/calendario.png',
            ),
            _buildMenuButton(
              context,
              title: 'Logros',
              imagePath: 'assets/icons/logros.png',
            ),
            _buildMenuButton(
              context,
              title: 'Perfil',
              imagePath: 'assets/icons/perfil.png',
            ),
            _buildMenuButton(
              context,
              title: 'Ayuda',
              imagePath: 'assets/icons/ayuda.png',
            ),
            _buildMenuButton(
              context,
              title: 'Salir',
              imagePath: 'assets/icons/salir.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required String title, required String imagePath}) {
    return GestureDetector(
      onTap: () => _handleMenuAction(context, title),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD1D1D1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _handleMenuAction(context, title),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String title) {
    switch (title) {
      case 'Mensaje':
        _showSnackBar(context, 'Navegando a Mensaje');
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
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Salir'),
        content: const Text('¿Estás seguro de que quieres salir?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Salir'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
