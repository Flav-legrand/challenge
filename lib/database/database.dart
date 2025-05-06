import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static Database? _database;

  // Method to get the database instance
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    // Initialize for desktop/test environments (non-mobile)
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<void> insertMatieres(String title, IconData icon, Color color) async {
    final db = await getDatabase();
    await db.insert(
      'matieres',
      {
        'title': title,
        'icon': icon.codePoint, // Store icon code point
        'color': color.value, // Store color as integer
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create tables
        await db.execute('''
          CREATE TABLE matieres (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            icon TEXT,
            color TEXT
          )
        ''');

        // Add initial data
        await db.insert('matieres',
            {'title': 'Math', 'icon': 'calculate', 'color': 'blue'});
        await db.insert('matieres',
            {'title': 'Physics', 'icon': 'science', 'color': 'deepPurple'});
        await db.execute('''
          CREATE TABLE devoirs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titre TEXT NOT NULL,
            statut TEXT NOT NULL,
            trimestre TEXT NOT NULL,
            matiere_id INTEGER NOT NULL,
            FOREIGN KEY (matiere_id) REFERENCES matieres (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  // Méthode pour récupérer tous les devoirs
  Future<List<Map<String, dynamic>>> getDevoirs() async {
    final db = await getDatabase();
    return await db.query('devoirs');
  }

  // Méthode pour insérer un devoir
  Future<void> insertDevoir(
      String titre, String statut, String trimestre, int matiereId) async {
    final db = await getDatabase();
    await db.insert(
      'devoirs',
      {
        'titre': titre,
        'statut': statut,
        'trimestre': trimestre,
        'matiere_id': matiereId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Méthode pour récupérer les matières en fonction du trimestre et du titre des devoirs
  Future<List<Map<String, dynamic>>> fetchMatieresByDevoirs(
      String trimestre, String titre) async {
    final db = await getDatabase();

    // Requête SQL pour récupérer les matières associées aux devoirs
    final result = await db.rawQuery('''
      SELECT matieres.*
      FROM matieres
      INNER JOIN devoirs ON matieres.id = devoirs.matiere_id
      WHERE devoirs.trimestre = ? AND devoirs.titre = ?
    ''', [trimestre, titre]);

    return result;
  }

  Future<List<Map<String, dynamic>>> getMatieres() async {
    final db = await getDatabase();
    return await db.query('matieres'); // Récupère toutes les matières
  }
  // Autres méthodes d'insertion et de récupération des devoirs...
}
