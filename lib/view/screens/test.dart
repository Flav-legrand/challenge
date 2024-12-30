import 'package:flutter/material.dart';
import 'test/historique_test.dart';
import 'test/profile_test.dart';
import 'test/communaute.dart';
import 'test/publication.dart';
import 'test/communaute_list.dart';
import 'test/positionnement.dart';
import 'test/matiere_list.dart';
import 'test/nouvelle_communaute.dart';
import 'test/nouveau_challenge.dart';
import 'test/challenge_list.dart';
import 'test/mes_communautes.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tests',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Recherchez un test ou une matière...',
                prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Message de bienvenue
                  _buildWelcomeMessage(),
                  // Bloc individuel
                  _buildIndividuelBlock(),
                  // Bloc communauté
                  _buildCommunauteBlock(),
                  // Bloc Challenge
                  _buildChallengeBlock(),
                  // Bloc statistiques
                  _buildStatistiqueBlock(),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildWelcomeMessage() {
    return Container(
      color: Colors.blue[50],
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.school, size: 40, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Explorez vos tests et préparez-vous efficacement !',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndividuelBlock() {
    return _buildSection(
      title: 'Individuel',
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCenteredActionButton(
                icon: Icons.add,
                label: 'Créer un nouveau test',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MatiereList()),
                ),
              ),
              _buildCenteredActionButton(
                icon: Icons.history,
                label: 'Mes tests',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoriqueTest()),
                ),
              ),
              _buildCenteredActionButton(
                icon: Icons.person,
                label: 'Mon compte',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommunauteBlock() {
    return _buildSection(
      title: 'Communauté',
      children: [
        SizedBox(
          height: 150, // Fixe la hauteur du conteneur contenant les cartes
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(5, (index) {
              return Container(
                width: 120, // Fixe la largeur de chaque carte
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildIconCard(
                  icon: _getIconForIndex(index),
                  label: _getLabelForIndex(index),
                  onTap: () {
                    if (index == 0) {
                      // Navigation vers la nouvelle page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NouvelleCommunautePage()),
                      );
                    } else if (index == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CommunauteForm()),
                      );
                    } else if (index == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PublicationPage()),
                      );
                    } else if (index == 3) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CommunauteList()),
                      );
                    } else if (index == 4) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PositionnementPage()),
                      );
                    }
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeBlock() {
    return _buildSection(
      title: 'Challenge',
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 icônes par ligne
            childAspectRatio: 1, // Maintien de la proportion pour les icônes
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 3, // Nombre d'icônes
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return _buildIconCard(
                  icon: Icons.add_circle_outline,
                  label: 'Nouveau',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NouveauChallengePage()),
                  ),
                );
              case 1:
                return _buildIconCard(
                  icon: Icons.list_alt,
                  label: 'Liste',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChallengeListPage()),
                  ),
                );
              case 2:
                return _buildIconCard(
                  icon: Icons.star_outline,
                  label: 'Groupes',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MesCommunautesPage()),
                  ),
                );
              default:
                return SizedBox.shrink(); // Ne rien afficher par défaut
            }
          },
        ),
      ],
    );
  }


  Widget _buildIconCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center, // Appliquer le textAlign ici
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildStatistiqueBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Bloc des statistiques individuelles
        _buildInnerShadowBlock(
          title: 'Statistiques Individuelles',
          progressValue: 0.75,
          stats: [
            _buildStatTile('Tests effectués', '120'),
            _buildStatTile('Tests réussis', '90'),
            _buildStatTile('Tests échoués', '30'),
          ],
          lastUpdate: 'Dernier test : 3 jours',
          progressColor: Colors.blueAccent,
        ),
        const SizedBox(height: 20),
        // Bloc des statistiques de groupe
        _buildInnerShadowBlock(
          title: 'Statistiques de Groupe',
          progressValue: 0.6,
          stats: [
            _buildStatTile('Actifs', '5'),
            _buildStatTile('Tests', '200'),
            _buildStatTile('Réussis', '150'),
          ],
          lastUpdate: 'Dernier challenge collectif : 2 jours',
          progressColor: Colors.green,
        ),
      ],
    );
  }

  Widget _buildInnerShadowBlock({
    required String title,
    required double progressValue,
    required List<Widget> stats,
    required String lastUpdate,
    required Color progressColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Ombre externe
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.white, // Ombre interne
            spreadRadius: -5,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.grey[300],
            color: progressColor,
            minHeight: 10,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stats,
          ),
          const SizedBox(height: 20),
          Text(
            lastUpdate,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(title),
      ],
    );
  }




  Widget _buildCenteredActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: 250, // Largeur uniforme pour tous les boutons
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: 20, color: Colors.blueAccent),
          label: Text(
            label,
            style: const TextStyle(color: Colors.blueAccent, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // Boutons en blanc
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(color: Colors.blueAccent),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.group_add;
      case 1:
        return Icons.join_inner_outlined;
      case 2:
        return Icons.share;
      case 3:
        return Icons.list;
      case 4:
        return Icons.location_history;
      default:
        return Icons.error; // Icon par défaut
    }
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Créer';
      case 1:
        return 'Rejoindre';
      case 2:
        return 'Publier';
      case 3:
        return 'Liste';
      case 4:
        return 'Position';
      default:
        return 'Inconnu';
    }
  }
}
