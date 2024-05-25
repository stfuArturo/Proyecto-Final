import 'package:flutter/material.dart';

class Doctor {
  final String name;
  final String specialty;
  final String imageUrl;
  final Map<DateTime, List<String>> availableAppointments;

  Doctor({
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.availableAppointments,
  });
}

List<Doctor> doctors = [
  Doctor(
    name: 'Dr. Selina Zamora',
    specialty: 'Pediatra',
    imageUrl: '',
    availableAppointments: {
      DateTime(2024, 5, 25): ['9:00 am - 10:00 am', '2:00 pm - 3:00 pm'],
      DateTime(2024, 5, 26): ['10:00 am - 11:00 am', '3:00 pm - 4:00 pm'],
    },
  ),
  Doctor(
    name: 'Dr. Anthony Fauci',
    specialty: 'Cardiólogo',
    imageUrl: '',
    availableAppointments: {
      DateTime(2024, 5, 25): ['10:00 am - 11:00 am', '3:00 pm - 4:00 pm'],
      DateTime(2024, 5, 26): ['11:00 am - 12:00 pm', '4:00 pm - 5:00 pm'],
    },
  ),
];

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DoctoresPage(),
  ));
}

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
    for (int i = 9; i <= 15; i++) {
      if (i < 12) {
        appointmentTimes.add('$i:00 am');
        appointmentTimes.add('$i:30 am');
      } else if (i == 12) {
        appointmentTimes.add('$i:00 pm');
        appointmentTimes.add('$i:30 pm');
      } else {
        appointmentTimes.add('${i - 12}:00 pm');
        appointmentTimes.add('${i - 12}:30 pm');
      }
    }
  }

  void _showAppointmentTimes(DateTime date) {
    setState(() {
      selectedDate = date;
      selectedAppointment = null; // Reset selected appointment
    });
  }

  List<String> getAvailableAppointments(DateTime date) {
    List<String> availableSlots = [];
    widget.doctor.availableAppointments.forEach((key, value) {
      if (key == date) {
        availableSlots.addAll(value);
      }
    });
    return availableSlots;
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
                    children: getAvailableAppointments(selectedDate!)
                        .map((time) => ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedAppointment = time;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.resolveWith(
                              (states) {
                            if (selectedAppointment == time) {
                              return Colors.blueGrey;
                            } else {
                              return null;
                            }
                          },
                        ),
                        padding:
                        MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                        ),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(fontSize: 12),
                      ),
                    ))
                        .toList(),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: selectedAppointment != null,
                    child: ElevatedButton(
                      onPressed: () {
                        // Implementa la lógica para confirmar la cita aquí
                        // Guarda el valor del horario seleccionado
                        print(
                            'Horario seleccionado: $selectedAppointment');
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                      ),
                      child: Text(
                        'Confirmar Cita',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 20),
            Text(
              'Horarios Disponibles:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                children: appointmentTimes
                    .map(
                      (time) => ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedAppointment = time;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                            (states) {
                          if (selectedAppointment == time) {
                            return Colors.green;
                          } else {
                            return null;
                          }
                        },
                      ),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      ),
                      shape:
                      MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                )
                    .toList(),
              ),
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
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.0),
                  Text('Especialidad: ${doctor.specialty}'),
                  SizedBox(height: 4.0),
                  Text('Citas disponibles:'),
                  SizedBox(height: 4.0),
                  ...doctor.availableAppointments.entries.map((entry) {
                    DateTime date = entry.key;
                    List<String> slots = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${date.day}/${date.month}/${date.year}: ${slots.join(", ")}'),
                        SizedBox(height: 8.0),
                      ],
                    );
                  }).toList(),
                ],
              ),
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
