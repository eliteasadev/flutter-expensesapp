import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/pages/details_page.dart';
import 'package:expenseapp/widgets/graph_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum GraphType { LINES, PIE }

class MonthWidget extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final List<double> perDay;
  final double total;
  final Map<String, double> categories;
  final GraphType graphType;
  final int month;

  MonthWidget(
      {super.key,
      required this.documents,
      days,
      required this.graphType,
      required this.month})
      : total = documents.map((doc) => doc["value"]).fold(0.0, (a, b) => a + b),
        perDay = List.generate(days, (int index) {
          return documents
              .where((doc) => doc["day"] == index + 1)
              .map((doc) => doc["value"])
              .fold(0.0, (a, b) => a + b);
        }),
        categories = documents.fold({}, (Map<String, double> map, document) {
          if (!map.containsKey(document['category'])) {
            map[document['category']] = 0.0;
          }
          map[document['category']] =
              map[document['category']]! + document['value'];
          return map;
        });

  @override
  _MonthWidgetState createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          _expenses(),
          _graph(),
          Container(
            color: Colors.blueAccent.withOpacity(0.15),
            height: 16.0,
          ),
          _list(),
        ],
      ),
    );
  }

  Widget _expenses() {
    return Column(
      children: <Widget>[
        Text(
          "\$${widget.total.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "Gastos totales",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _graph() {
    if (widget.graphType == GraphType.LINES) {
      return SizedBox(
        height: 250.0,
        child: LinesGraphWidget(
          data: widget.perDay,
        ),
      );
    } else {
      var perCategory = widget.categories.keys
          .map((name) => widget.categories[name]! / widget.total);
      return SizedBox(
        height: 250.0,
        child: PieGraphWidget(
          data: perCategory.toList(),
        ),
      );
    }
  }

  Widget _item(IconData icon, String name, int percent, double value) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed('/details',
            arguments: DetailsParams(name, widget.month));
      },
      leading: Icon(icon, size: 32.0),
      title: Text(name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          )),
      subtitle: Text("$percent% de los gastos",
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.blueGrey,
          )),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "\$$value",
            style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w500,
                fontSize: 18.0),
          ),
        ),
      ),
    );
  }

  Widget _list() {
    return Expanded(
      child: ListView.separated(
        itemCount: widget.categories.keys.length,
        itemBuilder: (BuildContext context, int index) {
          var key = widget.categories.keys.elementAt(index);
          var data = widget.categories[key];
          return _item(FontAwesomeIcons.bagShopping, key,
              100 * data! ~/ widget.total, data);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.blueAccent.withOpacity(0.15),
            height: 8.0,
          );
        },
      ),
    );
  }
}
