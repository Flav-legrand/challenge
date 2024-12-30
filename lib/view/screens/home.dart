import 'package:flutter/material.dart';
import 'package:challenger/view/screens/test.dart';
import 'package:challenger/view/screens/competition.dart';
import 'package:challenger/view/screens/evaluation.dart';
import 'test/matiere_stat.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> subjects = const [
    {'title': 'Math', 'icon': Icons.calculate, 'color': Colors.blue},
    {'title': 'Physique & Chimie', 'icon': Icons.science, 'color': Colors.deepPurple},
    {'title': 'SVT', 'icon': Icons.grass, 'color': Colors.green},
    {'title': 'Histoire & Geo', 'icon': Icons.public, 'color': Colors.orange},
    {'title': 'Philosophie', 'icon': Icons.psychology, 'color': Colors.teal},
    {'title': 'Français', 'icon': Icons.menu_book, 'color': Colors.red},
    {'title': 'Anglais', 'icon': Icons.language, 'color': Colors.indigo},
    {'title': 'Informatique', 'icon': Icons.computer, 'color': Colors.cyan},
    {'title': 'Education Physique', 'icon': Icons.sports, 'color': Colors.pink},
    {'title': 'Culture Générale', 'icon': Icons.lightbulb, 'color': Colors.amber},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Challenger',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    _showNotifications(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.account_circle, color: Colors.white),
                  onPressed: () {
                    _showProfile(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Barre de recherche
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Recherchez ici...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 20,
                  ),
                ),
                onChanged: (value) {
                  print('Recherche : $value');
                },
              ),
            ),
            // Message de bienvenue
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.emoji_emotions,
                    color: Colors.blueAccent,
                    size: 40,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Bienvenue dans Challenger ! Explorez, testez et apprenez avec Horizon Education.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Modules principaux
            _buildSection(
              title: 'Modules principaux',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildModuleCard(
                    icon: Icons.quiz,
                    color: Colors.orangeAccent,
                    title: 'Test',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TestPage()),
                      );
                    },
                  ),
                  _buildModuleCard(
                    icon: Icons.emoji_events,
                    color: Colors.purpleAccent,
                    title: 'Compétition',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CompetitionPage()),
                      );
                    },
                  ),
                  _buildModuleCard(
                    icon: Icons.book,
                    color: Colors.greenAccent,
                    title: 'Évaluation',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EvaluationPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Courbe d’évolution
            _buildSection(
              title: 'Courbe d’évolution',
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '[Graphique à intégrer ici]',
                    style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                  ),
                ),
              ),
            ),
            // Progression des évaluations
            _buildSection(
              title: 'Progression des évaluations',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProgressBarSection('Trimestre 1', 0.8, Colors.greenAccent),
                  _buildProgressBarSection('Trimestre 2', 0.5, Colors.orangeAccent),
                  _buildProgressBarSection('Trimestre 3', 0.2, Colors.redAccent),
                ],
              ),
            ),
            // Explorer
            // Ajout d'une navigation pour chaque matière
            GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: subjects.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatiereStatPage(
                          subjectTitle: subject['title'],
                        ),
                      ),
                    );
                  },
                  child: _buildExplorerItem(
                    title: subject['title'],
                    icon: subject['icon'],
                    color: subject['color'],
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildSection({String? title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 30, color: color),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplorerItem({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBarSection(String title, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
        ),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: value,
          color: color,
          backgroundColor: Colors.grey[300],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.blue),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Divider(color: Colors.blue[100]),
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.blue),
              title: Text('Nouvelle évaluation disponible'),
              subtitle: Text('Une évaluation a été ajoutée pour votre série.'),
            ),
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.blue),
              title: Text('Date limite d\'inscription'),
              subtitle: Text('Inscription pour la compétition close demain.'),
            ),
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.blue),
              title: Text('Mise à jour des horaires'),
              subtitle: Text('Les horaires des cours ont été modifiés.'),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.person, size: 50, color: Colors.blue),
            ),
            const SizedBox(height: 10),
            Text(
              'DZIO Ruth Dorcas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.blue[100]),
            _buildProfileRow(Icons.school, 'Niveau', 'Terminal'),
            _buildProfileRow(Icons.class_, 'Série', 'C'),
            _buildProfileRow(Icons.email, 'Email', 'ruthdorcasdzio@gmail.com'),
            _buildProfileRow(Icons.home, 'Domicile', 'Brazzaville'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.blue[700]),
          ),
        ],
      ),
    );
  }

}
