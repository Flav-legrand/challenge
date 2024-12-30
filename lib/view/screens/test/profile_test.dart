import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Utilisateur',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white), // Retour en blanc
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Section Avatar
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blueAccent.withOpacity(0.2),
                  ),
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Ruth Dorcas DZIO',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Étudiante en Terminale, Série C',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              // Informations personnelles
              _buildProfileSection(
                title: 'Informations personnelles',
                children: const [
                  _ProfileDetailRow(icon: Icons.school, label: 'Niveau', value: 'Terminale'),
                  _ProfileDetailRow(icon: Icons.science, label: 'Série', value: 'C'),
                  _ProfileDetailRow(icon: Icons.email, label: 'Email', value: 'ruthdorcasdzio@gmail.com'),
                  _ProfileDetailRow(icon: Icons.home, label: 'Domicile', value: 'Brazzaville'),
                ],
              ),
              const SizedBox(height: 20),

              // Statistiques de performance
              _buildProfileSection(
                title: 'Statistiques de performance',
                children: [
                  _ProfileStatRow(
                    icon: Icons.book,
                    label: 'Tests réalisés',
                    value: '12',
                    color: Colors.green,
                  ),
                  _ProfileStatRow(
                    icon: Icons.star,
                    label: 'Meilleur score',
                    value: '95/100',
                    color: Colors.blueAccent,
                  ),
                  _ProfileStatRow(
                    icon: Icons.timeline,
                    label: 'Performance moyenne',
                    value: '78%',
                    color: Colors.orange,
                  ),
                  _ProfileStatRow(
                    icon: Icons.timer,
                    label: 'Temps total d\'étude',
                    value: '45h',
                    color: Colors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Sections supplémentaires
              _buildProfileSection(
                title: 'Détails supplémentaires',
                children: const [
                  _ProfileDetailRow(icon: Icons.phone, label: 'Numéro de téléphone', value: '+242 06 123 4567'),
                  _ProfileDetailRow(icon: Icons.cake, label: 'Date de naissance', value: '01 Janvier 2005'),
                  _ProfileDetailRow(icon: Icons.flag, label: 'Nationalité', value: 'Congolaise'),
                ],
              ),
              const SizedBox(height: 20),

              // Boutons d'action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Logique pour modifier le profil
                      print('Modification du profil');
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text(
                      'Modifier',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Logique pour partager le profil
                      print('Partage du profil');
                    },
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text(
                      'Partager',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildProfileSection({required String title, required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileDetailRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ProfileStatRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
