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
//Este genera el horario disponible apartir del turno del doctor
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
//Maneja el seleccionado de la fecha como solo solicitar con almenos 3 dias de anticipacion
  void _showAppointmentTimes(DateTime date) {
    DateTime now = DateTime.now();
    int differenceInDays = date.difference(now).inDays;
    if (differenceInDays >= 3) {
      setState(() {
        selectedDate = date;
        selectedAppointment = null;
        _generateAppointmentTimes();
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Fecha no disponible '),
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


  void _confirmAppointment() async {
    // Verificar si hay una fecha y una hora de cita seleccionada
    if (selectedDate != null && selectedAppointment != null) {
      try {
        // Verificar si el usuario está autenticado
        if (MongoDatabase.currentUser != null) {
          // Obtener el número de teléfono del usuario autenticado
          String telefono = MongoDatabase.currentUser!['Telefono'];

          // Crear el objeto de cita
          Map<String, dynamic> cita = {
            'doctorName': widget.doctor.name,
            'specialty': widget.doctor.specialty,
            'date': selectedDate!.toString(),
            'time': selectedAppointment!,
            'status': 'Activa',
          };

          // Guardar la cita para el usuario autenticado
          await MongoDatabase.guardarCitaPaciente(telefono, cita);

          // Mostrar un mensaje de éxito y redirigir a la pantalla de citas
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Cita Agendada'),
                content: Text('Tu cita ha sido agendada exitosamente.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo actual
                      Navigator.of(context).pop(); // Regresa a la pantalla anterior
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
          // Mostrar un mensaje de error si el usuario no está autenticado
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
        // Mostrar el mensaje de error en caso de que ya exista una cita activa en el mismo horario
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
      // Mostrar un mensaje de error si no se ha seleccionado una fecha o una hora de cita
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
