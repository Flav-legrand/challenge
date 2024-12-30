import 'package:flutter/material.dart';

class MesCommunautesPage extends StatelessWidget {
  const MesCommunautesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Liste des communautés (mock data)
    final List<Map<String, dynamic>> communautes = [
      {
        "image": "https://via.placeholder.com/150",
        "nom": "Tech Innovators",
        "description": "Une communauté dédiée à l'innovation technologique.",
        "membres": ["Alice", "Bob", "Charlie", "Diane", "Edward", "Fiona", "George", "Hannah", "Ivy", "Jack"],
        "testsEffectues": 120,
        "testsReussis": 100,
        "testsManques": 20,
        "scoreGlobal": 85,
        "matieres": [
          {"nom": "Informatique", "performance": 90},
          {"nom": "Mathématiques", "performance": 85},
          {"nom": "Physique", "performance": 78},
          {"nom": "Chimie", "performance": 88},
          {"nom": "Anglais", "performance": 92},
          {"nom": "Français", "performance": 84},
          {"nom": "Biologie", "performance": 80},
          {"nom": "Histoire", "performance": 76},
        ],
      },
      {
        "image": "https://via.placeholder.com/150",
        "nom": "Eco Warriors",
        "description": "Pour les passionnés de l'environnement et de la durabilité.",
        "membres": ["Anna", "Brian", "Catherine", "David", "Eva", "Frank", "Gina", "Henry", "Isabelle", "James"],
        "testsEffectues": 180,
        "testsReussis": 160,
        "testsManques": 20,
        "scoreGlobal": 90,
        "matieres": [
          {"nom": "Biologie", "performance": 95},
          {"nom": "Chimie", "performance": 88},
          {"nom": "Géographie", "performance": 82},
          {"nom": "Physique", "performance": 85},
          {"nom": "Mathématiques", "performance": 90},
          {"nom": "Anglais", "performance": 87},
          {"nom": "Français", "performance": 80},
          {"nom": "Histoire", "performance": 83},
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mes Communautés',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white), // Bouton retour blanc
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: communautes.length,
        itemBuilder: (context, index) {
          final communaute = communautes[index];
          return _buildCommunauteCard(context, communaute);
        },
      ),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildCommunauteCard(BuildContext context, Map<String, dynamic> communaute) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(communaute["image"]),
                  radius: 35,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    communaute["nom"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              communaute["description"],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatTile("Membres", communaute["membres"].length.toString()),
                _buildStatTile("Tests effectués", communaute["testsEffectues"].toString()),
                _buildStatTile("Score global", "${communaute["scoreGlobal"]}%"),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return _buildDetailDialog(context, communaute);
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Voir les détails", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailDialog(BuildContext context, Map<String, dynamic> communaute) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: double.infinity,
        height: 500,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              communaute["nom"],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Membres
                    const Text(
                      "Membres",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    ...communaute["membres"].map<Widget>((membre) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text("- $membre", style: TextStyle(color: Colors.grey[800])),
                      );
                    }).toList(),
                    const Divider(),
                    // Matières et performances
                    const Text(
                      "Matières et Performances",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    ...communaute["matieres"].map<Widget>((matiere) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          "${matiere['nom']} : ${matiere['performance']}%",
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      );
                    }).toList(),
                    const Divider(),
                    // Autres statistiques
                    const Text(
                      "Statistiques générales",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text("Tests effectués : ${communaute["testsEffectues"]}"),
                    Text("Tests réussis : ${communaute["testsReussis"]}"),
                    Text("Tests manqués : ${communaute["testsManques"]}"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
