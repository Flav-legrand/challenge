import 'package:challenger/database/database.dart';
import 'package:challenger/view/screens/test/evaluation_contents.dart';
import 'package:flutter/material.dart';

class EvaluationContents {
  static Widget getKnowledgeRetrievalContent(
      Map<String, dynamic> matiere, String evaluationTitre, String trimestres) {
    return KnowledgeVerificationContent(
      points: 20,
      matiereNom: matiere['nom'],
      evaluationTitre: evaluationTitre,
      trimestres: trimestres,
    );
  }

  static Widget getKnowledgeApplicationContent(Map<String, dynamic> matiere) {
    return KnowledgeApplicationContent(matiere: {}, matiereNoms: matiere['nom'], matiereNom: matiere['nom'],);
  }

  static Widget getPracticalCaseContent(Map<String, dynamic> matiere) {
    return PracticalCaseContent(matiere: {}, matiereNom: matiere['nom']);
  }
}

class KnowledgeVerificationContent extends StatefulWidget {
  final int points;
  final String matiereNom;
  final String evaluationTitre; // Ajout du titre de l'évaluation
  final String trimestres; // Ajout du trimestre

  const KnowledgeVerificationContent({
    super.key,
    required this.points,
    required this.matiereNom,
    required this.evaluationTitre,
    required this.trimestres,
  });

  @override
  _KnowledgeVerificationContentState createState() =>
      _KnowledgeVerificationContentState();
}

class _KnowledgeVerificationContentState
    extends State<KnowledgeVerificationContent> {
  late Future<List<Map<String, dynamic>>> questionsFuture;

  @override
  void initState() {
    super.initState();
    questionsFuture = fetchQuestionsFromDatabase();
  }

  Future<List<Map<String, dynamic>>> fetchQuestionsFromDatabase() async {
    final db = await DatabaseHelper.getDatabase();
    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
  SELECT 
    m.title AS Matiere,
    d.titre AS Devoir,
    d.trimestre AS Trimestre,
    q.id AS QuestionId,
    q.question AS Question,
    q.points AS Points, -- 👈 AJOUT ICI
    o.option_text AS OptionText,
    o.is_correct AS IsCorrect
  FROM 
    matieres m
  INNER JOIN 
    devoirs d ON m.id = d.matiere_id
  INNER JOIN 
    questions q ON d.id = q.devoir_id
  INNER JOIN 
    options o ON q.id = o.question_id
  WHERE 
   m.title = ?
    AND d.titre = ?
    AND d.trimestre = ?;
  ''',
      [widget.matiereNom, widget.evaluationTitre, widget.trimestres],
    );

    Map<int, Map<String, dynamic>> questionsMap = {};

    for (var row in result) {
      final questionId = row['QuestionId'] as int;

      if (!questionsMap.containsKey(questionId)) {
        questionsMap[questionId] = {
          'id': questionId,
          'matiere': row['Matiere'],
          'devoir': row['Devoir'],
          'trimestre': row['Trimestre'],
          'question': row['Question'],
          'points': row['Points'],
          'options': [],
        };
      }

      questionsMap[questionId]!['options'].add({
        'text': row['OptionText'],
        'isCorrect': row['IsCorrect'] == 1,
      });
    }

    return questionsMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune question disponible.'));
          } else {
            final questions = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dans cet exercice, pour la matière ${widget.matiereNom}, évaluation '${widget.evaluationTitre}' - Trimestre ${widget.trimestres}, lisez les questions et trouvez la bonne réponse.",
                  style: const TextStyle(
                      fontSize: 16, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                ...questions.map((question) {
                  final index = questions.indexOf(question) + 1;
                  return QuestionWithOptions(
                    question: question,
                    index: index,
                    points: (question['points'] as num).toDouble(),
                  );
                }),
              ],
            );
          }
        },
      ),
    );
  }
}

class QuestionWithOptions extends StatefulWidget {
  final Map<String, dynamic> question;
  final int index;
  final double points;

  const QuestionWithOptions({
    super.key,
    required this.question,
    required this.index,
    required this.points,
  });

  @override
  _QuestionWithOptionsState createState() => _QuestionWithOptionsState();
}

class _QuestionWithOptionsState extends State<QuestionWithOptions> {
  int? selectedOption;

  @override
  Widget build(BuildContext context) {
    final question = widget.question;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          "${widget.index}. ${question["question"]}  (${widget.points} pts)",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Column(
          children: List.generate(question["options"].length, (index) {
            final option = question["options"][index];
            final isSelected = selectedOption == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedOption = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[50] : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[400]!,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? Colors.blue : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check,
                              size: 16, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        option['text'],
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.blue : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Divider(color: Colors.grey[400], thickness: 1),
      ],
    );
  }
}
