// Set how much money you're budgeting
// Set how much you want to save (will turn red once it goes below saved amount)
// Shared Preferences

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import '../main.dart';
import '../db/sharedpref.dart';

List<GlobalKey<FormState>> _formKey = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

class BudgetRoute extends StatefulWidget {
  @override
  _BudgetRouteState createState() => _BudgetRouteState();
}

class _BudgetRouteState extends State<BudgetRoute> {
  final _budgetController =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final _goalController =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');

  Widget _buildBudgetForm(double width) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          TextFormField(
            decoration: new InputDecoration(
                labelText: 'How much money are you budgeting?'),
            controller: _budgetController,
            keyboardType: TextInputType.number,
            validator: (val) =>
                val.isNotEmpty ? null : 'This field should not be empty!',
          ),
          RaisedButton(
              textColor: Colors.white,
              color: Colors.blueAccent,
              child: Container(
                  width: width * 0.9,
                  child: Text(
                    'Submit',
                    textAlign: TextAlign.center,
                  )),
              onPressed: () {
                double val = _budgetController.numberValue;
                SharedPrefUtils.savePrefVal('budget', val);
              }),
        ]));
  }

  Widget _buildGoalForm(double width) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          TextFormField(
            decoration: new InputDecoration(labelText: 'What is your goal?'),
            controller: _goalController,
            keyboardType: TextInputType.number,
            validator: (val) =>
                val.isNotEmpty ? null : 'This field should not be empty!',
          ),
          RaisedButton(
              textColor: Colors.white,
              color: Colors.blueAccent,
              child: Container(
                  width: width * 0.9,
                  child: Text(
                    'Submit',
                    textAlign: TextAlign.center,
                  )),
              onPressed: () {
                double val = _goalController.numberValue;
                SharedPrefUtils.savePrefVal('goal', val);
              }),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
            child: ListView(
                padding: EdgeInsets.symmetric(vertical: 30.0),
                children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 120.0),
            child: Text(
              'What would you like to add?',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Form(
            key: _formKey[0],
            child: _buildBudgetForm(width),
          ),
          Form(
            key: _formKey[1],
            child: _buildGoalForm(width),
          ),
          RaisedButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ));
              })
        ])));
  }
}
