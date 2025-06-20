import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fsc_management/models/inventory_item.dart';
import 'dart:convert';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;
  DbHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    return await _initDB();
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'restaurant_billing.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE inventory(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          price REAL,
          stock INTEGER,
          imagePath TEXT
          )
''');
        await db.execute('''
        CREATE TABLE paid_orders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        token INTEGER,
        items TEXT, --JSON
        total REAL,
        date TEXT
        )
''');
      },
    );
  }

  // Inventory Function
  Future<void> insertInventoryItem(
    InventoryItem item, {
    required String name,
    required double price,
    required int stock,
    String? imagePath,
  }) async {
    final db = await database;
    await db.insert(
      'inventory',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateInventoryItem(InventoryItem item) async {
    final db = await database;
    await db.update(
      'inventory',
      item.toMap(),
      where: 'id=?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteInventoryItem(int id) async {
    final db = await database;
    await db.delete('inventory', where: 'id=?', whereArgs: [id]);
  }

  Future<List<InventoryItem>> getAllIventoryItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('inventory');
    return maps.map((map) => InventoryItem.fromMap(map)).toList();
  }

  // Paid Orders
  Future<void> insertPaidOrder({
    required int token,
    required List<Map<String, dynamic>> items,
    required double total,
    required String date,
  }) async {
    final db = await database;
    await db.insert('paid_order', {
      'token': token,
      "items": jsonEncode(items),
      'total': total,
      'date': date,
    });
  }

  Future<List<Map<String, dynamic>>> getPaidOrdersByDate(String date) async {
    final db = await database;
    final result = await db.query(
      'paid_order',
      where: 'date =?',
      whereArgs: [date],
    );
    return result;
  }
}
