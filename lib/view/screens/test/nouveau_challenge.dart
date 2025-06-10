import 'package:flutter/material.dart';
// Assurez-vous d'importer correctement la page `matiere_list_challenge.dart`.
import 'matiere_list_challenge.dart';

class NouveauChallengePage extends StatelessWidget {
  final int userId;
  const NouveauChallengePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Liste fictive des communautés (à remplacer par des données dynamiques)
    final List<Map<String, String>> communities = [
      {'name': 'Les Déterminés', 'rank': '1ère place', 'members': '2000 membres'},
      {'name': 'Les Innovateurs', 'rank': '2ème place', 'members': '1500 membres'},
      {'name': 'Les Visionnaires', 'rank': '3ème place', 'members': '1200 membres'},
      {'name': 'Les Leaders', 'rank': '4ème place', 'members': '1000 membres'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nouveau challenge',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // Bouton retour en blanc
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Message d'en-tête
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1), // Bloc transparent
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.public, size: 40, color: Colors.blueAccent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Relevez de nouveaux défis en groupe et progressez dans le classement !',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Liste des communautés
            ...communities.map((community) {
              return _buildCommunityCard(context, community);
            }).toList(),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildCommunityCard(BuildContext context, Map<String, String> community) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.group, color: Colors.white),
        ),
        title: Text(
          community['name'] ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          community['rank'] ?? '',
          style: const TextStyle(color: Colors.black54),
        ),
        trailing: const Icon(Icons.arrow_forward, color: Colors.blueAccent),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatiereListChallengePage(
                communityName: community['name'] ?? '',
                userId: userId, // Passe le vrai userId ici
              ),
            ),
          );
        },
      ),
    );
  }
}
