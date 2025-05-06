import 'package:flutter/material.dart';
import 'evaluation_page.dart';
import 'package:challenger/controler/evaluation/evaluation.dart';

class MatiereList extends StatefulWidget {
  final String evaluationTitre;
  final String trimestres;

  const MatiereList({
    super.key,
    required this.evaluationTitre,
    required this.trimestres,
  });

  @override
  _MatiereListState createState() => _MatiereListState();
}

class _MatiereListState extends State<MatiereList> {
  List<Map<String, dynamic>> matieres = [];
  List<Map<String, dynamic>> devoirs = [];
  List<Map<String, dynamic>> combinedItems = [];
  List<Map<String, dynamic>> filteredItems = [];

  final MatiereController _matiereController = MatiereController();
  final DevoirController _devoirController = DevoirController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Méthode pour charger les données depuis MatiereController et DevoirController
  Future<void> fetchData() async {
    await _matiereController.loadMatieres();
    await _devoirController.loadDevoirs();

    setState(() {
      matieres = _matiereController.matieres.map((matiere) {
        return {
          'id': matiere['id'],
          'title': matiere['title'],
          'icon': _getIconFromString(matiere['icon']),
          'color': _getColorFromName(matiere['color']),
          'type': 'Matière', // Distinction pour afficher le type
          'performance': 'À venir', // Valeur par défaut
          'statut': 'aVenir', // Valeur par défaut
        };
      }).toList();

      devoirs = _devoirController.devoirs.map((devoir) {
        return {
          'id': devoir['id'],
          'title': devoir['title'],
          'icon': _getIconFromString(devoir['icon']),
          'color': _getColorFromName(devoir['color']),
          'type': 'Devoir', // Distinction pour afficher le type
          'performance': 'À venir', // Valeur par défaut
          'statut': 'aVenir', // Valeur par défaut
        };
      }).toList();

      // Combiner les matières et les devoirs
      combinedItems = [...matieres, ...devoirs];
      filteredItems = combinedItems;
    });

  }

  // Méthode pour convertir un nom d'icône en IconData
  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'calculate':
        return Icons.calculate;
      case 'science':
        return Icons.science;
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

  void _filterItems(String query) {
    final filteredList = combinedItems.where((item) {
      final title = item['title'].toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredItems = filteredList;
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

  String getDuration(String title) {
    final List<String> sciences = ["SVT", "Math", "Physique & Chimie"];
    return sciences.contains(title) ? "3h 00" : "2h 00";
  }

  String getPerformanceText(Map<String, dynamic> item) {
    return item["performance"] != null
        ? "${item["performance"]}%"
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
                onChanged: _filterItems,
                decoration: const InputDecoration(
                  labelText: 'Rechercher une matière ou un devoir',
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
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EvaluationPage(matiere: item),

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
                          Icon(item["icon"], size: 40, color: item["color"]),
                          Text(
                            item["title"],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "${getDuration(item["title"])} | ${getPerformanceText(item)}",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          CircleAvatar(
                            radius: 4,
                            backgroundColor: getStatusColor(item['statut']),
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
