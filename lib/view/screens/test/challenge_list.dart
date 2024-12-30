import 'package:flutter/material.dart';

class ChallengeListPage extends StatefulWidget {
  const ChallengeListPage({Key? key}) : super(key: key);

  @override
  State<ChallengeListPage> createState() => _ChallengeListPageState();
}

class _ChallengeListPageState extends State<ChallengeListPage> {
  int? _expandedCommunityIndex; // Index de la communauté actuellement dépliée

  @override
  Widget build(BuildContext context) {
    final communities = [
      {"nom": "Développeurs", "icone": Icons.code},
      {"nom": "Designers", "icone": Icons.design_services},
      {"nom": "Entrepreneurs", "icone": Icons.business},
      {"nom": "Photographes", "icone": Icons.camera_alt},
      {"nom": "Artistes", "icone": Icons.brush},
      {"nom": "Musiciens", "icone": Icons.music_note},
    ];

    final challenges = List.generate(
      20,
          (index) => {
        "id": (index + 1).toString(),
        "name": "Challenge ${index + 1}",
        "score": "${40 + index % 20 * 5}/100",
        "communaute": communities[index % communities.length]["nom"] as String,
        "matieres": [
          "Matière ${index % 5 + 1}",
          "Matière ${index % 5 + 2}",
          "Matière ${index % 5 + 3}"
        ], // Liste de matières associée
      },
    );

    final groupedChallenges = _groupChallengesByCommunity(challenges, communities);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Challenges par Communauté',
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
        itemCount: groupedChallenges.length,
        itemBuilder: (context, index) {
          final community = groupedChallenges[index];
          final isExpanded = _expandedCommunityIndex == index;

          return _buildExpandableCommunity(context, community, index, isExpanded);
        },
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  List<Map<String, dynamic>> _groupChallengesByCommunity(
      List<Map<String, dynamic>> challenges,
      List<Map<String, dynamic>> communities) {
    return communities.map((community) {
      final communityChallenges = challenges
          .where((challenge) => challenge["communaute"] == community["nom"])
          .toList();
      return {
        "community": community,
        "challenges": communityChallenges,
      };
    }).toList();
  }

  Widget _buildExpandableCommunity(
      BuildContext context,
      Map<String, dynamic> communityData,
      int index,
      bool isExpanded) {
    final community = communityData["community"] as Map<String, dynamic>;
    final challenges = communityData["challenges"] as List<Map<String, dynamic>>;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: ExpansionTile(
          key: PageStorageKey<int>(index),
          leading: Icon(
            community["icone"] as IconData,
            color: Colors.blue, // Uniformiser les couleurs avec bleu
            size: 30,
          ),
          title: Text(
            community["nom"] ?? "",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue, // Uniformiser le texte en bleu
            ),
          ),
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _expandedCommunityIndex = expanded ? index : null; // Mise à jour de l'état
            });
          },
          children: challenges
              .map((challenge) => _buildChallengeTile(context, challenge))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildChallengeTile(
      BuildContext context, Map<String, dynamic> challenge) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            challenge["name"] ?? "",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          subtitle: Text(
            "Score : ${challenge["score"] ?? "N/A"}",
            style: const TextStyle(color: Colors.black),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
          onTap: () => _showChallengeDetails(context, challenge),
        ),
      ),
    );
  }

  void _showChallengeDetails(BuildContext context, Map<String, dynamic> challenge) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                challenge["name"] ?? "Nom indisponible",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.grey[300]),
              _buildDetailRow("ID du Challenge", challenge["id"] ?? "Inconnu"),
              _buildDetailRow("Score", challenge["score"] ?? "N/A"),
              const SizedBox(height: 10),
              const Text(
                "Matières du Challenge:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 5),
              _buildMatiereList(challenge["matieres"] as List<String>),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMatiereList(List<String> matieres) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: matieres
          .map((matiere) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          "• $matiere",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ))
          .toList(),
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
