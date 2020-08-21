import 'package:flutter/material.dart';
import './screens/dbscreen.dart';
import './screens/setvalues.dart';
import './db/sharedpref.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF3EBACE),
        accentColor: Color(0xFFD8ECF1),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: Center(
            child: Column(children: [
          FutureBuilder(
              future: SharedPrefUtils.getPrefVal('budget'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                      'Budgeted Amount: ' + snapshot.data.toStringAsFixed(2));
                }
                return CircularProgressIndicator();
              }),
          FutureBuilder(
              future: SharedPrefUtils.getPrefVal('goal'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Goal: ' + snapshot.data.toStringAsFixed(2));
                }
                return CircularProgressIndicator();
              }),
          RaisedButton(
            child: Text('To DB Page'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DBRoute()),
              );
            },
          ),
          RaisedButton(
            child: Text('To Set Budget'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BudgetRoute()),
              );
            },
          )
        ])));
  }
}
