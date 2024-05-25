import 'package:flutter/material.dart';

class Appointment {
  final String doctorName;
  final String specialty;
  final DateTime date;
  final String time;
  String status; // Add status property

  Appointment({
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    this.status = 'Activa', // Default status is 'Activa'
  });
}

List<Appointment> confirmedAppointments = [];

class CitasPage extends StatefulWidget {
  @override
  _CitasPageState createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  void cancelAppointment(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Seguro que desea cancelar la cita?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                setState(() {
                  confirmedAppointments[index].status = 'Cancelada'; // Cambiar el estado a 'Cancelada'
                });
              },
              child: Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Citas Confirmadas'),
      ),
      body: ListView.builder(
        itemCount: confirmedAppointments.length,
        itemBuilder: (context, index) {
          final appointment = confirmedAppointments[index];
          return ListTile(
            title: Text('Doctor: ${appointment.doctorName}'),
            subtitle: Text(
                'Especialidad: ${appointment.specialty}\nFecha: ${appointment.date.day}/${appointment.date.month}/${appointment.date.year}\nHora: ${appointment.time}\nEstado: ${appointment.status}'),
            trailing: appointment.status == 'Activa'
                ? IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () => cancelAppointment(index),
            )
                : null, // No mostrar el botón de cancelar si la cita no está activa
          );
        },
      ),
    );
  }
}
