import 'package:flutter/material.dart';
import 'evaluation_page.dart';
import 'package:challenger/controler/evaluation/evaluation.dart'; // Importer EvaluationController pour la BD

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
  List<Map<String, dynamic>> devoirs = [];
  List<Map<String, dynamic>> filteredMatieres = [];
  List<Map<String, dynamic>> filteredDevoirs = [];
  final EvaluationController _controller = EvaluationController();

  @override
  void initState() {
    super.initState();
    fetchMatieres();
  }

  // Méthode pour récupérer les matières depuis la base de données
  Future<void> fetchMatieres() async {
    await _controller.initDatabase(); // Initialiser la base de données
    final List <Matiere> fetchedMatieres =
    await _controller.fetchAllMatieres(); // Récupérer les matières

    setState(() {
      matieres = fetchedMatieres.map((matiere) {
        return {
          'id': matiere.id,
          'title': matiere.title,
          'icon': _getIconFromString(matiere.icon),
          'color': _getColorFromName(matiere.color), // Utilisation des noms de couleurs
          'performance': 'À venir', // Valeur par défaut
          'statut': 'aVenir', // Valeur par défaut
        };
      }).toList();
      filteredMatieres = matieres;
    });
  }

  Future<void> fetchDevoirs() async {
    await _controller.initDatabase(); // Initialiser la base de données
    final List <Devoir> fetchedDevoirs =
    await _controller.fetchAllDevoirs(); // Récupérer les matières

    setState(() {
      devoirs = fetchedDevoirs.map((devoir) {
        return {
          'id': devoir.id,
          'title': devoir.titre,
          'statut': devoir.statut,
        };
      }).toList();
      filteredMatieres = devoirs;
    });
  }


  // Méthode pour convertir un nom d'icône en IconData
  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'calculate':
        return Icons.calculate;
      case 'grass':
        return Icons.grass;
      case 'science':
        return Icons.science;
      case 'book':
        return Icons.book;
      case 'map':
        return Icons.map;
      case 'psychology':
        return Icons.psychology;
      case 'language':
        return Icons.language;
      case 'language_outlined':
        return Icons.language_outlined;
      case 'computer':
        return Icons.computer;
      case 'fitness_center':
        return Icons.fitness_center;
      default:
        return Icons.help_outline; // Icône par défaut
    }
  }

  // Méthode pour obtenir une couleur à partir d'un nom
  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'deeppurple':
        return Colors.deepPurple;
      case 'orange':
        return Colors.orange;
      case 'grey':
        return Colors.grey;
      case 'pink':
        return Colors.pink;
      default:
        return Colors.grey; // Couleur par défaut si le nom est inconnu
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
          '${widget.evaluationTitre}',
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
                          CircleAvatar(
                            radius: 4,
                            backgroundColor: getStatusColor(matiere['statut']),
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
