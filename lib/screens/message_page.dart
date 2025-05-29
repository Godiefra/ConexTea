import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  String selectedCategory = 'Emociones';
  String selectedPictogram = '';
  List<String> selectedWords = [];

  // Datos para cada categoría
  final Map<String, List<Map<String, String>>> categoryData = {
    'Comida': [
      {'emoji': '🍎', 'label': 'Manzana'},
      {'emoji': '🍞', 'label': 'Pan'},
      {'emoji': '🥛', 'label': 'Leche'},
      {'emoji': '🍕', 'label': 'Pizza'},
    ],
    'Personas': [
      {'emoji': '👨', 'label': 'Papá'},
      {'emoji': '👩', 'label': 'Mamá'},
      {'emoji': '👶', 'label': 'Bebé'},
      {'emoji': '👵', 'label': 'Abuela'},
    ],
    'Lugares': [
      {'emoji': '🏠', 'label': 'Casa'},
      {'emoji': '🏫', 'label': 'Escuela'},
      {'emoji': '🏥', 'label': 'Hospital'},
      {'emoji': '🏪', 'label': 'Tienda'},
    ],
    'Acciones': [
      {'emoji': '🏃', 'label': 'Correr'},
      {'emoji': '😴', 'label': 'Dormir'},
      {'emoji': '🍽️', 'label': 'Comer'},
      {'emoji': '📖', 'label': 'Leer'},
    ],
    'Emociones': [
      {'emoji': '😊', 'label': 'Feliz'},
      {'emoji': '😔', 'label': 'Triste'},
      {'emoji': '😐', 'label': 'Neutro'},
      {'emoji': '😠', 'label': 'Enfadado'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4FC3F7),
        title: const Text(
          'ConexTEA - Sistema de Mensajería',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'BACK',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categorías
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categorías',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildCategoryButton('Comida', const Color(0xFFFFF59D), selectedCategory == 'Comida'),
                      const SizedBox(width: 8),
                      _buildCategoryButton('Personas', const Color(0xFFEF9A9A), selectedCategory == 'Personas'),
                      const SizedBox(width: 8),
                      _buildCategoryButton('Lugares', const Color(0xFFA5D6A7), selectedCategory == 'Lugares'),
                      const SizedBox(width: 8),
                      _buildCategoryButton('Acciones', const Color(0xFFB39DDB), selectedCategory == 'Acciones'),
                      const SizedBox(width: 8),
                      _buildCategoryButton('Emociones', const Color(0xFFE1BEE7), selectedCategory == 'Emociones'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Pictogramas dinámicos
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pictogramas: $selectedCategory',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: categoryData[selectedCategory]!
                        .map((item) => _buildPictogramIcon(
                              item['emoji']!,
                              item['label']!,
                              _getCategoryColor(selectedCategory),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Área de construcción de mensaje
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildWordButton('YO', const Color(0xFFEF9A9A)),
                  const SizedBox(width: 8),
                  _buildWordButton('QUIERO', const Color(0xFFB39DDB)),
                  const SizedBox(width: 8),
                  _buildWordButton('COMER', const Color(0xFFFFF59D)),
                  const SizedBox(width: 8),
                  if (selectedPictogram.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(selectedCategory),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        selectedPictogram.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedWords.clear();
                        selectedPictogram = '';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF5350),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Borrar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Función leer
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Leer',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Función guardar
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7E57C2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Función enviar
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9C27B0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Enviar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Función inicio
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9800),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Inicio',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String text, Color color, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = text;
          selectedPictogram = ''; // Limpiar selección al cambiar categoría
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPictogramIcon(String emoji, String label, Color backgroundColor) {
    bool isSelected = selectedPictogram == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPictogram = isSelected ? '' : label;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Comida':
        return const Color(0xFFFFF59D);
      case 'Personas':
        return const Color(0xFFEF9A9A);
      case 'Lugares':
        return const Color(0xFFA5D6A7);
      case 'Acciones':
        return const Color(0xFFB39DDB);
      case 'Emociones':
        return const Color(0xFFE1BEE7);
      default:
        return const Color(0xFFE1BEE7);
    }
  }

  Widget _buildWordButton(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}