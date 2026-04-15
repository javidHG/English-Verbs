import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/verb.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'english_verbs.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE verbs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        base_form TEXT NOT NULL,
        past_simple TEXT NOT NULL,
        past_participle TEXT NOT NULL,
        meaning TEXT,
        example TEXT,
        notes TEXT,
        is_favorite INTEGER DEFAULT 0,
        is_irregular INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    final seedVerbs = [
      {'base': 'be',    'ps': 'was/were', 'pp': 'been',    'meaning': 'ser / estar'},
      {'base': 'have',  'ps': 'had',      'pp': 'had',     'meaning': 'tener'},
      {'base': 'do',    'ps': 'did',      'pp': 'done',    'meaning': 'hacer'},
      {'base': 'go',    'ps': 'went',     'pp': 'gone',    'meaning': 'ir'},
      {'base': 'get',   'ps': 'got',      'pp': 'gotten',  'meaning': 'obtener / conseguir'},
      {'base': 'make',  'ps': 'made',     'pp': 'made',    'meaning': 'hacer / crear'},
      {'base': 'know',  'ps': 'knew',     'pp': 'known',   'meaning': 'saber / conocer'},
      {'base': 'think', 'ps': 'thought',  'pp': 'thought', 'meaning': 'pensar'},
      {'base': 'take',  'ps': 'took',     'pp': 'taken',   'meaning': 'tomar / llevar'},
      {'base': 'see',   'ps': 'saw',      'pp': 'seen',    'meaning': 'ver'},
      {'base': 'come',  'ps': 'came',     'pp': 'come',    'meaning': 'venir'},
      {'base': 'give',  'ps': 'gave',     'pp': 'given',   'meaning': 'dar'},
      {'base': 'find',  'ps': 'found',    'pp': 'found',   'meaning': 'encontrar'},
      {'base': 'speak', 'ps': 'spoke',    'pp': 'spoken',  'meaning': 'hablar'},
      {'base': 'write', 'ps': 'wrote',    'pp': 'written', 'meaning': 'escribir'},
      {'base': 'read',  'ps': 'read',     'pp': 'read',    'meaning': 'leer'},
      {'base': 'run',   'ps': 'ran',      'pp': 'run',     'meaning': 'correr'},
      {'base': 'eat',   'ps': 'ate',      'pp': 'eaten',   'meaning': 'comer'},
      {'base': 'drink', 'ps': 'drank',    'pp': 'drunk',   'meaning': 'beber'},
      {'base': 'sleep', 'ps': 'slept',    'pp': 'slept',   'meaning': 'dormir'},
    ];

    for (final v in seedVerbs) {
      await db.insert('verbs', {
        'base_form':      v['base'],
        'past_simple':    v['ps'],
        'past_participle':v['pp'],
        'meaning':        v['meaning'],
        'is_irregular':   1,
        'is_favorite':    0,
        'created_at':     DateTime.now().toIso8601String(),
      });
    }
  }

  Future<int> insertVerb(Verb verb) async {
    final db = await database;
    return await db.insert('verbs', verb.toMap());
  }

  Future<int> updateVerb(Verb verb) async {
    final db = await database;
    return await db.update(
      'verbs', verb.toMap(),
      where: 'id = ?', whereArgs: [verb.id],
    );
  }

  Future<int> deleteVerb(int id) async {
    final db = await database;
    return await db.delete('verbs', where: 'id = ?', whereArgs: [id]);
  }

  // Dedicated method — only flips is_favorite, never touches other columns.
  // This is the safe way to toggle favorites without any risk of data loss.
  Future<int> setFavorite(int id, bool value) async {
    final db = await database;
    return await db.update(
      'verbs',
      {'is_favorite': value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Verb>> getAllVerbs({String orderBy = 'base_form ASC'}) async {
    final db = await database;
    final maps = await db.query('verbs', orderBy: orderBy);
    return maps.map((m) => Verb.fromMap(m)).toList();
  }

  Future<List<Verb>> searchVerbs(String query) async {
    final db = await database;
    final q = '%${query.toLowerCase().trim()}%';
    final maps = await db.query(
      'verbs',
      where: 'base_form LIKE ? OR past_simple LIKE ? OR past_participle LIKE ? OR meaning LIKE ?',
      whereArgs: [q, q, q, q],
      orderBy: 'base_form ASC',
    );
    return maps.map((m) => Verb.fromMap(m)).toList();
  }

  Future<int> getVerbCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM verbs');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
