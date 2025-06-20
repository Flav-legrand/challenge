import 'package:flutter/material.dart';
import 'evaluation_page.dart'; // Importez la page EvaluationPage

class MatiereListChallengePage extends StatelessWidget {
  final String communityName;
  final int userId;

  const MatiereListChallengePage({Key? key, required this.communityName, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> matieres = [
      {
        "nom": "SVT",
        "icone": Icons.biotech,
        "couleur": Colors.green,
        "statut": "reussi",
        "performance": 85
      },
      {
        "nom": "Math",
        "icone": Icons.calculate,
        "couleur": Colors.orange,
        "statut": "echoue",
        "performance": 45
      },
      {
        "nom": "Physique & Chimie",
        "icone": Icons.science,
        "couleur": Colors.blue,
        "statut": "aVenir",
        "performance": null
      },
      {
        "nom": "Histoire Géo",
        "icone": Icons.map,
        "couleur": Colors.brown,
        "statut": "reussi",
        "performance": 78
      },
      {
        "nom": "Philosophie",
        "icone": Icons.psychology,
        "couleur": Colors.purple,
        "statut": "aVenir",
        "performance": null
      },
      {
        "nom": "Français",
        "icone": Icons.book,
        "couleur": Colors.indigo,
        "statut": "echoue",
        "performance": 50
      },
      {
        "nom": "Espagnol",
        "icone": Icons.language,
        "couleur": Colors.redAccent,
        "statut": "reussi",
        "performance": 90
      },
      {
        "nom": "Informatique",
        "icone": Icons.computer,
        "couleur": Colors.teal,
        "statut": "reussi",
        "performance": 95
      },
      {
        "nom": "Education Physique",
        "icone": Icons.fitness_center,
        "couleur": Colors.deepOrange,
        "statut": "reussi",
        "performance": 88
      },
      {
        "nom": "Culture Générale",
        "icone": Icons.public,
        "couleur": Colors.cyan,
        "statut": "aVenir",
        "performance": null
      },
    ];

    Color getStatusColor(String statut) {
      switch (statut) {
        case "reussi":
          return Colors.green;
        case "echoue":
          return Colors.red;
        case "aVenir":
          return Colors.grey;
        default:
          return Colors.blueAccent;
      }
    }

    String getDuration(String matiere) {
      final List<String> sciences = ["SVT", "Math", "Physique & Chimie"];
      return sciences.contains(matiere) ? "3h 00" : "2h 00";
    }

    String getPerformanceText(Map<String, dynamic> matiere) {
      return matiere["performance"] != null
          ? "${matiere["performance"]}%"
          : "À venir";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choix des matières (${communityName})',
          style: const TextStyle(color: Colors.white), // Titre en blanc
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme:
            const IconThemeData(color: Colors.white), // Bouton retour en blanc
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Rechercher une matière',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Liste des matières
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemCount: matieres.length,
                itemBuilder: (context, index) {
                  final matiere = matieres[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigation vers EvaluationPage avec l'attribut matiere
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EvaluationPage(matiere: matiere, userId: userId),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(matiere["icone"],
                              size: 40, color: matiere["couleur"]),
                          Text(
                            matiere["nom"],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "${getDuration(matiere["nom"])} | ${getPerformanceText(matiere)}",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: getStatusColor(matiere["statut"]),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
