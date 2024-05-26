import 'package:flutter/material.dart';
import 'mongodb.dart';
import 'DoctorProfilePage.dart';




class DoctoresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: MongoDatabase.getAllDoctors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Lista de Doctores'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Lista de Doctores'),
            ),
            body: Center(child: Text('Error al cargar los doctores')),
          );
        } else {
          List<Map<String, dynamic>> doctorsList = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Lista de Doctores'),
            ),
            body: ListView.builder(
              itemCount: doctorsList.length,
              itemBuilder: (context, index) {
                final doctorData = doctorsList[index];
                final doctor = Doctor(
                  name: doctorData['Nombre'] ?? 'Nombre no disponible',
                  specialty: doctorData['Especialidad'] ?? 'Especialidad no disponible',
                  turnoEntrada: doctorData['Turno']['Entrada'],
                  turnoSalida: doctorData['Turno']['Salida'],
                  imageUrl: doctorData['Imagen'] ?? '',
                );


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
                        Text('Especialidad: ${doctor.specialty}'),
                        SizedBox(height: 5),
                        Text('Turno: ${doctorData['Turno']['Entrada']} - ${doctorData['Turno']['Salida']}'),
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
      },
    );
  }
}
