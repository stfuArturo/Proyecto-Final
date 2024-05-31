import 'package:mongo_dart/mongo_dart.dart';
import 'prueba.dart';

class MongoDatabase {
  static Db? db;
  static DbCollection? doctorCollection;
  static DbCollection? patientCollection;
  static Map<String, dynamic>? currentUser;

  static Future<void> connect() async {
    try {
      print('Connecting to MongoDB...');
      db = await Db.create(MONGO_CONN_URL);
      await db!.open();
      print('Connected to MongoDB');
      doctorCollection = db!.collection(DOCTORS_COLLECTION);
      patientCollection = db!.collection(PATIENTS_COLLECTION);
    } catch (e) {
      print('Error connecting to MongoDB: $e');
    }
  }

  // Obtener lista de los doctores
  static Future<List<Map<String, dynamic>>> getAllDoctors() async {
    final doctors = await doctorCollection!.find().toList();
    return doctors.map((doctor) => doctor as Map<String, dynamic>).toList();
  }

  // Método para verificar las credenciales del usuario
  static Future<Map<String, dynamic>?> authenticateUser(
      String telefono, String contra) async {
    final patientQuery = where.eq('Telefono', telefono).eq('Contra', contra);
    final patient = await patientCollection!.findOne(patientQuery);
    if (patient != null) {
      currentUser = patient;
      return patient;
    }

    return null;
  }

  // Método para verificar si un número de teléfono ya está registrado
  static Future<bool> isPhoneRegistered(String telefono) async {
    final patientQuery = where.eq('Telefono', telefono);
    final patient = await patientCollection!.findOne(patientQuery);
    if (patient != null) {
      return true;
    }

    return false;
  }

  // Método para guardar una nueva cuenta de paciente en la base de datos
  static Future<bool> guardarNuevaCuenta(
      String nombre, String telefono, String contra) async {
    // Verificar si el número de teléfono ya está registrado
    bool isRegistered = await isPhoneRegistered(telefono);
    if (isRegistered) {
      // Retornar false si el número de teléfono ya está registrado
      return false;
    }

    Map<String, dynamic> nuevoPaciente = {
      'Nombre': nombre,
      'Telefono': telefono,
      'Contra': contra,
    };

    // Insertar el nuevo paciente en la colección de pacientes
    await patientCollection!.insertOne(nuevoPaciente);
    return true;
  }

  static Future<void> guardarCitaPaciente(
      String telefono, Map<String, dynamic> cita) async {
    try {
      final patientQuery = where.eq('Telefono', telefono);
      final paciente = await patientCollection!.findOne(patientQuery);
      if (paciente != null) {
        final citasActivasConMismoDoctor = await doctorCollection!
            .find(
              where
                  .eq('Nombre', cita['doctorName'])
                  .eq('Citas.Paciente', paciente['Nombre'])
                  .eq('Citas.status', 'Activa'),
            )
            .toList();

        if (citasActivasConMismoDoctor.isNotEmpty) {
          throw 'El paciente ya tiene una cita activa con este doctor.';
        }
        final citasEnMismoHorario = await doctorCollection!
            .find(
              where
                  .eq('Nombre', cita['doctorName'])
                  .eq('Citas.Fecha', cita['date'])
                  .eq('Citas.Hora', cita['time'])
                  .eq('Citas.status', 'Activa'),
            )
            .toList();
        if (citasEnMismoHorario.isEmpty) {
          await patientCollection!.update(
            patientQuery,
            modify.addToSet(
                'Citas', cita),
            upsert: true,
          );
          String doctorName = cita['doctorName'];
          await doctorCollection!.update(
            where.eq('Nombre', doctorName),
            modify.push('Citas', {
              'Fecha': cita['date'],
              'Hora': cita['time'],
              'Paciente': paciente['Nombre'],
              'status':
                  'Activa',
            }),
          );
        } else {
          throw 'Ya hay una cita activa para ese doctor en el mismo horario.';
        }
      } else {
        throw 'Paciente no encontrado.';
      }
    } catch (e) {
      print('Error al guardar la cita del paciente: $e');
      throw 'Horario no disponible';
    }
  }

  // Método para verificar si la hora seleccionada está disponible para el doctor
  Future<bool> _checkAppointmentAvailability(
      String doctorName, DateTime date, String time) async {
    final citasEnMismoHorario = await MongoDatabase.doctorCollection!
        .find(
          where
              .eq('Nombre', doctorName)
              .eq('Citas.Fecha', date.toString())
              .eq('Citas.Hora', time)
              .eq('Citas.status', 'Activa'),
        )
        .toList();
    return citasEnMismoHorario.isEmpty;
  }

  static Future<void> cancelarCitaPaciente(
      String telefono, Map<String, dynamic> cita) async {
    try {
      final paciente =
          await patientCollection!.findOne(where.eq('Telefono', telefono));
      if (paciente != null) {
        List<dynamic> citas = paciente['Citas'];
        for (var i = 0; i < citas.length; i++) {
          if (citas[i]['date'] == cita['date'] &&
              citas[i]['time'] == cita['time'] &&
              citas[i]['status'] == 'Activa') {
            citas[i]['status'] = 'Cancelada';
            await patientCollection!.update(
                where.eq('Telefono', telefono), modify.set('Citas', citas));
            String doctorName = citas[i]['doctorName'];
            await doctorCollection!.update(
              where.eq('Nombre', doctorName),
              modify.pull('Citas', {
                'Fecha': cita['date'],
                'Hora': cita['time'],
                'Paciente': paciente['Nombre'],
              }),
            );
            break;
          }
        }
      } else {
        throw 'Paciente no encontrado.';
      }
    } catch (e) {
      print('Error al cancelar la cita en la base de datos: $e');
      throw 'Error al cancelar la cita en la base de datos. Por favor, inténtalo de nuevo.';
    }
  }

  // Método para recuperar las citas de un paciente
  static Future<List<Map<String, dynamic>>> recuperarCitasPaciente(
      String telefono) async {
    final patientQuery = where.eq('Telefono', telefono);
    final paciente = await patientCollection!.findOne(patientQuery);

    if (paciente != null) {
      return List<Map<String, dynamic>>.from(paciente['Citas'] ?? []);
    } else {
      return [];
    }
  }

  // Método para obtener las franjas horarias no disponibles para un doctor en una fecha específica
  static Future<List<String>> obtenerCitasDisponibles(
      String doctorName, String fecha) async {
    try {
      final doctor =
          await doctorCollection!.findOne(where.eq('Nombre', doctorName));
      if (doctor != null) {
        final citas = doctor['Citas'] ?? [];
        List<String> horariosNoDisponibles = [];
        for (var cita in citas) {
          if (cita['Fecha'] == fecha && cita['status'] == 'Activa') {
            horariosNoDisponibles.add(cita['Hora']);
          }
        }
        return horariosNoDisponibles;
      } else {
        return [];
      }
    } catch (e) {
      print('Error al obtener citas disponibles: $e');
      return [];
    }
  }
}
