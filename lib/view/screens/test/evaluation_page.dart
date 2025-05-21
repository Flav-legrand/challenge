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
    return '$h:${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}';
  }

  Future<void> _handleSubmit() async {
    // 1) Confirm dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmer la soumission'),
        content: const Text('Êtes-vous sûr de vouloir soumettre ce Test ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(context, true),  child: const Text('Confirmer')),
        ],
      ),
    );
    if (confirmed != true) return;

    // 2) Insert a new 'tests' record and get its ID
    final matiereTitle = widget.matiere['title'] as String;
    final matiereId    = await DatabaseHelper().getMatiereIdByTitle(matiereTitle);
    if (matiereId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Matière \"$matiereTitle\" introuvable.")),
      );
      return;
    }
    final nowIso = DateTime.now().toIso8601String();
    final testTitre = 'Test de $matiereTitle – $nowIso';
    final testId = await DatabaseHelper().insertTest(
      titre: testTitre,
      dateIso: nowIso,
      matiereId: matiereId,
    );

    // 3) Compute score: for each answered question, check correct option and sum points
    int total = 0, maximum = 0;
    final db = await DatabaseHelper.getDatabase();
    for (final entry in _userAnswers.entries) {
      final qid  = entry.key;
      final resp = entry.value;
      // fetch question points
      final qRows = await db.query('test_questions',
        columns: ['points'], where: 'id = ?', whereArgs: [qid], limit: 1);
      final pts = qRows.isNotEmpty ? qRows.first['points'] as int : 0;
      maximum += pts;
      // fetch correct option
      final oRows = await db.query('test_options',
        where: 'question_id = ? AND is_correct = 1',
        whereArgs: [qid], limit: 1);
      final isCorrect = oRows.isNotEmpty && oRows.first['option_text'] == resp;
      if (isCorrect) total += pts;
      // record individual response
      await db.insert('test_responses', {
        'user_id'     : 1,            // adapt to real user id
        'question_id' : qid,
        'response'    : resp,
        'is_correct'  : isCorrect ? 1 : 0,
      });
    }

    // 4) Insert final score
    await DatabaseHelper().insertScore(
      score: total,
      userId: 1,
      date: nowIso,
      maxScore: maximum,
      testId: testId,
    );

    // 5) Feedback & navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Test soumis ! Votre score : $total / $maximum')),
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
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Non')),
          TextButton(onPressed: () => Navigator.pop(context, true),  child: const Text('Oui')),
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

  // Called by your EvaluationContents widgets whenever a question is answered:
  void _onAnswer(int questionId, String answer) {
    setState(() {
      _userAnswers[questionId] = answer;
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
              Text(_timeString, style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
