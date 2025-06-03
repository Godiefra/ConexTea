import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // ---------- Estado principal ---------- //
  DateTime selectedDate = DateTime(2025, 4, 7); // Lunes 7‑abril‑2025
  String selectedView = 'Día';

  final Map<String, List<EventData>> eventsData = {
    '2025-04-07': [
      EventData('Desayuno', '08:00 - 08:45', 'Cocina', const Color(0xFFFFE4B5)),
      EventData('Escuela: Matemáticas', '09:30 - 10:30', 'Aula principal', const Color(0xFFB8E6B8)),
      EventData('Escuela: Lectura', '10:30 - 11:45', 'Biblioteca', const Color(0xFFB8E6B8)),
      EventData('Almuerzo', '12:00 - 12:45', 'Comedor', const Color(0xFFFFE4B5)),
      EventData('Tiempo libre', '14:00 - 15:00', 'Patio 😊', const Color(0xFFD8BFD8)),
    ],
    '2025-04-08': [
      EventData('Desayuno', '08:00 - 08:45', 'Cocina', const Color(0xFFFFE4B5)),
      EventData('Terapia ocupacional', '09:00 - 10:00', 'Sala terapia', const Color(0xFFFFB6C1)),
      EventData('Escuela: Arte', '10:30 - 11:30', 'Taller arte', const Color(0xFFB8E6B8)),
      EventData('Almuerzo', '12:00 - 12:45', 'Comedor', const Color(0xFFFFE4B5)),
    ],
    '2025-04-09': [
      EventData('Desayuno', '08:00 - 08:45', 'Cocina', const Color(0xFFFFE4B5)),
      EventData('Escuela: Ciencias', '09:30 - 10:30', 'Laboratorio', const Color(0xFFB8E6B8)),
      EventData('Recreo', '10:30 - 11:00', 'Patio', const Color(0xFFD8BFD8)),
      EventData('Almuerzo', '12:00 - 12:45', 'Comedor', const Color(0xFFFFE4B5)),
      EventData('Música', '15:00 - 16:00', 'Sala música', const Color(0xFFFFB6C1)),
    ],
  };

  // ---------- Controladores de diálogo ---------- //
  final _titleC    = TextEditingController();
  final _timeC     = TextEditingController();
  final _locC      = TextEditingController();
  DateTime? _newEventDate;
  Color _selectedColor = const Color(0xFFB8E6B8);
  final List<Color> _palette = [
    const Color(0xFFFFE4B5),
    const Color(0xFFB8E6B8),
    const Color(0xFFFFB6C1),
    const Color(0xFFD8BFD8),
    const Color(0xFF90CAF9),
  ];

  @override
  void dispose() { _titleC.dispose(); _timeC.dispose(); _locC.dispose(); super.dispose(); }

  // ==================== BUILD ==================== //
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF5F5F5),
    appBar: _appBar(),
    body : Column(children:[ _topControls(), Expanded(child: _contentView()) ]),
    floatingActionButton: FloatingActionButton(
      backgroundColor: const Color(0xFF4CAF50),
      child: const Icon(Icons.add, color: Colors.white),
      onPressed: _openAddDialog,
    ),
  );

  AppBar _appBar() => AppBar(
    backgroundColor: const Color(0xFF4A90E2),
    title: const Text('ConexTEA - Calendario de Rutinas',style:TextStyle(color:Colors.white)),
  );

  /* ---------------- TOP BAR ---------------- */
  Widget _topControls() => Container(
    color: Colors.white,
    padding: const EdgeInsets.all(16),
    child: Row(children:[
      _viewButton('Día'), const SizedBox(width:8),
      _viewButton('Semana'), const SizedBox(width:8),
      _viewButton('Mes'), const Spacer(),
      Text(_headerTxt(), style:const TextStyle(fontSize:16,color:Colors.grey,fontWeight:FontWeight.w500)),
    ]),
  );

  Widget _viewButton(String v){
    final sel = selectedView==v;
    return GestureDetector(
      onTap: ()=>setState(()=>selectedView=v),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal:20,vertical:10),
        decoration: BoxDecoration(
          color: sel?const Color(0xFF4A90E2):Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF4A90E2)),
        ),
        child: Text(v,style:TextStyle(color: sel?Colors.white:const Color(0xFF4A90E2))),
      ),
    );
  }

  String _headerTxt(){
    const m=['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'];
    switch(selectedView){
      case 'Día':   return '${_weekday(selectedDate)}, ${selectedDate.day} ${m[selectedDate.month-1]} ${selectedDate.year}';
      case 'Semana':
        final s=_startOfWeek(selectedDate), e=s.add(const Duration(days:6));
        return 'Semana del ${s.day} - ${e.day} ${m[s.month-1]} ${s.year}';
      case 'Mes':   return '${m[selectedDate.month-1]} ${selectedDate.year}';
      default:      return '';
    }
  }

  /* ---------------- CONTENIDO ---------------- */
  Widget _contentView(){
    switch(selectedView){
      case 'Día'   : return _dayView(selectedDate);
      case 'Semana': return _weekView(selectedDate);
      case 'Mes'   : return _monthView(selectedDate);
    }
    return const SizedBox.shrink();
  }

  /* ---------------- VISTA DÍA ---------------- */
  Widget _dayView(DateTime d){
    final list = eventsData[_key(d)] ?? [];
    return _card(ListView.builder(
      padding: const EdgeInsets.symmetric(vertical:16),
      itemCount: list.length,
      itemBuilder: (_,i)=>_eventTile(d,list[i]),
    ));
  }

  /* ---------------- VISTA SEMANA ---------------- */
  Widget _weekView(DateTime focus){
    final mon=_startOfWeek(focus);
    final days=List.generate(7,(i)=>mon.add(Duration(days:i)));

    return _card(Column(children:[
      // Encabezado
      Container(
        height:60,
        decoration: const BoxDecoration(border:Border(bottom:BorderSide(color:Colors.grey,width:.5))),
        child:Row(children:[
          const SizedBox(width:60),
          ...days.map((d)=>Expanded(child:Container(
            alignment:Alignment.center,
            decoration:BoxDecoration(
              color:d.day==focus.day?const Color(0xFF4A90E2).withOpacity(.1):null,
              border: const Border(left:BorderSide(color:Colors.grey,width:.5)),
            ),
            child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
              Text(_weekdayShort(d),style:const TextStyle(fontSize:12,fontWeight:FontWeight.bold)),
              Text('${d.day}',style:const TextStyle(fontSize:16,fontWeight:FontWeight.w500)),
            ]),
          ))),
        ]),
      ),
      // Horario
      Expanded(child:SingleChildScrollView(child:Column(children:List.generate(12,(idx){
        final h=8+idx;
        return Container(
          height:60,
          decoration: const BoxDecoration(border:Border(bottom:BorderSide(color:Colors.grey,width:.3))),
          child:Row(children:[
            Container(width:60,alignment:Alignment.center,child:Text('${h.toString().padLeft(2,'0')}:00',style:const TextStyle(fontSize:12,color:Colors.grey))),
            ...days.map((d)=>Expanded(child:Container(
              decoration: const BoxDecoration(border:Border(left:BorderSide(color:Colors.grey,width:.3))),
              child:_weekCell(d,h),
            ))),
          ]),
        );
      })))),
    ]));
  }

  Widget _weekCell(DateTime d,int h){
    final ev=(eventsData[_key(d)]??[]).firstWhere((e)=>_startHour(e.time)==h,orElse:()=>EventData.empty());
    if(ev.isEmpty) return const SizedBox.shrink();
    return GestureDetector(onLongPress:()=>_confirmDelete(d,ev),child:_chip(ev));
  }

  /* ---------------- VISTA MES ---------------- */
  Widget _monthView(DateTime focus){
    final first=DateTime(focus.year,focus.month,1);
    final daysIn=DateTime(focus.year,focus.month+1,0).day;
    final lead=first.weekday==7?0:first.weekday;
    final rows=((lead+daysIn)/7).ceil();

    return _card(Column(children:[
      Container(
        height:50,
        decoration: const BoxDecoration(border:Border(bottom:BorderSide(color:Colors.grey,width:.5))),
        child:Row(children:['Lun','Mar','Mié','Jue','Vie','Sáb','Dom'].map((d)=>Expanded(child:Center(child:Text(d,style:const TextStyle(fontWeight:FontWeight.bold))))).toList()),
      ),
      Expanded(child:GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:7),
        itemCount:rows*7,
        itemBuilder:(_,i){
          final num=i-lead+1;
          final inMonth=num>=1&&num<=daysIn;
          final date=inMonth?DateTime(focus.year,focus.month,num):null;
          final has=date!=null&&(eventsData[_key(date)]?.isNotEmpty??false);

          return GestureDetector(
            onTap: date!=null?()=>setState(()=>{selectedDate=date,selectedView='Día'}) : null,
            child:Container(
              decoration:BoxDecoration(border:Border.all(color:Colors.grey.withOpacity(.3))),
              child:Column(children:[const SizedBox(height:4),
                if(inMonth) Text('$num',style:TextStyle(fontSize:12,fontWeight:FontWeight.w500,color:has?Colors.black:Colors.grey[700])),
                if(has) Container(margin:const EdgeInsets.only(top:2),width:6,height:6,decoration:const BoxDecoration(color:Color(0xFF4CAF50),shape:BoxShape.circle)),
              ]),
            ),
          );
        },
      )),
    ]));
  }

  /* ---------------- DIÁLOGO NUEVO EVENTO ---------------- */
  void _openAddDialog(){
    _titleC.clear(); _timeC.clear(); _locC.clear();
    _newEventDate=selectedDate; _selectedColor=_palette[1];

    showDialog(context:context,builder:(rootCtx){
      return StatefulBuilder(builder:(dialogCtx,setModal){
        return AlertDialog(
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12)),
          title:const Text('Nuevo evento'),
          content:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,children:[
            _tField(_titleC,'Título'), const SizedBox(height:8),
            _tField(_timeC,'Horario (ej: 16:00 - 17:00)'), const SizedBox(height:8),
            _tField(_locC,'Lugar'), const SizedBox(height:12),
            // Fecha
            Row(children:[const Icon(Icons.calendar_today,size:20,color:Colors.grey), const SizedBox(width:8),
              Text(_fmtDate(_newEventDate!),style:const TextStyle(fontWeight:FontWeight.w500)), const Spacer(),
              TextButton(child:const Text('Cambiar'),onPressed:()async{
                final p=await showDatePicker(
                  context:dialogCtx, initialDate:_newEventDate!, firstDate:DateTime(2024), lastDate:DateTime(2030), locale:const Locale('es','ES'),
                ); if(p!=null) setModal(()=>_newEventDate=p);
              })]),
            const SizedBox(height:12),
            // Paleta colores
            Align(alignment:Alignment.centerLeft,child:Wrap(spacing:8,children:_palette.map((c)=>GestureDetector(
              onTap:(){
                setModal(()=>_selectedColor=c);
                ScaffoldMessenger.of(rootCtx).showSnackBar(const SnackBar(content:Text('Color seleccionado')));
              },
              child:Container(width:28,height:28,decoration:BoxDecoration(
                color:c, shape:BoxShape.circle,
                border: Border.all(color: _selectedColor==c?Colors.black:Colors.transparent,width:2),
              )),
            )).toList())),
          ])),
          actions:[
            TextButton(onPressed:()=>Navigator.pop(dialogCtx),child:const Text('Cancelar')),
            ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:const Color(0xFF4CAF50)),
              onPressed:_saveEvent, child:const Text('Guardar')),
          ],
        );
      });
    });
  }

  Widget _tField(TextEditingController c,String h)=>TextField(
    controller:c,
    decoration:InputDecoration(hintText:h,border:OutlineInputBorder(borderRadius:BorderRadius.circular(8))),
  );

  void _saveEvent(){
    if(_titleC.text.trim().isEmpty||_timeC.text.trim().isEmpty||_locC.text.trim().isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Completa todos los campos'))); return;
    }
    final ev=EventData(_titleC.text.trim(),_timeC.text.trim(),_locC.text.trim(),_selectedColor);
    setState(()=>eventsData.putIfAbsent(_key(_newEventDate!),()=>[]).add(ev));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Evento creado')));
    selectedDate=_newEventDate!; selectedView='Día';
  }

  /* ---------------- BORRAR EVENTO ---------------- */
  void _confirmDelete(DateTime d,EventData e){
    showDialog(context:context,builder:(_)=>AlertDialog(
      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12)),
      title:const Text('Eliminar evento'),
      content:Text('¿Eliminar "${e.title}"?'),
      actions:[
        TextButton(onPressed:Navigator.of(context).pop,child:const Text('Cancelar')),
        ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:const Color(0xFFD32F2F)),
          child:const Text('Eliminar'),
          onPressed:(){
            setState(()=>eventsData[_key(d)]?.remove(e));
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Evento eliminado')));
          }),
      ],
    ));
  }

  /* ---------------- HELPERS ---------------- */
  String _key(DateTime d)=>'${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
  DateTime _startOfWeek(DateTime d)=>d.subtract(Duration(days:d.weekday-1));
  String _weekday(DateTime d)=>['Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo'][d.weekday-1];
  String _weekdayShort(DateTime d)=>['Lun','Mar','Mié','Jue','Vie','Sáb','Dom'][d.weekday-1];
  int? _startHour(String t)=>int.tryParse(t.split(':').first);
  String _fmtDate(DateTime d)=>'${d.day}/${d.month.toString().padLeft(2,'0')}/${d.year}';

  Widget _card(Widget child)=>Container(
    margin:const EdgeInsets.all(16),
    decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(12),
      boxShadow:[BoxShadow(color:Colors.grey.withOpacity(.1),blurRadius:5,offset:const Offset(0,2))]),
    child:child,
  );
  Widget _chip(EventData e)=>Container(margin:const EdgeInsets.all(2),padding:const EdgeInsets.all(4),
    decoration:BoxDecoration(color:e.color,borderRadius:BorderRadius.circular(4)),child:Text(e.title,style:const TextStyle(fontSize:10)),);
  Widget _eventTile(DateTime d,EventData e)=>GestureDetector(onLongPress:()=>_confirmDelete(d,e),child:Container(
    margin:const EdgeInsets.symmetric(horizontal:16,vertical:4),padding:const EdgeInsets.all(12),
    decoration:BoxDecoration(color:e.color,borderRadius:BorderRadius.circular(8)),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(e.title,style:const TextStyle(fontWeight:FontWeight.w600)),
      const SizedBox(height:4),
      Text('${e.time} | ${e.location}',style:const TextStyle(fontSize:12,color:Colors.black54)),
    ]),));
}

/* ---------------- MODELO ---------------- */
class EventData{
  final String title,time,location; final Color color;
  EventData(this.title,this.time,this.location,this.color);
  bool get isEmpty=>title.isEmpty;
  static EventData empty()=>EventData('','','',Colors.transparent);
  @override bool operator==(Object o)=>identical(this,o)||(o is EventData&&title==o.title&&time==o.time&&location==o.location);
  @override int get hashCode=>title.hashCode^time.hashCode^location.hashCode;
}