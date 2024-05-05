import 'package:expenseapp/provider/login_state.dart';
import 'package:expenseapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
      body: Expanded(
        child: Center(
            child: Consumer<LoginState>(
          builder: (BuildContext context, LoginState value, Widget? child) {
            if (value.isLoading) {
              return const CircularProgressIndicator();
            } else {
              return child!;
            }
          },
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Bienvenido",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Container(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Introduce el correo',
                        ),
                        controller: _controllerEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    )),
              ),
              Container(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: TextField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'Introduce la contraseña',
                        ),
                        controller: _controllerPassword,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text('Registrar'),
                      onPressed: () async {
                        if (await firebaseSignIn(
                            _controllerEmail.text, _controllerPassword.text)) {
                          Provider.of<LoginState>(context, listen: false)
                              .logIn(_controllerEmail.text);
                        } else {
                          setState(() {
                            _controllerPassword.text = "";
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No se ha registrado al usuario'),
                              ),
                            );
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      child: const Text('Iniciar sesión'),
                      onPressed: () async {
                        if (await firebaseLoggin(
                            _controllerEmail.text, _controllerPassword.text)) {
                          Provider.of<LoginState>(context, listen: false)
                              .logIn(_controllerEmail.text);
                        } else {
                          setState(() {
                            _controllerPassword.text = "";
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Correo o contraseña incorrecta.'),
                              ),
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
