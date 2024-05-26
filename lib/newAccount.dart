import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mongodb.dart';

class CrearCuentaPage extends StatefulWidget {
  @override
  _CrearCuentaPageState createState() => _CrearCuentaPageState();
}

class _CrearCuentaPageState extends State<CrearCuentaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  Future<void> _crearCuenta() async {
    if (_formKey.currentState!.validate()) {
      String nombre = _nombreController.text;
      String telefono = _telefonoController.text;
      String contra = _contrasenaController.text;

      // Verificar si el número de teléfono ya está registrado
      bool isRegistered = await MongoDatabase.isPhoneRegistered(telefono);
      if (isRegistered) {
        // Mostrar un mensaje de error si el número de teléfono ya está registrado
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error al crear cuenta'),
              content: Text('El número de teléfono ya está registrado.'),
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
      } else {
        // Guardar la nueva cuenta en la base de datos
        await MongoDatabase.guardarNuevaCuenta(nombre, telefono, contra);
        // Redirigir al usuario a la pantalla de inicio de sesión
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Cuenta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
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
                controller: _contrasenaController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _crearCuenta,
                child: Text('Crear Cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
