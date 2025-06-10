import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:challenger/view/screens/test.dart';
import 'package:challenger/view/screens/competition.dart';
import 'package:challenger/view/screens/evaluation.dart';
import 'test/matiere_stat.dart';
import 'login_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:challenger/database/database.dart'; //

class HomePage extends StatefulWidget {
  final int userId;
  const HomePage({Key? key, required this.userId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  String? userEmail;
  String? niveau;
  String? serie;
  String? domicile;
  Uint8List? profileImage;

  int _chartKey = 0;

  Future<Map<String, int>> getTestSuccessStats(int userId) async {
    final db = await DatabaseHelper.getDatabase();
    // On considère la moyenne à 50% du max_score
    final results = await db.query(
      'test_results',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    int success = 0;
    int fail = 0;
    for (final row in results) {
      final score = row['score'] as int;
      final maxScore = row['max_score'] as int;
      if (maxScore == 0) continue;
      if (score >= (maxScore / 2)) {
        success++;
      } else {
        fail++;
      }
    }
    return {'success': success, 'fail': fail};
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _chartKey++;
    });
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _chartKey++;
    });
  }

  Future<void> _loadUserInfo() async {
    final db = await DatabaseHelper.getDatabase();
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [widget.userId],
      limit: 1,
    );
    if (result.isNotEmpty) {
      final user = result.first;
      setState(() {
        userName = user['username'] as String?;
        userEmail = user['email'] as String?;
        niveau = user['niveau '] as String? ?? user['niveau'] as String?;
        serie = user['serie '] as String? ?? user['serie'] as String?;
        domicile = user['domicile '] as String? ?? user['domicile'] as String?;
        profileImage = user['Field5'] as Uint8List?;
      });
    }
  }

  final List<Map<String, dynamic>> subjects = const [
    {'title': 'Math', 'icon': Icons.calculate, 'color': Colors.blue},
    {
      'title': 'Physique & Chimie',
      'icon': Icons.science,
      'color': Colors.deepPurple
    },
    {'title': 'SVT', 'icon': Icons.grass, 'color': Colors.green},
    {'title': 'Histoire & Geo', 'icon': Icons.public, 'color': Colors.orange},
    {'title': 'Philosophie', 'icon': Icons.psychology, 'color': Colors.teal},
    {'title': 'Français', 'icon': Icons.menu_book, 'color': Colors.red},
    {'title': 'Anglais', 'icon': Icons.language, 'color': Colors.indigo},
    {'title': 'Informatique', 'icon': Icons.computer, 'color': Colors.cyan},
    {'title': 'Education Physique', 'icon': Icons.sports, 'color': Colors.pink},
    {
      'title': 'Culture Générale',
      'icon': Icons.lightbulb,
      'color': Colors.amber
    },
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
                        MaterialPageRoute(
                            builder: (context) =>
                                TestPage(userId: widget.userId)),
                      ).then((_) {
                        setState(() {
                          _chartKey++;
                        });
                      });
                    },
                  ),
                  _buildModuleCard(
                    icon: Icons.emoji_events,
                    color: Colors.purpleAccent,
                    title: 'Compétition',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompetitionPage(
                                  userId: widget.userId,
                                )),
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
                        MaterialPageRoute(
                            builder: (context) =>
                                EvaluationPage(userId: widget.userId)),
                      ).then((_) {
                        setState(() {
                          _chartKey++;
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
            // Courbe d’évolution
            _buildSection(
              title: 'Courbe d’évolution',
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FutureBuilder<Map<String, int>>(
                  key: ValueKey(_chartKey), // Ajoute la clé ici
                  future: getTestSuccessStats(widget.userId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    final data = snapshot.data!;
                    final success = data['success']!;
                    final fail = data['fail']!;
                    if (success + fail == 0) {
                      return const Text('Aucun test passé');
                    }
                    return PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            color: const Color.fromARGB(255, 134, 182, 221),
                            value: success.toDouble(),
                            title: 'Réussis\n$success',
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.red,
                            value: fail.toDouble(),
                            title: 'Échoués\n$fail',
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            // Progression des évaluations
            _buildSection(
              title: 'Progression des évaluations',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProgressBarSection(
                      'Trimestre 1', 0.8, Colors.greenAccent),
                  _buildProgressBarSection(
                      'Trimestre 2', 0.5, Colors.orangeAccent),
                  _buildProgressBarSection(
                      'Trimestre 3', 0.2, Colors.redAccent),
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
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800]),
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
            GestureDetector(
              onTap: () {
                if (profileImage != null && profileImage!.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      backgroundColor: Colors.transparent,
                      child: Center(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pop(), // Ferme la boîte au clic
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 300,
                              maxHeight: 300,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: InteractiveViewer(
                                child: Image.memory(
                                  profileImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue[100],
                backgroundImage:
                    (profileImage != null && profileImage!.isNotEmpty)
                        ? MemoryImage(profileImage!)
                        : null,
                child: (profileImage == null || profileImage!.isEmpty)
                    ? Icon(Icons.person, size: 50, color: Colors.blue)
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              userName ?? 'Utilisateur',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.blue[100]),
            _buildProfileRow(Icons.school, 'Niveau', niveau ?? ''),
            _buildProfileRow(Icons.class_, 'Série', serie ?? ''),
            _buildProfileRow(Icons.home, 'Domicile', domicile ?? ''),
            _buildProfileRow(Icons.email, 'Email', userEmail ?? ''),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Déconnexion',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
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
