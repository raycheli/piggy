import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBItemManager {
  Database _database;

  Future openDB() async {
    if (_database == null) {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'item_database.db'),
        onCreate: (Database db, int version) async {
          await db.execute(
            "CREATE TABLE items(id INTEGER PRIMARY KEY autoincrement, name TEXT, amount DECIMAL(19,4), category TEXT)",
          );
        },
        version: 1,
      );
    }
  }

  // Create
  Future<int> insertItem(Item item) async {
    await openDB();
    return await _database.insert('items', item.toMap());
  }

  // Read
  Future<List<Item>> getItems() async {
    await openDB();
    final List<Map<String, dynamic>> maps = await _database.query('items');
    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i]['id'],
        name: maps[i]['name'],
        amount: maps[i]['amount'],
        category: maps[i]['category'],
      );
    });
  }

  // Update
  Future<int> updateItem(Item item) async {
    await openDB();
    return await _database
        .update('items', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  // Delete
  Future<void> deleteItem(int id) async {
    await openDB();
    await _database.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}

// Item Model
class Item {
  int id;
  String name;
  var amount;
  String category;

  Item(
      {@required this.name,
      @required this.amount,
      @required this.category,
      this.id});

  Map<String, dynamic> toMap() {
    return {'name': name, 'amount': amount, 'category': category};
  }
}
