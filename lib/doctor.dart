import 'package:flutter/material.dart';

class Doctor {
  final String name;
  final String specialty;
  final String availableAppointments;

  Doctor({
    required this.name,
    required this.specialty,
    required this.availableAppointments,
  });
}

List<Doctor> doctors = [
  Doctor(
    name: 'Dr. Selina Zamora',
    specialty: 'Pediatra',
    availableAppointments: '9:00 am - 10:00 am, 2:00 pm - 3:00 pm',
  ),
  Doctor(
    name: 'Dr. Anthony Fauci',
    specialty: 'Cardiólogo',
    availableAppointments: '10:00 am - 11:00 am, 3:00 pm - 4:00 pm',
  ),
  Doctor(
    name: 'Dr. Dionneary García',
    specialty: 'Medicina General',
    availableAppointments: '11:00 am - 12:00 pm, 4:00 pm - 5:00 pm',
  ),
];

class DoctoresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return InkWell(
          onTap: () {
            // Aquí podrías agregar la lógica para agendar citas con el doctor seleccionado
          },
          child: Card(
            color: Colors.white,
            elevation: 2,
            child: ListTile(
              title: Text(doctor.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Especialidad: ${doctor.specialty}'),
                  Text('Citas disponibles: ${doctor.availableAppointments}'),
                ],
              ),
            ),
          ),
          onHover: (hovering) {
            // Cambiar el color de fondo cuando pasa el cursor
            if (hovering) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Doctor seleccionado: ${doctor.name}'),
              ));
            }
          },
        );
      },
    );
  }
}
