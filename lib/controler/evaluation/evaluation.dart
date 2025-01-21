import 'package:flutter/material.dart'; // Pour IconData et Color
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Matiere {
  final int id;
  final String title;
  final String icon; // Icon sous forme de chaîne (par exemple, un nom d'icône)
  final String color; // Couleur sous forme de chaîne HEX

  Matiere({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'color': color,
    };
  }

  factory Matiere.fromMap(Map<String, dynamic> map) {
    return Matiere(
      id: map['id'],
      title: map['title'],
      icon: map['icon'],
      color: map['color'],
    );
  }
}

class Devoir {
  final int id;
  final String titre;
  final String statut;
  final int matiereId;

  Devoir({
    required this.id,
    required this.titre,
    required this.statut,
    required this.matiereId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'statut': statut,
      'matiere_id': matiereId,
    };
  }

  factory Devoir.fromMap(Map<String, dynamic> map) {
    return Devoir(
      id: map['id'],
      titre: map['titre'],
      statut: map['statut'],
      matiereId: map['matiere_id'],
    );
  }
}

class EvaluationController {
  Database? _database;

  Future<void> initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    _database = await openDatabase(path, version: 1);
  }


  Future<Database> get database async {
    if (_database == null) {
      await initDatabase();
    }
    return _database!;
  }

  Future<List<Matiere>> fetchAllMatieres() async {
    final db = await database;


    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM matieres');
    print("Toutes les matières dans la base : $result");


    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM matieres');
    print("resutltat matiere nouv ------------------------------ $maps");
    return maps.map((map) => Matiere.fromMap(map)).toList();
  }

  Future<List<Devoir>> fetchAllDevoirs() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('devoirs');
    print("resutltat devoir ------------------------------ $maps");
    return maps.map((map) => Devoir.fromMap(map)).toList();
  }

  Future<void> insertMatiere(Matiere matiere) async {
    final db = await database;
    await db.insert('matieres', matiere.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertDevoir(Devoir devoir) async {
    final db = await database;
    await db.insert('devoirs', devoir.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
