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
        CREATE TABLE Order_Table(
        order_id INTEGER PRIMARY KEY AUTOINCREMENT,
        token INTEGER,
        paid INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        payment_mode TEXT CHECK(payment_mode IN ('cash', 'qr')) DEFAULT NULL
        )
''');

        await db.execute('''
        CREATE TABLE Order_Product(
        order_product_id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER,
        product_id INTEGER,
        quantity INTEGER,
        price_at_order REAL,
        FOREIGN KEY(order_id) REFERENCES Order_Table(order_id),
        FOREIGN KEY(product_id) REFERENCES Inventory_Table(product_id)
        )
''');

        await db.execute('''
        CREATE TABLE Paid_Table (
        payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
        payment_date TEXT,
        order_id INTEGER,
        FOREIGN KEY(order_id) REFERENCES Order_Table(order_id)
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
      'Inventory_Table',
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
    if (maps.isNotEmpty) {
      return InventoryItem.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // ------------------ORDER FUNCTION------------------------

  // -----------------CREATE ORDER-----------------
  Future<int> createOrder({required int token}) async {
    final db = await database;
    return await db.insert('Order_Table', {
      'token': token,
      'paid': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // -----------------GET ALL ORDERS-----------------
  Future<void> setPaymentMethod(int orderId, String paymentMethod) async {
    final db = await database;
    await db.update(
      'Order_Table',
      {'payment_mode': paymentMethod},
      where: 'order_id = ?',
      whereArgs: [orderId],
    );
  }

  // -----------------GET ALL ORDERS-----------------
  Future<List<Map<String, dynamic>>> getAllOrders() async {
    final db = await database;
    return await db.query('Order_Table');
  }

  // -----------------GET ALL ORDERS-----------------
  Future<List<Map<String, dynamic>>> getAllTokens() async {
    final db = await database;
    return await db.rawQuery('''
  SELECT DISTINCT token FROM Order_Table ORDER BY token DESC
''');
  }

  // -----------------SEARCH TOKEN -----------------
  Future<List<Map<String, dynamic>>> searchTokens(String query) async {
    final db = await database;
    return await db.rawQuery(
      '''
      SELECT DISTINCT token FROM Order_Table 
      WHERE token LIKE ?
      ORDER BY token DESC
''',
      ['%$query%'],
    );
  }

  // -----------------GET ORDER BY TOKEN-----------------
  Future<List<Map<String, dynamic>>> getOrdersByToken(int token) async {
    final db = await database;
    return await db.query(
      'Order_Table',
      where: 'token = ?',
      whereArgs: [token],
      orderBy: 'created_at DESC',
    );
  }

  // -----------------AUTO TOKEN INCREMENT-----------------
  Future<int> getNextToken() async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT MAX(token) as max FROM Order_Table",
    );
    final maxToken = result.first['max'] as int?;
    return (maxToken ?? 100) + 1;
  }

  // -----------------DELETE TOKEN -----------------
  Future<void> deletToken(int token) async {
    final db = await database;

    // Get all orders from the token
    final orders = await db.query(
      'Order_Table',
      where: 'token = ?',
      whereArgs: [token],
    );

    for (final order in orders) {
      final orderId = order['order_id'] as int;
      // restore stock
      final items = await db.query(
        'Order_Product',
        where: 'order_id = ?',
        whereArgs: [orderId],
      );

      for (final item in items) {
        final productId = item['product_id'] as int;
        final quantity = item['quantity'] as int;

        await db.rawQuery(
          '''
          UPDATE Inventory_Table
          SET product_stock = product_stock + ?
          WHERE product_id = ?
          ''',
          [quantity, productId],
        );
      }

      // Delete from Order_Product
      await db.delete(
        'Order_Product',
        where: 'order_id = ?',
        whereArgs: [orderId],
      );

      // Delete From Paid Table
      await db.delete(
        'Paid_Table',
        where: 'order_id = ?',
        whereArgs: [orderId],
      );
    }

    // Delte From Order_Table
    await db.delete('Order_Table', where: 'token = ?', whereArgs: [token]);
  }

  // -----------------GET ALL PAID/UNPAID ORDER-----------------
  Future<List<Map<String, dynamic>>> getOrdersByPaidStatus(bool isPaid) async {
    final db = await database;
    return await db.query(
      'Order_Table',
      where: 'paid = ?',
      whereArgs: [isPaid ? 1 : 0],
    );
  }

  // -----------------GET ONE ORDER BY ID-----------------
  Future<Map<String, dynamic>?> getOrderByID(int orderId) async {
    final db = await database;
    final result = await db.query(
      'Order_Table',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // -----------------DELETE ORDER-----------------
  Future<void> deleteOrder(int orderId) async {
    final db = await database;

    //Get all item in order
    final items = await db.query(
      'Order_Product',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );

    // Restore Stock
    for (final item in items) {
      final productId = item['product_id'] as int;
      final quantity = item['quantity'] as int;

      await db.rawUpdate(
        '''
  UPDATE Inventory_Table
  SET product_stock = product_stock + ?
  WHERE product_id = ?
''',
        [quantity, productId],
      );
    }

    // Delete the order-product relation first
    await db.delete(
      'Order_Product',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );

    //Delete payment if Exists
    await db.delete('Paid_Table', where: 'order_id = ?', whereArgs: [orderId]);

    //Finally delete the order
    await db.delete('Order_Table', where: 'order_id = ?', whereArgs: [orderId]);
  }

  // -----------------INSERT ORDER-----------------
  Future<void> insertOrderProduct({
    required int orderId,
    required int productId,
    required int quantity,
    required double priceAtOrder,
  }) async {
    final db = await database;

    await db.insert("Order_Product", {
      "order_id": orderId,
      "product_id": productId,
      "quantity": quantity,
      'price_at_order': priceAtOrder,
    });

    // Decrease the stock in the Inventory_Table
    await db.rawUpdate(
      '''
    UPDATE Inventory_Table 
    SET product_stock = product_stock - ? 
      WHERE product_id = ?
''',
      [quantity, productId],
    );
  }

  // -----------------TOTAL PRICE ORDER-----------------
  Future<double> getOrderTotal(int orderId) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
    SELECT SUM(quantity * price_at_order) as total 
    FROM Order_Product 
    WHERE order_id = ?
''',
      [orderId],
    );
    return result.first['total'] != null
        ? result.first['total'] as double
        : 0.0;
  }

  // ------------------ORDER BY TIMESTAMP------------------------
  Future<List<Map<String, dynamic>>> getOrderByDateRange(
    String start,
    String end,
  ) async {
    final db = await database;

    return await db.rawQuery(
      '''
  SELECT * FROM Order_Table 
  WHERE created_at BETWEEN ? AND ?
''',
      [start, end],
    );
  }

  // -----------------PAID ORDER-----------------
  Future<void> markOrderAsPaid(int orderId) async {
    final db = await database;

    await db.update(
      'Order_Table',
      {"paid": 1},
      where: 'order_id =?',
      whereArgs: [orderId],
    );

    await db.insert("Paid_Table", {
      'order_id': orderId,
      'payment_date': DateTime.now().toIso8601String(),
    });
  }

  //
  Future<List<Map<String, dynamic>>> getOrderedItemByToken(int token) async {
    final db = await database;
    return await db.rawQuery(
      '''
      SELECT
      i.product_name,
      i.product_image,
      op.quantity,
      op.price_at_order
      FROM Order_Table o
      JOIN Order_Product op ON o.order_id = op.order_id
      JOIN Inventory_Table i ON i.product_id = op.product_id
      WHERE o.token = ?
      ''',
      [token],
    );
  }

  // -----------------UPDATE THE ORDER STATUS-----------------
  Future<void> updateOrderPaidStatus(int orderId, bool isPaid) async {
    final db = await database;

    await db.update(
      'Order_Table',
      {'paid': isPaid ? 1 : 0},
      where: 'order_id = ?',
      whereArgs: [orderId],
    );

    if (!isPaid) {
      //Option to delete the payment record
      await db.delete(
        'Paid_Table',
        where: 'order_id = ?',
        whereArgs: [orderId],
      );
    }
  }
}
