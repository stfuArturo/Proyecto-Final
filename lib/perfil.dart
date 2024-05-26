import 'package:flutter/material.dart';
import 'mongodb.dart';
import 'login.dart';

class PerfilPage extends StatelessWidget {
  Future<Map<String, dynamic>?> _loadUserProfile() async {
    // Simular una carga de datos, puedes reemplazar esto con una llamada real a la base de datos si es necesario
    await Future.delayed(Duration(seconds: 2));
    return MongoDatabase.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _loadUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Cambia 'Colors.blue' por el color que prefieras
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar el perfil.'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('No se encontraron datos de perfil.'),
            );
          } else {
            final user = snapshot.data!;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://th.bing.com/th/id/OIP.fxtxjVWAcfYVZztO8OI4qAAAAA?rs=1&pid=ImgDetMain',
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Nombre: ${user['Nombre'] ?? ''}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Teléfono: ${user['Telefono'] ?? ''}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        // Limpiar la variable currentUser
                        MongoDatabase.currentUser = null;
                        // Redirigir al usuario a la pantalla de inicio de sesión
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                              (route) => false,
                        );
                      },
                      child: Text('Cerrar Sesión'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
