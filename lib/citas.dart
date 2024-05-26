import 'package:flutter/material.dart';
import 'mongodb.dart';

class CitasPage extends StatefulWidget {
  @override
  _CitasPageState createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  late List<Map<String, dynamic>> citas = [];

  @override
  void initState() {
    super.initState();
    _loadCitas();
  }

  Future<void> _loadCitas() async {
    if (MongoDatabase.currentUser != null) {
      String telefono = MongoDatabase.currentUser!['Telefono'];
      List<Map<String, dynamic>> userCitas = await MongoDatabase.recuperarCitasPaciente(telefono);
      setState(() {
        citas = userCitas;
      });
    }
  }

  Future<void> cancelAppointment(Map<String, dynamic> appointment) async {
    try {
      await MongoDatabase.cancelarCitaPaciente(
        MongoDatabase.currentUser!['Telefono'],
        appointment,
      );
      // Actualizar la lista de citas después de la cancelación
      _loadCitas();
    } catch (e) {
      print('Error al cancelar la cita en la base de datos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cancelar la cita. Por favor, inténtalo de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Citas'),
      ),
      body: citas.isEmpty
          ? Center(child: Text('No hay citas disponibles'))
          : ListView.builder(
        itemCount: citas.length,
        itemBuilder: (context, index) {
          final appointment = citas[index];
          String? formattedDate;
          if (appointment['date'] != null) {
            String rawDate = appointment['date'];
            DateTime parsedDate = DateTime.parse(rawDate);
            formattedDate = '${parsedDate.year}-${parsedDate.month}-${parsedDate.day}';
          } else {
            formattedDate = 'Fecha no disponible';
          }
          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: EdgeInsets.all(12.0),
              title: Text('${appointment['doctorName']} - ${appointment['specialty']}'),
              subtitle: Text('$formattedDate a las ${appointment['time']}'),
              trailing: appointment['status'] == 'Activa'
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
