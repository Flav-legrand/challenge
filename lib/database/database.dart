import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static Database? _database;

  /// Récupère l’instance de la base de données (singleton).
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    // Initialisation pour desktop
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _database = await _initDatabase();
    return _database!;
  }

  /// Création des tables à la première ouverture.
  static Future<Database> _initDatabase() async {
    final path =
        join(await databaseFactory.getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE matieres (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            icon TEXT,
            color TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE tests (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titre TEXT NOT NULL,
            date TEXT NOT NULL,
            matiere_id INTEGER NOT NULL,
            FOREIGN KEY(matiere_id) REFERENCES matieres(id) ON DELETE CASCADE
          );
        ''');

        await db.execute('''
          CREATE TABLE test_questions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            test_id INTEGER NOT NULL,
            question TEXT NOT NULL,
            points INTEGER NOT NULL,
            FOREIGN KEY(test_id) REFERENCES tests(id) ON DELETE CASCADE
          );
        ''');

        await db.execute('''
          CREATE TABLE test_options (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            question_id INTEGER NOT NULL,
            option_text TEXT NOT NULL,
            is_correct BOOLEAN NOT NULL,
            FOREIGN KEY(question_id) REFERENCES test_questions(id) ON DELETE CASCADE
          );
        ''');

        await db.execute('''
          CREATE TABLE test_responses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            question_id INTEGER NOT NULL,
            response TEXT NOT NULL,
            is_correct BOOLEAN NOT NULL,
            FOREIGN KEY(question_id) REFERENCES test_questions(id) ON DELETE CASCADE
          );
        ''');

        await db.execute('''
          CREATE TABLE test_results (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            test_id INTEGER NOT NULL,
            score INTEGER NOT NULL,
            max_score INTEGER NOT NULL,
            date TEXT NOT NULL,
            FOREIGN KEY(test_id) REFERENCES tests(id) ON DELETE CASCADE
          );
        ''');
      },
    );
  }

  /// Renvoie l’ID d’une matière à partir de son titre, ou null si introuvable.
  Future<int?> getMatiereIdByTitle(String title) async {
    final db = await getDatabase();
    final rows = await db.query(
      'matieres',
      columns: ['id'],
      where: 'title = ?',
      whereArgs: [title],
      limit: 1,
    );
    if (rows.isNotEmpty) return rows.first['id'] as int;
    return null;
  }

  /// Insère un nouveau test et renvoie son ID auto-généré.
  Future<int> insertTest({
    required String titre,
    required String dateIso,
    required int matiereId,
  }) async {
    final db = await getDatabase();
    return await db.insert(
      'tests',
      {
        'titre': titre,
        'date': dateIso,
        'matiere_id': matiereId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Insère un score lié à un test existant.
  Future<void> insertScore({
    required int score,
    required int userId,
    required String date,
    required int testId,
    required int maxScore,
    required String testTitre,
    required dynamic widget,
  }) async {
    final db = await getDatabase();
    await db.insert(
      'test_results',
      {
        'user_id': userId,
        'score': score,
        'max_score': maxScore,
        'titre': testTitre,
        'description': 'titre',
        'matiere_id': testId,
        'date_creation': 'titre',
        'date_passed': 'titre',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Soumet un test complet : enregistre réponses, calcule et stocke le score.
  Future<void> submitTest({
    required int userId,
    required int testId,
    required Map<int, String> userResponses,
  }) async {
    final db = await getDatabase();
    int totalScore = 0;
    int maxScore = 0;

    for (final entry in userResponses.entries) {
      final qid = entry.key;
      final resp = entry.value;

      // Récupère l’option correcte
      final correct = await db.query(
        'test_options',
        where: 'question_id = ? AND is_correct = 1',
        whereArgs: [qid],
        limit: 1,
      );

      // Récupère les points de la question
      final q = await db.query(
        'test_questions',
        where: 'id = ?',
        whereArgs: [qid],
        limit: 1,
      );
      final pts = q.isNotEmpty ? q.first['points'] as int : 0;
      maxScore += pts;

      final isCorrect =
          correct.isNotEmpty && (correct.first['option_text'] == resp);
      if (isCorrect) totalScore += pts;

      // Enregistre la réponse
      await db.insert('test_responses', {
        'user_id': userId,
        'question_id': qid,
        'response': resp,
        'is_correct': isCorrect ? 1 : 0,
      });
    }

    // Enregistre le score final
    await insertScore(
      score: totalScore,
      userId: userId,
      date: DateTime.now().toIso8601String(),
      maxScore: maxScore,
      testId: testId,
      widget: null,
      testTitre: '',
    );
  }

  Future<List<Map<String, dynamic>>> getMatieres() async {
    final db = await getDatabase();
    return await db.query('matieres'); // Récupère toutes les matières
  }

   Future<bool> checkUser(String email, String password) async {
    final dbClient = await getDatabase();
    final res = await dbClient.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return res.isNotEmpty;
  }

  Future<Map<String, dynamic>?> getUserByEmailAndPassword(String email, String password) async {
    final dbClient = await getDatabase();
    final res = await dbClient.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }

  Future<Map<String, int>> getTestSuccessStats(int userId) async {
    final db = await DatabaseHelper.getDatabase();
    // On considère la moyenne à 50% du max_score
    final results = await db.query(
      'test_results',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    int success = 0;
    int fail = 0;
    for (final row in results) {
      final score = row['score'] as int;
      final maxScore = row['max_score'] as int;
      if (maxScore == 0) continue;
      if (score >= (maxScore / 2)) {
        success++;
      } else {
        fail++;
      }
    }
    return {'success': success, 'fail': fail};
  }
}
