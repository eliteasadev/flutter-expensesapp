import 'package:firebase_auth/firebase_auth.dart';

int daysInMonth(int month) {
  var now = DateTime.now();
  var lastDayDateTime = (month < 12)
      ? DateTime(now.year, month + 1, 0)
      : DateTime(now.year + 1, 1, 0);
  return lastDayDateTime.day;
}

bool isValidYear(String anioStr) {
  if (anioStr.isEmpty) {
    // Si el campo está vacío, no es un año válido
    return false;
  }
  // Intentamos convertir el valor del campo a un entero
  try {
    int anio = int.parse(anioStr);
    // Verificamos si el año está dentro de un rango razonable
    return anio >= 1980 && anio <= 3000;
  } catch (e) {
    // Si no se puede convertir a un número, no es un año válido
    return false;
  }
}

bool isValidName(String nombre) {
  return nombre.length > 3 && RegExp(r'^[a-zA-Z]+$').hasMatch(nombre);
}

// Inicia sesión en firebase 
Future<bool> firebaseLoggin(String emailAddress, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);
  } on FirebaseAuthException catch (e) {
    return false;
  }
  return true;
}

// Crea un usuario nuevo en la base de datos de firebase
Future<bool> firebaseSignIn(String emailAddress, String password) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
    return false;
  } catch (e) {
    print(e);
    return false;
  }
  return true;
}
