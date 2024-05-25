import 'package:flutter/material.dart';
import 'citas.dart'; // Importamos cita.dart

class Doctor {
  final String name;
  final String specialty;
  final String imageUrl;

  Doctor({
    required this.name,
    required this.specialty,
    required this.imageUrl,
  });
}

List<Doctor> doctors = [
  Doctor(
    name: 'Dr. Selina Zamora',
    specialty: 'Pediatra',
    imageUrl: '',
  ),
  Doctor(
    name: 'Dr. Anthony Fauci',
    specialty: 'Cardiólogo',
    imageUrl: '',
  ),
];

class DoctorProfilePage extends StatefulWidget {
  final Doctor doctor;

  DoctorProfilePage({required this.doctor});

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  DateTime? selectedDate;
  String? selectedAppointment;
  List<String> appointmentTimes = [];

  @override
  void initState() {
    super.initState();
    _generateAppointmentTimes();
  }

  void _generateAppointmentTimes() {
    for (int i = 9; i <= 15; i++) {
      if (i < 12) {
        appointmentTimes.add('$i:00 am - ${i + 1}:00 am');
      } else if (i == 12) {
        appointmentTimes.add('$i:00 pm - 1:00 pm');
      } else {
        appointmentTimes.add('${i - 12}:00 pm - ${i - 11}:00 pm');
      }
    }
  }

  void _showAppointmentTimes(DateTime date) {
    setState(() {
      selectedDate = date;
      selectedAppointment = null; // Reset selected appointment
    });
  }

  void _confirmAppointment() {
    if (selectedDate != null && selectedAppointment != null) {
      confirmedAppointments.add(Appointment(
        doctorName: widget.doctor.name,
        specialty: widget.doctor.specialty,
        date: selectedDate!,
        time: selectedAppointment!,
      ));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CitasPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil del Doctor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ${widget.doctor.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Especialidad: ${widget.doctor.specialty}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Selecciona una Fecha:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (selectedDate != null) {
                  _showAppointmentTimes(selectedDate);
                }
              },
              child: Text('Seleccionar Fecha'),
            ),
            SizedBox(height: 20),
            if (selectedDate != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Horarios Disponibles para ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: appointmentTimes.map((time) {
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedAppointment = time;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                            if (selectedAppointment == time) {
                              return Colors.blueGrey;
                            } else {
                              return null;
                            }
                          }),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        child: Text(
                          time,
                          style: TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: selectedAppointment != null,
                    child: ElevatedButton(
                      onPressed: _confirmAppointment,
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: Text(
                        'Confirmar Cita',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class DoctoresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Doctores'),
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: EdgeInsets.all(12.0),
              leading: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(doctor.imageUrl),
              ),
              title: Text(doctor.name),
              subtitle: Text('Especialidad: ${doctor.specialty}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorProfilePage(doctor: doctor),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
