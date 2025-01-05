import 'package:challenger/database/database.dart';
import 'package:flutter/material.dart';
import 'evaluation_page.dart';

class MatiereList extends StatefulWidget {
  final String evaluationTitre;
  final String trimestres;

  const MatiereList(
      {super.key, required this.evaluationTitre, required this.trimestres});

  @override
  _MatiereListState createState() => _MatiereListState();
}

class _MatiereListState extends State<MatiereList> {
  List<Map<String, dynamic>> matieres = [];
  List<Map<String, dynamic>> filteredMatieres = [];

  @override
  void initState() {
    super.initState();
    // Appeler la méthode fetchMatieresByDevoirs avec les arguments appropriés
    fetchMatieresByDevoirs(widget.trimestres, widget.evaluationTitre);
  }

  // Méthode pour récupérer les matières en fonction du trimestre et du titre
  Future<void> fetchMatieresByDevoirs(String trimestre, String titre) async {
    final db = await DatabaseHelper.getDatabase();

    // Requête SQL pour récupérer les matières associées aux devoirs
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT DISTINCT matieres.*
      FROM matieres
      INNER JOIN devoirs ON matieres.id = devoirs.matiere_id
      WHERE devoirs.trimestre = ? AND devoirs.titre = ?
    ''', [trimestre, titre]);

    // Transformation des données récupérées
    final fetchedMatieres = result.map((matiere) {
      return {
        'title': matiere['title'], // Assurez-vous que 'title' est le bon champ
        'icon': _getIconFromName(matiere['icon']), // Transformation de l'icône
        'color':
            _getColorFromName(matiere['color']), // Transformation de la couleur
        'nom': matiere['title'], // Nom de la matière
        'performance':
            '', // Vous pouvez ajouter des performances si disponibles
        'statut': '', // Vous pouvez ajouter des statuts si disponibles
      };
    }).toList();

    setState(() {
      matieres =
          fetchedMatieres; // Mise à jour de l'état avec les matières traitées
      filteredMatieres = fetchedMatieres; // Initialisation de la liste filtrée
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

  void _filterMatieres(String query) {
    final filteredList = matieres.where((matiere) {
      final title = matiere['title'].toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredMatieres = filteredList;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.evaluationTitre} (${widget.trimestres})',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
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
                onChanged: _filterMatieres,
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
                itemCount: filteredMatieres.length,
                itemBuilder: (context, index) {
                  final matiere = filteredMatieres[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EvaluationPage(
                            matiere: matiere,
                            evaluationTitre: widget.evaluationTitre,
                            trimestres: widget.trimestres,
                          ),
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
                          Icon(matiere["icon"],
                              size: 40, color: matiere["color"]),
                          Text(
                            matiere["title"],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "${getDuration(matiere["title"])} | ${getPerformanceText(matiere)}",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
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
