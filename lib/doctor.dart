import 'package:flutter/material.dart';

class Doctor {
  final String name;
  final String specialty;
  final String availableAppointments;
  final String imageUrl; // Agregamos la URL de la imagen

  Doctor({
    required this.name,
    required this.specialty,
    required this.availableAppointments,
    required this.imageUrl, // Requerimos la URL de la imagen en el constructor
  });
}

List<Doctor> doctors = [
  Doctor(
    name: 'Dr. Selina Zamora',
    specialty: 'Pediatra',
    availableAppointments: '9:00 am - 10:00 am, 2:00 pm - 3:00 pm',
    imageUrl: 'data:image/jpeg;base64,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', // URL de ejemplo
  ),
  Doctor(
    name: 'Dr. Anthony Fauci',
    specialty: 'Cardiólogo',
    availableAppointments: '10:00 am - 11:00 am, 3:00 pm - 4:00 pm',
    imageUrl: 'https://via.placeholder.com/150', // URL de ejemplo
  ),
  Doctor(
    name: 'Dr. Dionneary García',
    specialty: 'Medicina General',
    availableAppointments: '11:00 am - 12:00 pm, 4:00 pm - 5:00 pm',
    imageUrl: 'https://via.placeholder.com/150', // URL de ejemplo
  ),
];

class DoctoresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          elevation: 4.0,
          child: ListTile(
            contentPadding: EdgeInsets.all(12.0),
            leading: CircleAvatar(
              radius: 30.0, // Ajusta el radio según tus necesidades para hacer la imagen más grande
              backgroundImage: NetworkImage(doctor.imageUrl),
            ),
            title: Text(doctor.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.0),
                Text('Especialidad: ${doctor.specialty}'),
                SizedBox(height: 4.0),
                Text('Citas disponibles: ${doctor.availableAppointments}'),
              ],
            ),
            onTap: () {
              // Aquí podrías agregar la lógica para agendar citas con el doctor seleccionado
            },
          ),
        );
      },
    );
  }
}
