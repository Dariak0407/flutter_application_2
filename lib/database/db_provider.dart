import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'equation_model.dart';

class DBProvider {
  // Singleton pattern
  static final DBProvider _instance = DBProvider._internal();
  factory DBProvider() => _instance;
  DBProvider._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'equation_calculations.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE calculations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        a REAL NOT NULL,
        b REAL NOT NULL,
        c REAL NOT NULL,
        equation_string TEXT NOT NULL,
        discriminant REAL NOT NULL,
        solution_type TEXT NOT NULL,
        roots TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  // CRUD операции

  Future<int> insertCalculation(EquationCalculation calc) async {
    final db = await database;
    return await db.insert('calculations', calc.toMap());
  }

  Future<List<EquationCalculation>> getAllCalculations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = 
        await db.query('calculations', orderBy: 'created_at DESC');
    
    return List.generate(maps.length, (i) {
      return EquationCalculation.fromMap(maps[i]);
    });
  }

  Future<EquationCalculation?> getCalculationById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'calculations',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return EquationCalculation.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateCalculation(EquationCalculation calc) async {
    final db = await database;
    return await db.update(
      'calculations',
      calc.toMap(),
      where: 'id = ?',
      whereArgs: [calc.id],
    );
  }

  Future<int> deleteCalculation(int id) async {
    final db = await database;
    return await db.delete(
      'calculations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllCalculations() async {
    final db = await database;
    await db.delete('calculations');
  }
}