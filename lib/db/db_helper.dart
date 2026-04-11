import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contact.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'contacts.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contacts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            phone TEXT,
            email TEXT,
            nick TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('ALTER TABLE contact ADD COLUMN email TEXT');
        }
      },
    );
  }

  Future<int> insert(Contact contact) async {
    final dbClient = await db;
    return dbClient.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    final dbClient = await db;
    final maps = await dbClient.query('contacts');
    return maps.map((e) => Contact.fromMap(e)).toList();
  }

  Future<int> update(Contact contact) async {
    final dbClient = await db;
    return dbClient.update(
      'contacts',
      contact.toMap(),
      where: 'id=?',
      whereArgs: [contact.id],
    );
  }

  Future<int> delete(int id) async {
    final dbClient = await db;
    return dbClient.delete('contacts', where: 'id=?', whereArgs: [id]);
  }
}
