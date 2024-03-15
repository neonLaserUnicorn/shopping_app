import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final int version = 1;
  Database? db;

  Future<Database?> openDb() async {
    db ??= await openDatabase(join(await getDatabasesPath(), 'shopping.db'),
        onCreate: (db_, version) {
      db_.execute(
          'CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)');
      db_.execute(
          'CREATE TABLE items(id INTEGER PRIMARY KEY, listId INTEGER, name TEXT, quantity TEXT, note TEXT, ' +
              ' FOREIGN KEY(listId) REFERENCES lists(id))');
    }, version: version);
    return db;
  }

  Future testDb() async {
    db = await openDb();
    await db!.execute('INSERT INTO lists VALUES (1, "Groceries", 1)');
    await db!.execute(
        'INSERT INTO items VALUES (0, 1, "Apples", "2kg", "Red apples")');
    List lists = await db!.rawQuery('SELECT * FROM lists');
    List items = await db!.rawQuery('SELECT * FROM items');
    print(lists[0].toString());
    print(items[0].toString());
  }
}
