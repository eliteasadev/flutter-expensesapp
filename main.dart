import 'package:expenseapp/pages/add_page.dart';
import 'package:expenseapp/pages/details_page.dart';
import 'package:expenseapp/pages/home_page.dart';
import 'package:expenseapp/pages/login_page.dart';
import 'package:expenseapp/pages/year_page.dart';
import 'package:expenseapp/provider/login_state.dart';
import 'package:expenseapp/provider/year_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

// ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => LoginState()),
        ChangeNotifierProvider(create: (BuildContext context) => YearState()),
      ],
      child: MaterialApp(
        title: 'Expenses App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          if (settings.name == '/details') {
            DetailsParams? params = settings.arguments as DetailsParams?;
            return MaterialPageRoute(
              builder: (context) =>
                  DetailsPage(params: params as DetailsParams),
            );
          }
        },
        routes: {
          '/': (BuildContext context) {
            if (Provider.of<LoginState>(context).isLoggedIn) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          },
          '/add': (context) => const AddPage(),
          '/changeYear': (context) => const YearPage(),
        },
      ),
    );
  }
}
