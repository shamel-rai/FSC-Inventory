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
    final path = join(dbPath, 'family_sekuwa_corner.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Inventory_Table(
          product_id INTEGER PRIMARY KEY AUTOINCREMENT,
          product_name TEXT,
          product_price REAL,
          product_stock INTEGER,
          product_image TEXT
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

  // ------------------INVENTORY FUNCTION------------------------

  // ---------------CREATE INVENTORY-----------------------
  Future<void> insertInventoryItem(InventoryItem item) async {
    final db = await database;
    await db.insert(
      'Inventory_table',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ---------------READ INVENTORY-----------------------
  Future<List<InventoryItem>> getallInventoryItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("Inventory_Table");
    return maps.map((e) => InventoryItem.fromMap(e)).toList();
  }

  // ---------------DELETE INVENTORY-----------------------
  Future<void> deleteInventoryItem(int id) async {
    final db = await database;
    await db.delete(
      "Inventory_Table",
      where: "product_id = ?",
      whereArgs: [id],
    );
  }

  // ---------------UPDATE INVENTORY-----------------------
  Future<void> updateInventoryItem(InventoryItem item) async {
    final db = await database;
    await db.update(
      'Inventory_Table',
      item.toMap(),
      where: 'product_id=?',
      whereArgs: [item.id],
    );
  }

  // ---------------GET A SINGLE INVENTORY ITEM-----------------------
  Future<InventoryItem?> getInventoryItemById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "Inventory_Table",
      where: "product_id =?",
      whereArgs: [id],
      limit: 1,
    );
    return null;
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
