import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Vista principal para crear y enviar mensajes
class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  // Categoría seleccionada actualmente  
  String selectedCategory = 'Emociones';

  // Instancia de Flutter TTS
  late FlutterTts flutterTts;
  bool isSpeaking = false;

  /// Partes que componen el mensaje.
  ///  Cada parte lleva el texto y el color con el que debe mostrarse.
  late List<Map<String, dynamic>> messageParts;

  /// Datos de pictogramas por categoría
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
      {'emoji': '👶', 'label': 'Yo'},
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
    'Verbos': [
      {'emoji': '🙏', 'label': 'Quiero'},
      {'emoji': '🤲', 'label': 'Necesito'},
      {'emoji': '🤝', 'label': 'Tengo'},
      {'emoji': '🙋', 'label': 'Puedo'},
      {'emoji': '❌', 'label': 'No quiero'},
      {'emoji': '🆘', 'label': 'Ayuda'},
      {'emoji': '💭', 'label': 'Pienso'},
      {'emoji': '🗣️', 'label': 'Digo'},
    ],
  };

  @override
  void initState() {
    super.initState();
    // Mensaje base
    messageParts = [
      {'text': 'YO', 'color': const Color(0xFFEF9A9A)},
      {'text': 'QUIERO', 'color': const Color(0xFFB39DDB)},
      {'text': 'COMER', 'color': const Color(0xFFFFF59D)},
    ];
    
    // Inicializar TTS
    _initTts();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  /// Inicializa el motor de texto a voz
  void _initTts() {
    flutterTts = FlutterTts();
    
    // Configurar idioma a español
    flutterTts.setLanguage("es-ES");
    
    // Configurar velocidad (0.0 a 1.0)
    flutterTts.setSpeechRate(0.5);
    
    // Configurar volumen (0.0 a 1.0)
    flutterTts.setVolume(1.0);
    
    // Configurar tono (0.5 a 2.0)
    flutterTts.setPitch(1.0);

    // Listeners para controlar el estado
    flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isSpeaking = false;
      });
      _showSimpleDialog(
        context,
        title: 'Error',
        message: 'No se pudo reproducir el mensaje: $msg',
      );
    });
  }

  /// Lee el mensaje en voz alta
  Future<void> _speakMessage() async {
    if (messageParts.isEmpty) {
      _showSimpleDialog(
        context,
        title: 'Sin mensaje',
        message: 'No hay mensaje para leer.',
      );
      return;
    }

    if (isSpeaking) {
      // Si ya está hablando, detener
      await flutterTts.stop();
      return;
    }

    // Construir el mensaje a leer
    String messageToSpeak = messageParts
        .map((part) => part['text'] as String)
        .join(' ');

    await flutterTts.speak(messageToSpeak);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CATEGORÍAS ----------------------------------------------------
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
                      _buildCategoryButton('Comida', const Color(0xFFFFF59D)),
                      const SizedBox(width: 8),
                      _buildCategoryButton('Personas', const Color(0xFFEF9A9A)),
                      const SizedBox(width: 8),
                      _buildCategoryButton('Lugares', const Color(0xFFA5D6A7)),
                      const SizedBox(width: 8),
                      _buildCategoryButton('Acciones', const Color(0xFFB39DDB)),
                      const SizedBox(width: 8),
                      _buildCategoryButton('Emociones', const Color(0xFFE1BEE7)),
                      const SizedBox(width: 8),
                      _buildCategoryButton('Verbos', const Color(0xFF9C27B0)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // PICTOGRAMAS ---------------------------------------------------
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
                        .map(
                          (item) => _buildPictogramIcon(
                            item['emoji']!,
                            item['label']!,
                            _getCategoryColor(selectedCategory),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // MENSAJE CONSTRUIDO --------------------------------------------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final part in messageParts) ...[
                      _buildWordButton(
                        part['text'] as String,
                        part['color'] as Color,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
            ),
            const Spacer(),

            // BOTONES DE ACCIÓN ---------------------------------------------
            Row(
              children: [
                // BORRAR ---------
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (messageParts.isNotEmpty) {
                          messageParts.removeLast();
                        }
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // LEER ------------
                Expanded(
                  child: ElevatedButton(
                    onPressed: _speakMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSpeaking 
                          ? const Color(0xFFFF9800) 
                          : const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSpeaking ? Icons.stop : Icons.volume_up,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isSpeaking ? 'Detener' : 'Leer',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // GUARDAR ---------
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showSimpleDialog(
                        context,
                        title: 'Mensaje guardado',
                        message: 'Se ha guardado el mensaje correctamente.',
                      );
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // ENVIAR ----------
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _showSimpleDialog(
                        context,
                        title: 'Mensaje enviado',
                        message: '¡Tu mensaje ha sido enviado con éxito!',
                      );

                      // Navega a la vista de mensaje enviado
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SentMessagePage(messageParts: messageParts),
                        ),
                      );
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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

  // --------------------- WIDGETS AUXILIARES ------------------------------

  /// Botón para la selección de categorías
  Widget _buildCategoryButton(String text, Color color) {
    final bool isSelected = selectedCategory == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = text;
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

  /// Icono de pictograma que se puede añadir al mensaje
  Widget _buildPictogramIcon(
      String emoji, String label, Color backgroundColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          messageParts.add({
            'text': label.toUpperCase(),
            'color': backgroundColor,
          });
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
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

  /// Ficha de palabra dentro del mensaje
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

  /// Obtiene el color asociado a una categoría
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
      case 'Verbos':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFFE1BEE7);
    }
  }

  /// Muestra un diálogo sencillo reutilizable
  Future<void> _showSimpleDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}

/// Vista que muestra el mensaje que se acaba de enviar
class SentMessagePage extends StatelessWidget {
  final List<Map<String, dynamic>> messageParts;

  const SentMessagePage({Key? key, required this.messageParts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
        title: const Text(
          'Mensaje Enviado',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tu mensaje:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final part in messageParts) ...[
                      _buildWordButton(
                        part['text'] as String,
                        part['color'] as Color,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reutiliza el mismo estilo de ficha de palabra
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