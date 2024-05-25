import 'dart:convert';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

Future<void> start() async {
  final db = await Db.create('mongodb+srv://ray:0B2Dl3Qh6qSY5FoW@cluster0.b8qccfv.mongodb.net/prueba?retryWrites=true&w=majority');

  await db.open();
  final coll = db.collection('users');

  print(await coll.find().toList());

  const port = 8081;

  // Crear un manejador de solicitudes de Shelf
  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(_echoRequest);

  // Iniciar el servidor HTTP
  var server = await io.serve(handler, InternetAddress.anyIPv4, port);
  print('Server listening on port ${server.port}');
}

// Función que maneja las solicitudes HTTP y devuelve la lista de usuarios
Future<shelf.Response> _echoRequest(shelf.Request request) async {
  final db = await Db.create('mongodb+srv://ray:0B2Dl3Qh6qSY5FoW@cluster0.b8qccfv.mongodb.net/prueba?retryWrites=true&w=majority');

  await db.open();
  final coll = db.collection('users');

  // Obtener la lista de usuarios desde la base de datos
  final users = await coll.find().toList();

  // Convertir la lista de usuarios a JSON
  final jsonResponse = jsonEncode({'users': users});

  // Devolver una respuesta HTTP con el JSON
  return shelf.Response.ok(jsonResponse,
      headers: {'Content-Type': 'application/json'});
}

void main() {
  start();
}
