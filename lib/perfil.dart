import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://th.bing.com/th/id/OIP.audMX4ZGbvT2_GJTx2c4GgHaHw?rs=1&pid=ImgDetMain'),
            ),
            SizedBox(height: 20),
            Text(
              'Raymundo Torres Velazquez',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '4813900670',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes implementar la lógica para cerrar sesión
              },
              child: Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
