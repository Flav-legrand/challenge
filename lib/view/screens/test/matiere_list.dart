import 'package:flutter/material.dart';
import 'package:challenger/database/database.dart';
import 'evaluation_page.dart';

class MatiereList extends StatefulWidget {
  const MatiereList({Key? key}) : super(key: key);

  @override
  _MatiereListState createState() => _MatiereListState();
}

class _MatiereListState extends State<MatiereList> {
  List<Map<String, dynamic>> matieres = [];
  List<Map<String, dynamic>> filteredMatieres = []; // Liste filtrée
  TextEditingController searchController =
      TextEditingController(); // Contrôleur pour la recherche

  @override
  void initState() {
    super.initState();
    fetchMatieres();
    searchController.addListener(
        _filterMatieres); // Écoute les changements dans la barre de recherche
  }

  Future<void> fetchMatieres() async {
    final dbHelper = DatabaseHelper();
    final data = await dbHelper.getMatieres();
    setState(() {
      matieres = data;
      filteredMatieres =
          data; // Initialement, toutes les matières sont affichées
    });
  }

  void _filterMatieres() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredMatieres = matieres.where((matiere) {
        final title = matiere['title'].toString().toLowerCase();
        return title.contains(query); // Filtre les matières par titre
      }).toList();
    });
  }

  IconData _getIconFromName(String? iconName) {
    switch (iconName) {
      case 'calculate':
        return Icons.calculate;
      case 'science':
        return Icons.science;
      case 'biologie':
        return Icons.grass;
      case 'public':
        return Icons.public;
      case 'computer':
        return Icons.computer;
      case 'emoji_objects':
        return Icons.emoji_objects;
      case 'translate':
        return Icons.translate;
      case 'palette':
        return Icons.palette;
      case 'book':
        return Icons.book;
      case 'music_note':
        return Icons.music_note;
      case 'flask':
        return Icons.science;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'account_balance':
        return Icons.account_balance;
      default:
        return Icons.help;
    }
  }

  Color _getColorFromName(String? colorName) {
    switch (colorName?.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'deepPurple':
        return Colors.deepPurple;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      case 'pink':
        return Colors.pink;
      case 'yellow':
        return Colors.yellow;
      case 'cyan':
        return Colors.cyan;
      case 'indigo':
        return Colors.indigo;
      case 'lime':
        return Colors.lime;
      case 'amber':
        return Colors.amber;
      case 'teal':
        return Colors.teal;
      case 'brown':
        return Colors.brown;
      case 'black':
        return Colors.black;
      case 'white':
        return const Color.fromARGB(255, 194, 95, 95);
      case 'grey':
      case 'gray':
        return const Color.fromARGB(255, 69, 96, 187);
      default:
        return const Color.fromARGB(255, 14, 13, 13);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liste des Matières',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher une matière',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          // Liste des matières
          Expanded(
            child: filteredMatieres.isEmpty
                ? const Center(child: Text('Aucune matière trouvée'))
                : GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: filteredMatieres.length,
                    itemBuilder: (context, index) {
                      final matiere = filteredMatieres[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EvaluationPage(matiere: matiere),
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
                              Icon(
                                _getIconFromName(matiere['icon']),
                                size: 40,
                                color: _getColorFromName(matiere['color']),
                              ),
                              Text(
                                matiere['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
