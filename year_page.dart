import 'package:expenseapp/provider/year_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class YearPage extends StatefulWidget {
  const YearPage({super.key});

  @override
  State<YearPage> createState() => _YearPageState();
}

class _YearPageState extends State<YearPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Año actual ${Provider.of<YearState>(context, listen: false).currentYear.toString()}",
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Expanded(
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Container(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText:
                            'Introduce el año con el que quieras trabajar',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),
                      ],
                    ),
                  )),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                if (isValidYear(_controller.text)) {
                  int year = int.parse(_controller.text);
                  Provider.of<YearState>(context, listen: false)
                      .setCurrentYear(year);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ingresa un año valido'),
                    ),
                  );
                }
              },
              child: const Text("Asignar año"),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
