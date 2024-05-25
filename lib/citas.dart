import 'package:flutter/material.dart';

class CitasPage extends StatefulWidget {
  @override
  _CitasPageState createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  List<Cita> citas = [
    Cita(
      fecha: '2024-05-25',
      hora: '10:00 AM',
      doctor: 'Dr. Juan Pérez',
      especialidad: 'Cardiología',
    ),
    Cita(
      fecha: '2024-05-26',
      hora: '11:00 AM',
      doctor: 'Dra. María López',
      especialidad: 'Dermatología',
    ),
    Cita(
      fecha: '2024-05-27',
      hora: '09:00 AM',
      doctor: 'Dr. Carlos Sánchez',
      especialidad: 'Neurología',
    ),
  ];

  void cancelarCita(int index) {
    setState(() {
      citas.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Citas confirmadas'),
      ),
      body: ListView.builder(
        itemCount: citas.length,
        itemBuilder: (context, index) {
          final cita = citas[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                '${cita.doctor} - ${cita.especialidad}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Fecha: ${cita.fecha}\nHora: ${cita.hora}'),
              isThreeLine: true,
              trailing: ElevatedButton(
                onPressed: () => cancelarCita(index),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white), // Cambia el color del texto a blanco
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Cita {
  final String fecha;
  final String hora;
  final String doctor;
  final String especialidad;

  Cita({
    required this.fecha,
    required this.hora,
    required this.doctor,
    required this.especialidad,
  });
}
