import 'package:flutter/material.dart';
import 'evaluation/matiere_list.dart'; // Importer la page MatiereList
import 'dart:async'; // Pour le délai

// Enum pour le statut des devoirs
enum Statut { reussi, echoue, aVenir }

// Classe Devoir pour définir les devoirs/examens
class Devoir {
  final String titre;
  final Statut statut;
  final IconData icone;

  Devoir(this.titre, this.statut, this.icone);
}

class EvaluationPage extends StatefulWidget {
  @override
  _EvaluationPageState createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  bool _showAnimation = true;

  @override
  void initState() {
    super.initState();
    _triggerWelcomeAnimation();
  }

  void _triggerWelcomeAnimation() {
    setState(() {
      _showAnimation = true;
    });
    Timer(Duration(seconds: 3), () {
      setState(() {
        _showAnimation = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fonction pour générer un bloc avec une ombre
    Widget buildBlock(String trimestre, List<Devoir> devoirs) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trimestre,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 15),
              Column(
                children: devoirs
                    .map((devoir) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MatiereList(
                            evaluationTitre: devoir.titre,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(
                            devoir.icone,
                            size: 24,
                            color: Colors.blue[400],
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              devoir.titre,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: devoir.statut == Statut.reussi
                                  ? Colors.green
                                  : devoir.statut == Statut.echoue
                                  ? Colors.red
                                  : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.blue[400],
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
                    .toList(),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, // Harmonisé avec la page précédente
        elevation: 4,
        title: Text(
          'Evaluations',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true, // Ajouter un bouton retour
      ),
      body: _showAnimation
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bienvenue !",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Explorez vos évaluations et préparez-vous pour réussir !',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
            ),
          ],
        ),
      )
          : ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.school,
                    color: Colors.blueAccent,
                    size: 40,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Préparez vos examens et suivez votre progression à chaque trimestre.',
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
          ),
          buildBlock("Trimestre I", [
            Devoir("Devoir nº1", Statut.reussi, Icons.edit),
            Devoir("Devoir nº2", Statut.echoue, Icons.school),
            Devoir("Examen trimestriel", Statut.aVenir, Icons.assignment),
          ]),
          buildBlock("Trimestre II", [
            Devoir("Devoir nº1", Statut.aVenir, Icons.edit),
            Devoir("Devoir nº2", Statut.reussi, Icons.school),
            Devoir("Examen trimestriel", Statut.aVenir, Icons.assignment),
          ]),
          buildBlock("Trimestre III", [
            Devoir("Devoir nº1", Statut.reussi, Icons.edit),
            Devoir("Devoir nº2", Statut.echoue, Icons.school),
            Devoir("Examen trimestriel", Statut.aVenir, Icons.assignment),
          ]),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
