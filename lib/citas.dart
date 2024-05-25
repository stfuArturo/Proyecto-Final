import 'package:flutter/material.dart';

class Appointment {
  final String doctorName;
  final String specialty;
  final DateTime date;
  final String time;

  Appointment({
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
  });
}

List<Appointment> confirmedAppointments = [];

class CitasPage extends StatelessWidget {
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
                'Especialidad: ${appointment.specialty}\nFecha: ${appointment.date.day}/${appointment.date.month}/${appointment.date.year}\nHora: ${appointment.time}'),
          );
        },
      ),
    );
  }
}
