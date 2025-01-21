import 'package:challenger/database/database.dart';

class MatiereController {
  // Tableau pour stocker les matières récupérées
  List<Map<String, dynamic>> matieres = [];

  // Méthode pour charger les matières depuis la base de données
  Future<void> loadMatieres() async {
    // Appeler la méthode getAllMatieres() pour récupérer les matières
    matieres = await DatabaseHelper().getAllMatieres();
  }
}

class DevoirController {
  // Tableau pour stocker les matières récupérées
  List<Map<String, dynamic>> devoirs = [];

  // Méthode pour charger les matières depuis la base de données
  Future<void> loadDevoirs() async {
    // Appeler la méthode getAllMatieres() pour récupérer les matières
    devoirs = await DatabaseHelper().getAllDevoirs();
  }
}

class QuestionController {
  // Tableau pour stocker les questions formatées
  List<Map<String, dynamic>> formattedQuestions = [];

  // Méthode pour charger et formater les questions depuis la base de données
  Future<void> loadAndFormatQuestions() async {
    print("maman !");
    // Récupération des questions brutes depuis la base de données
    List<Map<String, dynamic>> rawQuestions = await DatabaseHelper().getAllQuestionsPartI();
    print("papa !");

    // Vérifie les données brutes récupérées
    print("Données brutes récupérées : $rawQuestions");

    // Formater les questions
    formattedQuestions = rawQuestions.map((question) {
      return {
        "question": question['question'],
        "options": [
          question['option1'],
          question['option2'],
          question['option3'],
          question['option4']
        ],
        "correctIndex": question['correctIndex'],
        "points": question['points']
      };
    }).toList();

    // Afficher les questions formatées pour vérification
    print("Questions formatées : $formattedQuestions");
  }


  // Méthode pour obtenir les questions formatées
  List<Map<String, dynamic>> getFormattedQuestions() {
    return formattedQuestions;
  }
}

