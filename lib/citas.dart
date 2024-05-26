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
  void cancelAppointment(Appointment appointment) {
    setState(() {
      appointment.status = 'Cancelada'; // Update status to 'Cancelada'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Citas'),
      ),
      body: ListView.builder(
        itemCount: confirmedAppointments.length,
        itemBuilder: (context, index) {
          final appointment = confirmedAppointments[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: EdgeInsets.all(12.0),
              title: Text('${appointment.doctorName} - ${appointment.specialty}'),
              subtitle: Text('${appointment.date.day}/${appointment.date.month}/${appointment.date.year} a las ${appointment.time}'),
              trailing: appointment.status == 'Activa'
                  ? TextButton(
                onPressed: () {
                  cancelAppointment(appointment);
                },
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                ),
              )
                  : Text('Cancelada', style: TextStyle(color: Colors.grey)),
            ),
          );
        },
      ),
    );
  }
}
