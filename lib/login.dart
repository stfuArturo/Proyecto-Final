import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mongodb.dart'; // Asumiendo que el archivo se llama mongo_database.dart

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String telefono = _phoneController.text;
    String contra = _passwordController.text;

    // Autenticar al usuario utilizando la clase MongoDatabase
    Map<String, dynamic>? user = await MongoDatabase.authenticateUser(telefono, contra);

    if (user != null) {
      // Usuario autenticado, navegar a la página de inicio
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Las credenciales son incorrectas, mostrar un mensaje de error
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error de inicio de sesión'),
            content: Text('Las credenciales ingresadas son incorrectas.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cerrar'),
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
        title: Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Número de Teléfono'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su número de teléfono';
                  } else if (value.length != 10) {
                    return 'El número de teléfono debe tener 10 dígitos';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Iniciar Sesión'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/crear-cuenta');
                },
                child: Text('Crear Cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
