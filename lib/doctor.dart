import 'package:flutter/material.dart';
import 'mongodb.dart';
import 'DoctorProfilePage.dart';

class DoctoresPage extends StatefulWidget {
  @override
  _DoctoresPageState createState() => _DoctoresPageState();
}

class _DoctoresPageState extends State<DoctoresPage> {
  String? selectedSpecialty;
  List<String> specialties = [];
  List<Map<String, dynamic>> doctorsList = [];
  List<Map<String, dynamic>> filteredDoctorsList = [];

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final doctors = await MongoDatabase.getAllDoctors();
      setState(() {
        doctorsList = doctors;
        filteredDoctorsList = doctors;
        specialties = doctors.map((doctor) => doctor['Especialidad'] as String).toSet().toList();
      });
    } catch (error) {
      print('Error fetching doctors: $error');
    }
  }

  void filterDoctors() {
    setState(() {
      if (selectedSpecialty == null) {
        filteredDoctorsList = doctorsList;
      } else {
        filteredDoctorsList = doctorsList
            .where((doctor) => doctor['Especialidad'] == selectedSpecialty)
            .toList();
      }
    });
  }

  void clearFilter() {
    setState(() {
      selectedSpecialty = null;
      filteredDoctorsList = doctorsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Doctores'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_off),
            onPressed: clearFilter,
            tooltip: 'Desactivar Filtro',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.filter_list),
                  SizedBox(width: 8),
                  DropdownButton<String>(
                    hint: Text('Selecciona una especialidad'),
                    value: selectedSpecialty,
                    onChanged: (newValue) {
                      setState(() {
                        selectedSpecialty = newValue;
                        filterDoctors();
                      });
                    },
                    items: specialties.map((specialty) {
                      return DropdownMenuItem<String>(
                        value: specialty,
                        child: Text(specialty),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDoctorsList.length,
              itemBuilder: (context, index) {
                final doctorData = filteredDoctorsList[index];
                final doctor = Doctor(
                  name: doctorData['Nombre'] ?? 'Nombre no disponible',
                  specialty: doctorData['Especialidad'] ?? 'Especialidad no disponible',
                  turnoEntrada: doctorData['Turno']['Entrada'],
                  turnoSalida: doctorData['Turno']['Salida'],
                  imageUrl: doctorData['Imagen'] ?? 'https://th.bing.com/th/id/OIP.fxtxjVWAcfYVZztO8OI4qAAAAA?rs=1&pid=ImgDetMain',
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
                        Text('Turno: ${doctor.turnoEntrada} - ${doctor.turnoSalida}'),
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
          ),
        ],
      ),
    );
  }
}
