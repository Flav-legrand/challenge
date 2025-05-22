import 'package:flutter/material.dart';
import 'package:challenger/database/database.dart';

class EvaluationContents {
  // Contenu pour la Partie I : Vérification des connaissances
  static Widget getKnowledgeRetrievalContent(Map<String, dynamic> matiere,
      {required void Function(int questionId, String answer) onAnswered}) {
    return KnowledgeVerificationContent(
      points: 20,
      matiereNom: matiere['title'],
      evaluationTitre: '',
      trimestres: '',
      onAnswered: onAnswered,
    );
  }

  // Contenu pour la Partie II : Application des connaissances
  static Widget getKnowledgeApplicationContent(Map<String, dynamic> matiere) {
    return KnowledgeApplicationContent();
  }

  // Contenu pour la Partie III : Cas pratique
  static Widget getPracticalCaseContent(Map<String, dynamic> matiere) {
    return PracticalCaseContent();
  }
}

// Contenu dynamique pour la Partie I : Vérification des connaissances
class KnowledgeVerificationContent extends StatefulWidget {
  final String matiereNom;
  final String evaluationTitre;
  final String trimestres;
  final int points;
  final void Function(int questionId, String answer) onAnswered;

  const KnowledgeVerificationContent({
    required this.matiereNom,
    required this.evaluationTitre,
    required this.trimestres,
    required this.points,
    required this.onAnswered,
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
      m.title AS Matiere, -- Assure-toi que le champ est bien 'name' dans la table 'matieres'
      t.titre AS Test,
      q.id AS QuestionId,
      q.question AS Question,
      q.points AS Points,
      o.option_text AS OptionText,
      o.is_correct AS IsCorrect
    FROM 
      matieres m
    INNER JOIN 
      test_results t ON m.id = t.matiere_id
    INNER JOIN 
      test_questions q ON t.id = q.test_id
    INNER JOIN 
      test_options o ON q.id = o.question_id
    WHERE 
      m.title = ?;
    ''',
      [widget.matiereNom], // Trim pour éviter les espaces indésirables
    );

    Map<int, Map<String, dynamic>> questionsMap = {};

    for (var row in result) {
      final questionId = row['QuestionId'] as int;

      if (!questionsMap.containsKey(questionId)) {
        questionsMap[questionId] = {
          'id': questionId,
          'matiere': row['Matiere'],
          'test': row['Test'],
          'question': row['Question'],
          'points': row['Points'],
          'options': [],
        };
      }

      // Ajoute chaque option à la liste correspondante
      questionsMap[questionId]!['options'].add({
        'optionText': row['OptionText'],
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
                  "Dans ce test de ${widget.matiereNom} lisez les questions et trouvez la bonne réponse.",
                  style: const TextStyle(
                      fontSize: 16, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                ...questions.map((question) {
                  final index = questions.indexOf(question) + 1;
                  return QuestionWithOptions(
                    question: question,
                    index: index,
                    onAnswered: widget.onAnswered,
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
  final void Function(int questionId, String answer) onAnswered;

  const QuestionWithOptions({
    required this.question,
    required this.index,
    required this.onAnswered,
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
          "${widget.index}. ${question["question"]}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                widget.onAnswered(
                  widget.question['id'], // ID de la question
                  option['optionText'],
                );
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[50] : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isSelected ? Colors.blue : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey,
                            ),
                          ),
                          child: isSelected
                              ? Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            option['optionText'],
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected ? Colors.blue : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey[400], thickness: 1),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Text(
          "Points : ${question["points"]}",
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        Divider(color: Colors.grey[400], thickness: 1),
      ],
    );
  }
}

class KnowledgeApplicationContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> questions = [
      {
        "question":
            "Expliquez comment vous pourriez résoudre un conflit en équipe.",
        "points": 10,
      },
      {
        "question":
            "Décrivez les étapes de la résolution d’un problème technique.",
        "points": 10,
      },
      {
        "question":
            "Proposez une méthode pour organiser efficacement une réunion.",
        "points": 10,
      },
      {
        "question":
            "Comment mesurer le succès d’un projet après sa livraison ?",
        "points": 10,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dans cette section, vous devrez appliquer vos connaissances de manière concrète.",
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10),
          Column(
            children: List.generate(
              questions.length,
              (index) => ApplicationQuestionWithTextField(
                question: questions[index],
                index: index + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ApplicationQuestionWithTextField extends StatefulWidget {
  final Map<String, dynamic> question;
  final int index;

  const ApplicationQuestionWithTextField({
    required this.question,
    required this.index,
  });

  @override
  _ApplicationQuestionWithTextFieldState createState() =>
      _ApplicationQuestionWithTextFieldState();
}

class _ApplicationQuestionWithTextFieldState
    extends State<ApplicationQuestionWithTextField> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final question = widget.question;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          "${widget.index}. ${question["question"]}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _controller,
          maxLines: 4,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Votre réponse ici...',
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Points : ${question["points"]}",
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        Divider(color: Colors.grey[400], thickness: 1),
      ],
    );
  }
}

class PracticalCaseContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cas pratique à traiter dans cette section.",
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10),
          TextField(
            maxLines: 10,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Détails du cas pratique...',
            ),
          ),
        ],
      ),
    );
  }
}
