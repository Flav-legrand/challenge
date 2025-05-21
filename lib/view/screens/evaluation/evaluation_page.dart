import 'package:flutter/material.dart';
import 'dart:async';
import 'evaluation_contents.dart'; // Importer correctement les contenus d’évaluation

class EvaluationPage extends StatefulWidget {
  final Map<String, dynamic> matiere;
  final String evaluationTitre; // Define evaluationTitre as a field
  final String trimestres; // Define trimestres as a field

  const EvaluationPage({
    required this.matiere,
    required this.evaluationTitre,
    required this.trimestres,
  });

  @override
  _EvaluationPageState createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  late String _timeString;
  late Timer _timer;
  int _startTime = 0;

  bool _isConfirmed = false; // État de la puce de confirmation

  @override
  void initState() {
    super.initState();
    _timeString = _formatTime(_startTime);
    _startTimer();
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _startTime++;
        _timeString = _formatTime(_startTime);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _showConfirmationDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Confirmer"),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleSubmit() async {
    await _showConfirmationDialog(
      title: "Confirmer la soumission",
      content: "Êtes-vous sûr de vouloir soumettre ce devoir ?",
      onConfirm: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Devoir soumis avec succès !")),
        );
        Navigator.pushReplacementNamed(context, '/matiere_list'); // Redirection
      },
    );
  }

  void _handleAbandon() async {
    await _showConfirmationDialog(
      title: "Confirmer l'abandon",
      content: "Êtes-vous sûr de vouloir abandonner ce devoir ?",
      onConfirm: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Devoir abandonné.")),
        );
        Navigator.pushReplacementNamed(context, '/matiere_list'); // Redirection
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.evaluationTitre} de ${widget.matiere['title']}(${widget.trimestres})",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white), // Bouton retour blanc
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Partie I : Vérification des connaissances
          EvaluationSection(
            title: "Partie I : Vérification des connaissances",
            points: 20,
            content:
                EvaluationContents.getKnowledgeRetrievalContent(widget.matiere, widget.evaluationTitre, widget.trimestres),
          ),
          SizedBox(height: 20),

          // Partie II : Application des connais
          // sances
          EvaluationSection(
            title: "Partie II : Application des connaissances",
            points: 30,
            content: EvaluationContents.getKnowledgeApplicationContent(
                widget.matiere),
          ),
          SizedBox(height: 20),

          // Partie III : Cas pratique
          EvaluationSection(
            title: "Partie III : Cas pratique",
            points: 50,
            content: EvaluationContents.getPracticalCaseContent(widget.matiere),
          ),
          SizedBox(height: 30),

          // Texte avec la puce de confirmation
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _isConfirmed,
                    onChanged: (value) {
                      setState(() {
                        _isConfirmed = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "En soumettant ce devoir, j’accepte d’avoir lu, compris et approuvé les conditions d’utilisation d’Horizon Challenger. "
                      "Je suis pleinement conscient des conséquences en cas de non-respect de ces conditions.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Boutons "Soumettre" et "Abandonner"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _isConfirmed ? _handleSubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      disabledBackgroundColor: Colors.grey,
                      foregroundColor:
                          _isConfirmed ? Colors.white : Colors.black,
                    ),
                    child: Text("Soumettre"),
                  ),
                  OutlinedButton(
                    onPressed: _handleAbandon,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blueAccent),
                    ),
                    child: Text(
                      "Abandonner",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 10),
              Text(
                _timeString,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EvaluationSection extends StatelessWidget {
  final String title;
  final int points;
  final Widget content;

  const EvaluationSection({
    required this.title,
    required this.points,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and points display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors
                          .blueAccent, // Modification de la couleur en bleu
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 10),
                
                Text(
                  "$points pts",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            Divider(color: Colors.grey[300], thickness: 1),
            content, // Le contenu qui vient de EvaluationContents
          ],
        ),
      ),
    );
  }
}
