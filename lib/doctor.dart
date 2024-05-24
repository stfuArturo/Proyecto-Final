import 'dart:math';

class Doctor {
  final String name;
  final String imageUrl;
  final String specialty;
  final String shift;

  Doctor({
    required this.name,
    required this.imageUrl,
    required this.specialty,
    required this.shift,
  });
}

// Lista de doctores
List<Doctor> doctors = [
  Doctor(
    name: 'Dr. Selina Zamora',
    imageUrl: 'assets/doctor1.png', // Cambia la ruta según sea necesario
    specialty: 'Pediatra',
    shift: '9:00 am - 3:00 pm',
  ),
  Doctor(
    name: 'Dr. Anthony Fauci',
    imageUrl: 'assets/doctor2.png', // Cambia la ruta según sea necesario
    specialty: 'Cardiólogo',
    shift: '9:00 am - 3:00 pm',
  ),
  Doctor(
    name: 'Dr. Dionneary García',
    imageUrl: 'assets/doctor3.png', // Cambia la ruta según sea necesario
    specialty: 'Medicina General',
    shift: '9:00 am - 3:00 pm',
  ),
  // Puedes añadir más doctores aquí según sea necesario
];
