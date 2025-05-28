import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  String selectedView = 'Día';
  DateTime selectedDate = DateTime.now();

  // Datos de ejemplo para diferentes días
  final Map<String, List<EventData>> eventsData = {
    'Lunes': [
      EventData('Desayuno', '8:00 - 8:45', 'Cocina', const Color(0xFFFFE4B5)),
      EventData('Escuela: Clase de matemáticas', '9:30 - 10:30', 'Aula principal 🎭', const Color(0xFFB8E6B8)),
      EventData('Escuela: Clase de lectura', '10:30 - 11:45', 'Biblioteca', const Color(0xFFB8E6B8)),
      EventData('Almuerzo', '12:00 - 12:45', 'Comedor', const Color(0xFFFFE4B5)),
      EventData('Tiempo libre', '14:00 - 15:00', 'Patio 😊', const Color(0xFFD8BFD8)),
    ],
    'Martes': [
      EventData('Desayuno', '8:00 - 8:45', 'Cocina', const Color(0xFFFFE4B5)),
      EventData('Terapia ocupacional', '9:00 - 10:00', 'Sala de terapia', const Color(0xFFFFB6C1)),
      EventData('Escuela: Arte', '10:30 - 11:30', 'Taller de arte', const Color(0xFFB8E6B8)),
      EventData('Almuerzo', '12:00 - 12:45', 'Comedor', const Color(0xFFFFE4B5)),
    ],
    'Miércoles': [
      EventData('Desayuno', '8:00 - 8:45', 'Cocina', const Color(0xFFFFE4B5)),
      EventData('Escuela: Ciencias', '9:30 - 10:30', 'Laboratorio', const Color(0xFFB8E6B8)),
      EventData('Recreo', '10:30 - 11:00', 'Patio', const Color(0xFFD8BFD8)),
      EventData('Almuerzo', '12:00 - 12:45', 'Comedor', const Color(0xFFFFE4B5)),
      EventData('Música', '15:00 - 16:00', 'Sala de música', const Color(0xFFFFB6C1)),
    ],
  };

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
                    _buildViewButton('Día'),
                    const SizedBox(width: 8),
                    _buildViewButton('Semana'),
                    const SizedBox(width: 8),
                    _buildViewButton('Mes'),
                    const Spacer(),
                    Text(
                      _getDateText(),
                      style: const TextStyle(
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
          // Contenido del calendario
          Expanded(
            child: _buildCalendarContent(),
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

  Widget _buildViewButton(String text) {
    bool isSelected = selectedView == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedView = text;
        });
      },
      child: Container(
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
      ),
    );
  }

  String _getDateText() {
    switch (selectedView) {
      case 'Día':
        return 'Lunes, 7 Abril 2025';
      case 'Semana':
        return 'Semana del 7 - 13 Abril 2025';
      case 'Mes':
        return 'Abril 2025';
      default:
        return 'Lunes, 7 Abril 2025';
    }
  }

  Widget _buildCalendarContent() {
    switch (selectedView) {
      case 'Día':
        return _buildDayView();
      case 'Semana':
        return _buildWeekView();
      case 'Mes':
        return _buildMonthView();
      default:
        return _buildDayView();
    }
  }

  Widget _buildDayView() {
    return Container(
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
    );
  }

  Widget _buildWeekView() {
    List<String> days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    List<String> dates = ['7', '8', '9', '10', '11', '12', '13'];

    return Container(
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
          // Encabezado de días
          Container(
            height: 60,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 60), // Espacio para las horas
                ...days.asMap().entries.map((entry) {
                  int index = entry.key;
                  String day = entry.value;
                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: index == 0 ? const Color(0xFF4A90E2).withOpacity(0.1) : null,
                        border: const Border(left: BorderSide(color: Colors.grey, width: 0.5)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(day, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text(dates[index], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          // Contenido de la semana
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(12, (hourIndex) {
                  int hour = 8 + hourIndex;
                  return Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            '${hour.toString().padLeft(2, '0')}:00',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ...List.generate(7, (dayIndex) {
                          return Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(left: BorderSide(color: Colors.grey, width: 0.3)),
                              ),
                              child: _buildWeekEventForDay(dayIndex, hour),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekEventForDay(int dayIndex, int hour) {
    // Eventos de ejemplo para algunos días y horas específicas
    if (dayIndex == 0) { // Lunes
      if (hour == 8) {
        return Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE4B5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text('Desayuno', style: TextStyle(fontSize: 10)),
        );
      } else if (hour == 9) {
        return Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFB8E6B8),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text('Matemáticas', style: TextStyle(fontSize: 10)),
        );
      }
    } else if (dayIndex == 1) { // Martes
      if (hour == 9) {
        return Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFFFB6C1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text('Terapia', style: TextStyle(fontSize: 10)),
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget _buildMonthView() {
    return Container(
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
          // Encabezado del mes
          Container(
            height: 50,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: Row(
              children: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'].map((day) {
                return Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      day,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Días del mes
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: 35, // 5 semanas
              itemBuilder: (context, index) {
                int day = index - 6; // Empezar desde el 1 en la segunda fila
                bool isCurrentMonth = day > 0 && day <= 30;
                bool hasEvent = isCurrentMonth && [7, 8, 9, 14, 15, 21, 22].contains(day);
                
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.3), width: 0.5),
                    color: day == 7 ? const Color(0xFF4A90E2).withOpacity(0.1) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (isCurrentMonth) ...[
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            day.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: day == 7 ? FontWeight.bold : FontWeight.normal,
                              color: day == 7 ? const Color(0xFF4A90E2) : Colors.black,
                            ),
                          ),
                        ),
                        if (hasEvent) ...[
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(vertical: 1),
                            decoration: const BoxDecoration(
                              color: Color(0xFF4CAF50),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
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

// Clase auxiliar para los eventos
class EventData {
  final String title;
  final String time;
  final String location;
  final Color color;

  EventData(this.title, this.time, this.location, this.color);
}