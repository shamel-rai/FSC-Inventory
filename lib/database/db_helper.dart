import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await initDB();
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'management.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Inventory tabel
        await db.execute('''
      CREATE TABLE inventory (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price REAL,
        stock INTEGER, 
        imagePath TEXT
      )
    ''');
      },
    );
  }

  // Inventory CRUD

  Future<void> addProduct({
    required String name,
    required double price,
    required int stock,
    String? imagePath,
  }) async {
    final db = await database;
    await db.insert('inventory', {
      'name': name,
      'price': price,
      'stock': stock,
      'imagePath': imagePath,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await database;
    return await db.query('inventory');
  }

  Future<void> updateProduct({
    required int id,
    required String name,
    required double price,
    required int stock,
    String? imagePath,
  }) async {
    final db = await database;
    await db.update(
      'inventory',
      {'name': name, 'price': price, 'stock': stock, 'imagePath': imagePath},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteProduct(int id) async {
    final db = await database;
    await db.delete('inventory', where: 'id=?', whereArgs: [id]);
  }

  // billing on hold
}
