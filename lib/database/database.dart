import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  // Obtenir une instance de la base de données
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    // Initialiser sqflite pour les environnements desktop
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _database = await _initDatabase();
    return _database!;
  }

  // Initialisation de la base de données
  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'challenger.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON'); // Activer les clés étrangères
      },
      onCreate: (db, version) async {
        // Création des tables
        await db.execute('''
          CREATE TABLE IF NOT EXISTS matieres (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            icon TEXT,
            color TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS devoirs (
            id INTEGER PRIMARY KEY,
            titre TEXT NOT NULL,
            statut TEXT,
            trimestre TEXT,
            matiere_id INTEGER,
            FOREIGN KEY (matiere_id) REFERENCES matieres (id)
          );
        ''');


        // Création de la table "evaluation_partie_I"
        await db.execute('''
        CREATE TABLE IF NOT EXISTS verification (
            id INTEGER PRIMARY KEY,                          
            question TEXT NOT NULL,                          
            options TEXT NOT NULL,                           
            reponse TEXT NOT NULL,                           
            reponse_id INTEGER NOT NULL,                     
            matiere_id INTEGER NOT NULL,                    
            devoir_id INTEGER NOT NULL,                      
            trimestre TEXT NOT NULL,                         
            FOREIGN KEY (matiere_id) REFERENCES matieres (id),
            FOREIGN KEY (devoir_id) REFERENCES devoirs (id)
        );

        ''');


        // Insérer les données par défaut dans "matieres"
        await db.insert('matieres', {'id': 1, 'title': 'Math', 'icon': 'calculate', 'color': 'blue'});
        await db.insert('matieres', {'id': 2, 'title': 'Physique & Chimie', 'icon': 'science', 'color': 'deepPurple'});
        await db.insert('matieres', {'id': 3, 'title': 'SVT', 'icon': 'grass', 'color': 'green'});
        await db.insert('matieres', {'id': 4, 'title': 'Histoire & Géo', 'icon': 'public', 'color': 'orange'});
        await db.insert('matieres', {'id': 5, 'title': 'Informatique', 'icon': 'computer', 'color': 'cyan'});
        await db.insert('matieres', {'id': 6, 'title': 'Philosophie', 'icon': 'psychology', 'color': 'yellow'});
        await db.insert('matieres', {'id': 7, 'title': 'Anglais', 'icon': 'language', 'color': 'red'});
        await db.insert('matieres', {'id': 8, 'title': 'Arts Plastiques', 'icon': 'design', 'color': 'pink'});
        await db.insert('matieres', {'id': 9, 'title': 'Français', 'icon': 'book', 'color': 'teal'});
        await db.insert('matieres', {'id': 10, 'title': 'Musique', 'icon': 'music', 'color': 'purple'});
        await db.insert('matieres', {'id': 11, 'title': 'Chimie', 'icon': 'flask', 'color': 'lime'});
        await db.insert('matieres', {'id': 12, 'title': 'Sport', 'icon': 'fitness_center', 'color': 'brown'});
        await db.insert('matieres', {'id': 13, 'title': 'Economie', 'icon': 'balance', 'color': 'green'});
        await db.insert('matieres', {'id': 14, 'title': 'Espagnol', 'icon': 'book', 'color': 'yellow'});


        // Insérer les données par défaut dans "devoirs"
        await db.insert('devoirs', {'id': 1, 'titre': 'Devoir n°1', 'statut': 'aVenir', 'trimestre': 'Trimestre I', 'matiere_id': 1});
        await db.insert('devoirs', {'id': 2, 'titre': 'Devoir n°2', 'statut': 'aVenir', 'trimestre': 'Trimestre I', 'matiere_id': 1});
        await db.insert('devoirs', {'id': 3, 'titre': 'Examen trimestriel', 'statut': 'aVenir', 'trimestre': 'Trimestre I', 'matiere_id': 1});
        await db.insert('devoirs', {'id': 4, 'titre': 'Devoir n°2', 'statut': 'reussi', 'trimestre': 'Trimestre I', 'matiere_id': 2});
        await db.insert('devoirs', {'id': 5, 'titre': 'Devoir n°1', 'statut': 'echoue', 'trimestre': 'Trimestre I', 'matiere_id': 2});
        await db.insert('devoirs', {'id': 6, 'titre': 'Examen trimestriel', 'statut': 'aVenir', 'trimestre': 'Trimestre II', 'matiere_id': 2});
        await db.insert('devoirs', {'id': 7, 'titre': 'Devoir n°1', 'statut': 'aVenir', 'trimestre': 'Trimestre II', 'matiere_id': 3});
        await db.insert('devoirs', {'id': 8, 'titre': 'Examen trimestriel', 'statut': 'aVenir', 'trimestre': 'Trimestre II', 'matiere_id': 3});


        // Insérer les données par défaut dans "evaluation_parte_I"
        await db.insert('verification', {
          'id': 1,
          'question': 'Quels sont les organes reproducteurs mâles ?',
          'options': '["Testicules", "Ovaires", "Utérus", "Trompes"]',
          'reponse': 'Testicules',
          'reponse_id': 0,
          'matiere_id': 3,
          'devoir_id': 7,
          'trimestre': 'Trimestre I'
        });

        await db.insert('verification', {
          'id': 2,
          'question': 'Quelle est la cellule reproductrice mâle ?',
          'options': '["Zygote", "Spermatozoïde", "Ovule", "Embryon"]',
          'reponse': 'Spermatozoïde',
          'reponse_id': 1,
          'matiere_id': 3,
          'devoir_id': 7,
          'trimestre': 'Trimestre I'
        });

        await db.insert('verification', {
          'id': 3,
          'question': 'Quel est le rôle principal des testicules ?',
          'options': '["Produire des spermatozoïdes", "Produire de la progestérone", "Assurer la fécondation", "Produire des ovocytes"]',
          'reponse': 'Produire des spermatozoïdes',
          'reponse_id': 0,
          'matiere_id': 3,
          'devoir_id': 7,
          'trimestre': 'Trimestre I'
        });

        await db.insert('verification', {
          'id': 4,
          'question': 'Comment appelle-t-on la fusion d’un spermatozoïde et d’un ovule ?',
          'options': '["Meiosis", "Différenciation", "Mitosis", "Fécondation"]',
          'reponse': 'Fécondation',
          'reponse_id': 3,
          'matiere_id': 3,
          'devoir_id': 7,
          'trimestre': 'Trimestre I'
        });

        await db.insert('verification', {
          'id': 5,
          'question': 'Où se déroule la spermatogenèse ?',
          'options': '["Dans les trompes", "Dans l’utérus", "Dans les ovaires", "Dans les tubes séminifères"]',
          'reponse': 'Dans les tubes séminifères',
          'reponse_id': 3,
          'matiere_id': 3,
          'devoir_id': 7,
          'trimestre': 'Trimestre I'
        });
        await db.insert('verification', {
          'id': 6,
          'question': 'Quelle hormone est produite par les testicules ?',
          'options': '["Oestrogène", "Progestérone", "Testostérone", "LH"]',
          'reponse': 'Testostérone',
          'reponse_id': 2,
          'matiere_id': 3,
          'devoir_id': 7,
          'trimestre': 'Trimestre I'
        });

      },
    );
  }


  // Méthode pour récupérer toutes les matières
  Future<List<Map<String, dynamic>>> getAllMatieres() async {
    final db = await getDatabase();
    return await db.query('matieres');
  }

  // Méthode pour récupérer tous les devoirs
  Future<List<Map<String, dynamic>>> getAllDevoirs() async {
    final db = await getDatabase();
    return await db.query('devoirs');
  }

  // Méthode pour récupérer tous les QCM de evaluation Partie I
  Future<List<Map<String, dynamic>>> getAllQuestionsPartI() async {
    final db = await getDatabase();
    return await db.query('verification');
  }
}
