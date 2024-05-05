import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/provider/login_state.dart';
import 'package:expenseapp/utils/utils.dart';
import 'package:expenseapp/widgets/month_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/year_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController();
  int currentPage = DateTime.now().month - 1;
  GraphType currentType = GraphType.PIE;
  Stream<QuerySnapshot> _query = const Stream.empty();

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: currentPage,
      viewportFraction: 0.35,
    );
  }

  Widget _bottomAction(IconData icon, Function callback) {
    return InkWell(
      onTap: callback as void Function()?,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, size: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
      builder: (BuildContext context, LoginState state, Widget? child) {
        var user = Provider.of<LoginState>(context, listen: false).currentUser;
        _query = FirebaseFirestore.instance
            .collection("users")
            .doc(user)
            .collection('expenses')
            .where("month", isEqualTo: currentPage + 1)
            .where("year",
                isEqualTo:
                    Provider.of<YearState>(context, listen: false).currentYear)
            .snapshots();
        return Scaffold(
          bottomNavigationBar: BottomAppBar(
            notchMargin: 8.0,
            shape: const CircularNotchedRectangle(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _bottomAction(FontAwesomeIcons.chartLine, () {
                  setState(() {
                    currentType = GraphType.LINES;
                  });
                }),
                _bottomAction(FontAwesomeIcons.chartPie, () {
                  setState(() {
                    currentType = GraphType.PIE;
                  });
                }),
                const SizedBox(width: 32.0),
                _bottomAction(FontAwesomeIcons.calendar, () {
                  Navigator.of(context).pushNamed('/changeYear');
                }),
                _bottomAction(Icons.exit_to_app, () {
                  Provider.of<LoginState>(context, listen: false).logOut();
                }),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/add');
            },
            backgroundColor: Colors.blue,
            shape: const CircleBorder(),
            child: const Icon(Icons.add),
          ),
          body: _body(),
        );
      },
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _selector(),
          StreamBuilder(
              stream: _query,
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
                if (data.hasData) {
                  return MonthWidget(
                    days: daysInMonth(currentPage + 1),
                    documents: data.data!.docs,
                    graphType: currentType,
                    month: currentPage,
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              })
        ],
      ),
    );
  }

  Widget _pageItem(String name, int position) {
    Alignment aligment;
    const selected = TextStyle(
      color: Colors.blueGrey,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );

    final unselected = TextStyle(
      color: Colors.blueGrey.withOpacity(0.4),
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
    );

    if (position == currentPage) {
      aligment = Alignment.center;
    } else if (position > currentPage) {
      aligment = Alignment.centerRight;
    } else {
      aligment = Alignment.centerLeft;
    }
    return Align(
      alignment: aligment,
      child: Text(
        name,
        style: position == currentPage ? selected : unselected,
      ),
    );
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: const Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (newPage) {
          setState(() {
            var user =
                Provider.of<LoginState>(context, listen: false).currentUser;
            currentPage = newPage;
            Provider.of<YearState>(context, listen: false)
                .setCurrentMonth(currentPage + 1);

            _query = FirebaseFirestore.instance
                .collection("users")
                // .doc(user.uid)
                .doc(user)
                .collection('expenses')
                .where("month", isEqualTo: currentPage + 1)
                .where("year",
                    isEqualTo: Provider.of<YearState>(context, listen: false)
                        .currentYear)
                .snapshots();
          });
        },
        controller: _pageController,
        children: <Widget>[
          _pageItem("Enero", 0),
          _pageItem("Febrero", 1),
          _pageItem("Marzo", 2),
          _pageItem("Abril", 3),
          _pageItem("Mayo", 4),
          _pageItem("Junio", 5),
          _pageItem("Julio", 6),
          _pageItem("Agosto", 7),
          _pageItem("Septiembre", 8),
          _pageItem("Octubre", 9),
          _pageItem("Noviembre", 10),
          _pageItem("Diciembre", 11),
        ],
      ),
    );
  }
}
