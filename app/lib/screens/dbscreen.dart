import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import '../db/dbmanager.dart';

class DBRoute extends StatefulWidget {
  @override
  _DBRouteState createState() => _DBRouteState();
}

class _DBRouteState extends State<DBRoute> {
  final DBItemManager dbmanager = new DBItemManager();

  final _nameController = TextEditingController();
  final _amountController =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final _categoryController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  Item item;
  List<Item> itemList = [];
  int updateIndex;

  Widget _buildForm(double width) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: <Widget>[
        TextFormField(
          decoration: new InputDecoration(labelText: 'Item Name:'),
          controller: _nameController,
          validator: (val) =>
              val.isNotEmpty ? null : 'Item Name should not be empty!',
        ),
        TextFormField(
          decoration: new InputDecoration(labelText: 'Item Category:'),
          controller: _categoryController,
          validator: (val) =>
              val.isNotEmpty ? null : 'Item Category should not be empty!',
        ),
        TextFormField(
          decoration: new InputDecoration(labelText: 'Money Spent:'),
          controller: _amountController,
          keyboardType: TextInputType.number,
          validator: (val) =>
              val.isNotEmpty ? null : 'Money Spent should not be empty!',
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
            _submitItem(context);
          },
        ),
      ]),
    );
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
                key: _formKey,
                child: _buildForm(width),
              ),
              FutureBuilder(
                  future: dbmanager.getItems(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Item>> snapshot) {
                    if (snapshot.hasData) {
                      itemList = snapshot.data;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: itemList == null ? 0 : itemList.length,
                          itemBuilder: (BuildContext context, int index) {
                            Item it = itemList[index];
                            return Card(
                                child: Row(
                              children: <Widget>[
                                Container(
                                    width: width * 0.6,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Name: ${it.name}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Spent: \$${it.amount}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.red[600]),
                                          ),
                                          Text(
                                            'Category: ${it.category}',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ])),
                                IconButton(
                                  onPressed: () {
                                    _nameController.text = it.name;
                                    _amountController.text =
                                        it.amount.toString();
                                    _categoryController.text = it.category;

                                    item = it;
                                    updateIndex = index;
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    dbmanager.deleteItem(it.id);
                                    setState(() {
                                      itemList.removeAt(index);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ));
                          });
                    }
                    return new CircularProgressIndicator();
                  })
            ]),
      ),
    );
  }

  void _submitItem(BuildContext context) {
    if (_formKey.currentState.validate()) {
      if (item == null) {
        Item it = new Item(
            name: _nameController.text,
            amount: _amountController.numberValue,
            category: _categoryController.text);

        dbmanager.insertItem(it).then((id) => {
              _nameController.clear(),
              _amountController.clear(),
              _categoryController.clear(),
              print('Item added to DB. ID: $id')
            });
      } else {
        item.name = _nameController.text;
        item.amount = _amountController.numberValue;
        item.category = _categoryController.text;

        dbmanager.updateItem(item).then((id) => {
              setState(() {
                itemList[updateIndex].name = _nameController.text;
                itemList[updateIndex].amount = _amountController.numberValue;
                itemList[updateIndex].category = _categoryController.text;
              }),
              _nameController.clear(),
              _amountController.clear(),
              _categoryController.clear(),
              item = null
            });
      }
    }
  }
}
