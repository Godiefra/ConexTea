import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  String selectedView = 'Día';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ConexTEA - Calendario de Rutinas',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Controles superiores
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Botones de vista
                Row(
                  children: [
                    _buildViewButton('Día', true),
                    const SizedBox(width: 8),
                    _buildViewButton('Semana', false),
                    const SizedBox(width: 8),
                    _buildViewButton('Mes', false),
                    const Spacer(),
                    const Text(
                      'Lunes, 7 Abril 2025',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Lista de eventos
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(0),
                      children: [
                        _buildTimeSlot('8:00', '9:00'),
                        _buildEventItem(
                          'Desayuno',
                          '8:00 - 8:45',
                          'Cocina',
                          const Color(0xFFFFE4B5),
                        ),
                        _buildTimeSlot('9:00', '10:00'),
                        _buildEventItem(
                          'Escuela: Clase de matemáticas',
                          '9:30 - 10:30',
                          'Aula principal 🎭',
                          const Color(0xFFB8E6B8),
                        ),
                        _buildTimeSlot('10:00', '11:00'),
                        _buildEventItem(
                          'Escuela: Clase de lectura',
                          '10:30 - 11:45',
                          'Biblioteca',
                          const Color(0xFFB8E6B8),
                        ),
                        _buildTimeSlot('11:00', '12:00'),
                        _buildEventItem(
                          'Almuerzo',
                          '12:00 - 12:45',
                          'Comedor',
                          const Color(0xFFFFE4B5),
                        ),
                        _buildTimeSlot('12:00', '13:00'),
                        _buildTimeSlot('13:00', '14:00'),
                        _buildEventItem(
                          'Tiempo libre',
                          '14:00 - 15:00',
                          'Patio 😊',
                          const Color(0xFFD8BFD8),
                        ),
                        _buildTimeSlot('14:00', '15:00'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildViewButton(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF4A90E2) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4A90E2),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF4A90E2),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String startTime, String endTime) {
    return Container(
      height: 60,
      child: Row(
        children: [
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                Text(
                  startTime,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  endTime,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(String title, String time, String location, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 68, right: 16, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$time | $location',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}