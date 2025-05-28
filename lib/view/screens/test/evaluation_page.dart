import 'package:challenger/view/screens/evaluation/evaluation_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:challenger/database/database.dart';
import 'evaluation_contents.dart';

class EvaluationPage extends StatefulWidget {
  final Map<String, dynamic> matiere;

  const EvaluationPage({Key? key, required this.matiere}) : super(key: key);

  @override
  _EvaluationPageState createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  late String _timeString;
  late Timer _timer;
  int _elapsedSeconds = 0;
  bool _isConfirmed = false;
  Map<int, String> _userAnswers = {};

  @override
  void initState() {
    super.initState();
    _timeString = _formatTime(_elapsedSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsedSeconds++;
        _timeString = _formatTime(_elapsedSeconds);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _handleSubmit() async {
    print('=== DEBUT SOUMISSION ===');
    print('Nombre de réponses: ${_userAnswers.length}');
    print('Contenu des réponses:');
    _userAnswers.forEach((key, value) {
      print('Q$key: $value');
    });

    if (_userAnswers.isEmpty) {
      print('⚠️ Aucune réponse enregistrée!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucune réponse à évaluer!')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmer la soumission'),
        content: const Text('Êtes-vous sûr de vouloir soumettre ce Test ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    print('=== DEBUT SOUMISSION ===');
    print('Nombre de réponses: ${_userAnswers.length}');
    print('Contenu des réponses:');
    _userAnswers.forEach((key, value) {
      print('Q$key: $value');
    });

    if (_userAnswers.isEmpty) {
      print('⚠️ Aucune réponse enregistrée!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucune réponse à évaluer!')),
      );
      return;
    }

    double total = 0.0; // Initialisation du total des points
    double maximum = 0.0; // Initialisation du maximum possible

    final db = await DatabaseHelper.getDatabase();

    print('🟢 Réponses à évaluer: $_userAnswers'); // Vérifiez le contenu
    for (final entry in _userAnswers.entries) {
      final qid = entry.key;
      final resp = entry.value;
      print('🔵 Traitement Q$qid - Réponse: $resp');

      // Récupérer les points associés à la question
      final qRows = await db.query(
        'test_questions',
        columns: ['points'],
        where: 'id = ?',
        whereArgs: [qid],
        limit: 1,
      );

      if (qRows.isEmpty) {
        print('❌ Question non trouvée pour id: $qid');
        continue; // Si la question n'est pas trouvée, on passe à la suivante
      }

      final pts = qRows.first['points'] ?? 0;
      print(
          '✔️ Question ID: $qid, Points: $pts'); // Affiche les points de chaque question

      maximum += (pts as int);

      // Vérification de la réponse correcte
      final oRows = await db.query(
        'test_options',
        where: 'question_id = ? AND is_correct = 1',
        whereArgs: [qid],
        limit: 1,
      );

      bool isCorrect = false;

      if (oRows.isNotEmpty) {
        final correctOptionText =
            oRows.first['option_text'].toString().trim().toLowerCase();
        final userResponse = resp.toString().trim().toLowerCase();
        isCorrect = correctOptionText == userResponse;
        print('Points pour Q$qid: $pts (type: ${pts.runtimeType})');
        print('Option correcte: ${oRows.first['option_text']}');
        print('Réponse utilisateur: $resp');
        print('Correspondance: ${correctOptionText == userResponse}');
        print(
            '✔️ Réponse correcte : $correctOptionText, Réponse utilisateur : $userResponse'); // Debug des réponses
      } else {
        print('❌ Aucune option correcte trouvée pour la question ID: $qid');
      }

      if (isCorrect) {
        total += pts;
      }

      // Enregistrer la réponse dans la table test_responses
      await db.insert('test_responses', {
        'user_id': 1, // Remplacer par l'ID de l'utilisateur authentifié
        'question_id': qid,
        'response': resp,
        'is_correct': isCorrect ? 1 : 0,
      });
    }

    // Enregistrer le résultat du test
    final nowIso = DateTime.now().toIso8601String();
    final testId = widget.matiere['id'] ?? 0;
    String testTitre = widget.matiere['title'];

    await db.insert('test_results', {
      'user_id': 1, // Remplacer par l'ID de l'utilisateur authentifié
      'matiere_id': testId,
      'score': total,
      'max_score': maximum,
      'date_creation': nowIso,
      'titre': 'Test de $testTitre',
    });

    final formattedAnswers =
        _userAnswers.entries.map((e) => 'Q${e.key}: ${e.value}').join(', ');

    print('🟡 Réponses utilisateur (_userAnswers): $_userAnswers');
    print('🟡 Score total: $total, Score maximum: $maximum');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Test soumis ! Score : $total / $maximum\nRéponses : $formattedAnswers',
          style: const TextStyle(fontSize: 14),
        ),
        duration: const Duration(seconds: 6),
      ),
    );

    Navigator.pop(context);
  }

  Future<void> _handleAbandon() async {
    final abandon = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmer l\'abandon'),
        content: const Text('Voulez-vous vraiment abandonner ce test ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Non')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Oui')),
        ],
      ),
    );
    if (abandon == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test abandonné.')),
      );
      Navigator.pop(context);
    }
  }

  void _onAnswer(int questionId, String answer) {
    setState(() {
      _userAnswers[questionId] = answer;
      print('Réponse enregistrée pour Q$questionId: $answer'); // Debug
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test de ${widget.matiere['title']}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          EvaluationSection(
            title: 'Partie I : Vérification des connaissances',
            points: 20,
            content: EvaluationContents.getKnowledgeRetrievalContent(
              widget.matiere,
              onAnswered: _onAnswer,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: _isConfirmed,
                onChanged: (v) => setState(() => _isConfirmed = v!),
              ),
              const Expanded(
                child: Text(
                  'En soumettant ce Test, j’accepte les conditions.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isConfirmed ? _handleSubmit : null,
                child: const Text('Soumettre'),
              ),
              OutlinedButton(
                onPressed: _handleAbandon,
                child: const Text('Abandonner'),
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
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.access_time, color: Colors.white),
              const SizedBox(width: 8),
              Text(_timeString,
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
