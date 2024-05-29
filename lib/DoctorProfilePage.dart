import 'package:flutter/material.dart';
import 'citas.dart';
import 'mongodb.dart';

class Doctor {
  final String name;
  final String specialty;
  final String imageUrl;
  final String turnoEntrada;
  final String turnoSalida;

  Doctor({
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.turnoEntrada,
    required this.turnoSalida,
  });
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
  }

  void _generateAppointmentTimes() {
    appointmentTimes.clear();
    if (selectedDate == null) {
      return;
    }
    final selectedDateTime = selectedDate!;
    final turnoEntradaParts = widget.doctor.turnoEntrada.split(':');
    final turnoSalidaParts = widget.doctor.turnoSalida.split(':');
    final turnoEntradaDateTime = DateTime(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, int.parse(turnoEntradaParts[0]), int.parse(turnoEntradaParts[1]));
    final turnoSalidaDateTime = DateTime(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, int.parse(turnoSalidaParts[0]), int.parse(turnoSalidaParts[1]));
    DateTime startTime = turnoEntradaDateTime;
    while (startTime.isBefore(turnoSalidaDateTime.subtract(Duration(minutes: 30)))) {
      final endTime = startTime.add(Duration(minutes: 30));
      appointmentTimes.add('${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - '
          '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}');
      startTime = endTime;
    }
  }

  void _showAppointmentTimes(DateTime date) {
    setState(() {
      selectedDate = date;
      selectedAppointment = null;
      _generateAppointmentTimes();
    });
  }

  void _confirmAppointment() async {
    if (selectedDate != null && selectedAppointment != null) {
      try {
        if (MongoDatabase.currentUser != null) {
          String telefono = MongoDatabase.currentUser!['Telefono'];

          // Crear el objeto de cita
          Map<String, dynamic> cita = {
            'doctorName': widget.doctor.name,
            'specialty': widget.doctor.specialty,
            'date': selectedDate!.toString(),
            'time': selectedAppointment!,
            'status': 'Activa',
          };

          await MongoDatabase.guardarCitaPaciente(telefono, cita);

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Cita Agendada'),
                content: Text('Tu cita ha sido agendada exitosamente.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CitasPage()),
                      ); // Navega a CitasPage
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Debes iniciar sesión para agendar una cita.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('$e'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Debes seleccionar una fecha y una hora de cita.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
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
                  initialDate: DateTime.now().add(Duration(days: 3)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                  selectableDayPredicate: (DateTime date) {
                    return date.isAfter(DateTime.now().add(Duration(days: 2)));
                  },
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
