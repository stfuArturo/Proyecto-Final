import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consultorio Médico',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CONSULTORIO MÉDICO'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Doctores',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                DoctorCard(
                  name: 'Dr. Selina Zamora',
                  specialty: 'Pediatra',
                  location: 'Centro Médico San José',
                  imageUrl: 'assets/doctor1.png',
                ),
                DoctorCard(
                  name: 'Dr. Anthony Fauci',
                  specialty: 'Cardiólogo',
                  location: 'Centro Médico San José',
                  imageUrl: 'assets/doctor2.png',
                ),
                DoctorCard(
                  name: 'Dr. Dionneary García',
                  specialty: 'Medicina General',
                  location: 'Centro Médico San José',
                  imageUrl: 'assets/doctor3.png',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/doctors_group.png'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Consultorio Médico',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text('Agendar'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Mi citas'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Sign In'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.app_registration),
              title: Text('Sign Up'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String location;
  final String imageUrl;

  DoctorCard({
    required this.name,
    required this.specialty,
    required this.location,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(imageUrl),
        title: Text(name),
        subtitle: Text('$specialty\n$location'),
        isThreeLine: true,
      ),
    );
  }
}
