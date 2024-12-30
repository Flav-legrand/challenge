import 'package:flutter/material.dart';

class HistoriqueTest extends StatelessWidget {
  const HistoriqueTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final matieres = [
      {"nom": "SVT", "icone": Icons.biotech, "couleur": Colors.green, "statut": "reussi", "performance": 85},
      {"nom": "Math", "icone": Icons.calculate, "couleur": Colors.orange, "statut": "echoue", "performance": 45},
      {"nom": "Physique & Chimie", "icone": Icons.science, "couleur": Colors.blue, "statut": "aVenir", "performance": null},
      {"nom": "Histoire Géo", "icone": Icons.map, "couleur": Colors.brown, "statut": "reussi", "performance": 78},
      {"nom": "Philosophie", "icone": Icons.psychology, "couleur": Colors.purple, "statut": "aVenir", "performance": null},
      {"nom": "Français", "icone": Icons.book, "couleur": Colors.indigo, "statut": "echoue", "performance": 50},
      {"nom": "Espagnol", "icone": Icons.language, "couleur": Colors.redAccent, "statut": "reussi", "performance": 90},
      {"nom": "Informatique", "icone": Icons.computer, "couleur": Colors.teal, "statut": "reussi", "performance": 95},
      {"nom": "Education Physique", "icone": Icons.fitness_center, "couleur": Colors.deepOrange, "statut": "reussi", "performance": 88},
      {"nom": "Culture Générale", "icone": Icons.public, "couleur": Colors.cyan, "statut": "aVenir", "performance": null},
    ];

    final List<Map<String, String>> tests = List.generate(
      7,
          (index) => {
        "id": (index + 1).toString(),
        "name": "Test ${index + 1}",
        "score": "${50 + index * 10}/100",
        "matiere": matieres[index % matieres.length]["nom"] as String,
        "details": "Voici les détails complets pour le Test ${index + 1}.",
        "statut": matieres[index % matieres.length]["statut"].toString(),
        "performance": matieres[index % matieres.length]["performance"]?.toString() ?? "Non disponible",
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Historique des Tests',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: tests.length,
        itemBuilder: (context, index) {
          final test = tests[index];
          final matiere = matieres[index % matieres.length];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                leading: Icon(
                  matiere["icone"] as IconData,
                  color: matiere["couleur"] as Color,
                ),
                title: Text(
                  test["name"] ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                subtitle: Text(
                  "Matière : ${test["matiere"] ?? "Inconnue"}\nScore : ${test["score"] ?? "N/A"}",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                onTap: () => _showTestDetails(context, test, matiere),
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  void _showTestDetails(BuildContext context, Map<String, String> test, Map<String, dynamic> matiere) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                matiere["icone"] as IconData,
                size: 60,
                color: matiere["couleur"] as Color,
              ),
              const SizedBox(height: 10),
              Text(
                test["name"] ?? "Nom indisponible",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: matiere["couleur"] as Color,
                ),
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.grey[300]),
              _buildDetailRowWithIcon(Icons.info, 'ID du Test', test["id"] ?? "Inconnu"),
              _buildDetailRowWithIcon(Icons.library_books, 'Matière', test["matiere"] ?? "Inconnue"),
              _buildDetailRowWithIcon(Icons.score, 'Score', test["score"] ?? "N/A"),
              _buildDetailRowWithIcon(Icons.task_alt, 'Statut', test["statut"] ?? "Non défini"),
              const SizedBox(height: 20),
              const Text(
                "Détails supplémentaires :",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),

              Text(
                test["details"] ?? "Aucun détail disponible",
                style: const TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 10),
              // Section supplémentaire avec icônes ajoutées
              _buildDetailRowWithIcon(Icons.calendar_today, 'Trimestre concerné', '1er trimestre'), // Exemple de données
              const SizedBox(height: 10),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRowWithIcon(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
