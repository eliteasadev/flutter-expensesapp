import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginState with ChangeNotifier {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  bool _loggedIn = false;
  bool _loading = true;
  String _user = '';

  // Propiedades públicas para acceder al estado
  String get currentUser => _user;

  bool get isLoggedIn => _loggedIn;

  bool get isLoading => _loading;

  LoginState() {
    _initializeLoginState();
  }

  /// Inicializa el estado de login verificando si el usuario ya está almacenado.
  Future<void> _initializeLoginState() async {
    _user = await storage.read(key: 'username') ?? '';
    _loggedIn = _user.isNotEmpty;
    _loading = false;
    notifyListeners();
  }

  /// Guarda el nombre de usuario en el almacenamiento seguro y actualiza el estado.
  Future<void> logIn(String email) async {
    _loading = true;
    notifyListeners();

    await storage.write(key: 'username', value: email);
    _user = await storage.read(key: 'username') ?? 'N/A';

    _loading = false;
    _loggedIn = true;
    notifyListeners();
  }

  /// Cierra la sesión del usuario actual.
  Future<void> logOut() async {
    _loading = true;
    notifyListeners();

    await FirebaseAuth.instance.signOut();
    await storage.deleteAll();

    _user = '';
    _loggedIn = false;
    _loading = false;
    notifyListeners();
  }
}
