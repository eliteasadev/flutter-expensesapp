import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/provider/login_state.dart';
import 'package:expenseapp/provider/year_state.dart';
import 'package:expenseapp/widgets/category_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String category = '';
  int value = 0;
  var realValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(
          'Categoría',
          style: TextStyle(
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
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        _categorySelector(),
        _currentValue(),
        _numberPad(),
        _submit(),
      ],
    );
  }

  Widget _categorySelector() {
    return SizedBox(
      height: 80.0,
      child: CategorySelectorWidget(
        categories: Map<String, IconData>.from(
          {
            'Compras': Icons.shopping_cart,
            'Alcohol': Icons.local_bar,
            'Comida': FontAwesomeIcons.burger,
            'Facturas': FontAwesomeIcons.moneyBill,
          },
        ),
        onValueChanged: (newCategory) {
          category = newCategory;
        },
      ),
    );
  }

  Widget _currentValue() {
    realValue = value / 100;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Text(
        '\$${realValue.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 50.0,
          fontWeight: FontWeight.w500,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _num(String text, double height) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          if (text == '00') {
            value = value * 100;
          }
          value = value * 10 + int.parse(text);
        });
      },
      child: SizedBox(
        height: height,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 40.0,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _numberPad() {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          var height = constraints.maxHeight / 4;
          return Table(
            border: TableBorder.all(
              color: Colors.grey,
              width: 1.0,
            ),
            children: [
              TableRow(
                children: [
                  _num('1', height),
                  _num('2', height),
                  _num('3', height),
                ],
              ),
              TableRow(
                children: [
                  _num('4', height),
                  _num('5', height),
                  _num('6', height),
                ],
              ),
              TableRow(
                children: [
                  _num('7', height),
                  _num('8', height),
                  _num('9', height),
                ],
              ),
              TableRow(
                children: [
                  _num('00', height),
                  _num('0', height),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        value = value ~/ 10;
                      });
                    },
                    child: SizedBox(
                      height: height,
                      child: const Center(
                        child: Icon(
                          Icons.backspace,
                          size: 40.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _submit() {
    return Container(
      height: 50.0,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: MaterialButton(
        child: const Text(
          'Agregar Gasto',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        onPressed: () {
          var user =
              Provider.of<LoginState>(context, listen: false).currentUser;
          var year = Provider.of<YearState>(context, listen: false).currentYear;
          var month =
              Provider.of<YearState>(context, listen: false).currentMonth;

          if (value > 0 && category.isNotEmpty) {
            FirebaseFirestore.instance
                .collection("users")
                .doc(user)
                .collection("expenses")
                .add({
              "category": category,
              "value": realValue,
              "month": month,
              "day": DateTime.now().day,
              "year": year,
            });
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Selecciona una categoria'),
              ),
            );
          }
        },
      ),
    );
  }
}
