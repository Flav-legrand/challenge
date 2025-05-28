import 'package:flutter/material.dart';
import 'package:challenger/database/database.dart';

class EvaluationContents {
  // Partie I : Vérification des connaissances
  static Widget getKnowledgeRetrievalContent(
    Map<String, dynamic> matiere, {
    required void Function(int questionId, String answer) onAnswered,
  }) {
    return KnowledgeVerificationContent(
      points: 20,
      matiereNom: matiere['title'],
      evaluationTitre: '',
      trimestres: '',
      onAnswered: onAnswered,
    );
  }

  // Partie II : Application des connaissances
  static Widget getKnowledgeApplicationContent(Map<String, dynamic> matiere) {
    return KnowledgeApplicationContent(
      matiere: matiere,
      matiereNoms: matiere['title'],
      matiereNom: '',
    );
  }

  // Partie III : Cas pratique
  static Widget getPracticalCaseContent(Map<String, dynamic> matiere) {
    return PracticalCaseContent(matiere: {}, matiereNom: matiere['nom']);
  }
}

// Partie I : Vérification des connaissances
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

    final result = await db.rawQuery(
      '''
      SELECT 
        m.title AS Matiere,
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
     
        WHERE LOWER(m.title) = LOWER(?);
      ''',
      [widget.matiereNom.trim()],
    );

    Map<int, Map<String, dynamic>> questionsMap = {};

    for (var row in result) {
      final questionId = row['QuestionId'] as int;
      questionsMap.putIfAbsent(questionId, () {
        return {
          'id': questionId,
          'matiere': row['Matiere'],
          'test': row['Test'],
          'question': row['Question'],
          'points': row['Points'],
          'options': [],
        };
      });

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
                  "Dans ce test de ${widget.matiereNom}, lisez les questions et trouvez la bonne réponse.",
                  style: const TextStyle(
                      fontSize: 16, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                ...questions.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final question = entry.value;
                  return QuestionWithOptions(
                    question: question,
                    index: index,
                    onAnswered: widget.onAnswered,
                  );
                }).toList(),
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
                widget.onAnswered(
                  widget.question['id'],
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
                              ? const Icon(Icons.check,
                                  size: 16, color: Colors.white)
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

// Partie II : Application des connaissances
class KnowledgeApplicationContent extends StatefulWidget {
  final Map<String, dynamic> matiere;
  final String matiereNom;
  final String matiereNoms;

  const KnowledgeApplicationContent({
    required this.matiere,
    required this.matiereNom,
    required this.matiereNoms,
  });

  @override
  _KnowledgeApplicationContentState createState() =>
      _KnowledgeApplicationContentState();
}

class _KnowledgeApplicationContentState
    extends State<KnowledgeApplicationContent> {
  late Future<List<Map<String, dynamic>>> questionsFuture;

  @override
  void initState() {
    super.initState();
    questionsFuture = fetchQuestionsFromDatabase();
  }

  Future<List<Map<String, dynamic>>> fetchQuestionsFromDatabase() async {
    final db = await DatabaseHelper.getDatabase();

    final result = await db.rawQuery(
      '''
     SELECT 
    q.id AS QuestionId,
    q.question AS Question,
    q.points AS Points,  
    m.title AS Matiere
FROM 
    questions q
INNER JOIN 
    devoirs d ON q.devoir_id = d.id
INNER JOIN 
    matieres m ON d.matiere_id = m.id

    WHERE LOWER(m.title) = LOWER(?)
    AND q.type = 'Vérification des connaissances'
LIMIT 5;
      ''',
      [widget.matiereNom.trim()],
    );

    if (result.isEmpty) {
      throw Exception("Aucune question trouvée pour cette matière");
    }

    return result;
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
                const Text(
                  "Dans cette section, vous devrez appliquer vos connaissances de manière concrète.",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                ...questions.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final question = entry.value;
                  return ApplicationQuestionWithTextField(
                    question: question,
                    index: index,
                  );
                }).toList(),
              ],
            );
          }
        },
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
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.question;
    final points =
        question["Points"] != null ? question["Points"] : "Non défini";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          "${widget.index}. ${question["Question"]}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: "Votre réponse",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Points : $points",
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        Divider(color: Colors.grey[400], thickness: 1),
      ],
    );
  }
}

// Classe pour le contenu de la Partie III : Cas pratique

class PracticalCaseContent extends StatefulWidget {
  final Map<String, dynamic> matiere;
  final String matiereNom;

  const PracticalCaseContent({required this.matiere, required this.matiereNom});

  @override
  _PracticalCaseContentState createState() => _PracticalCaseContentState();
}

class _PracticalCaseContentState extends State<PracticalCaseContent> {
  late Future<List<Map<String, dynamic>>> practicalCasesFuture;

  @override
  void initState() {
    super.initState();
    practicalCasesFuture = fetchPracticalCasesFromDatabase();
  }

  Future<List<Map<String, dynamic>>> fetchPracticalCasesFromDatabase() async {
    final db = await DatabaseHelper.getDatabase();

    final result = await db.rawQuery(
      '''
      SELECT 
    q.id AS QuestionId,
    q.question AS Question,
    q.points AS Points,  
    m.title AS Matiere
FROM 
    questions q
INNER JOIN 
    devoirs d ON q.devoir_id = d.id
INNER JOIN 
    matieres m ON d.matiere_id = m.id

    WHERE LOWER(m.title) = LOWER(?)
    AND q.type = 'cas_pratique'
LIMIT 1;
      ''',
      [widget.matiereNom.trim()],
    );

    if (result.isEmpty) {
      throw Exception("Aucun cas pratique trouvé pour cette matière.");
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: practicalCasesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun cas pratique disponible.'));
          } else {
            final practicalCases = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Dans cette section, vous devrez résoudre des cas pratiques basés sur vos connaissances.",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                ...practicalCases.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final practicalCase = entry.value;
                  return PracticalCaseItem(
                    practicalCase: practicalCase,
                    index: index,
                  );
                }).toList(),
              ],
            );
          }
        },
      ),
    );
  }
}

class PracticalCaseItem extends StatelessWidget {
  final Map<String, dynamic> practicalCase;
  final int index;

  const PracticalCaseItem({
    required this.practicalCase,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final points = practicalCase["Points"]?.toString() ?? "Non défini";
    final questionText = practicalCase["Question"] ?? "Énoncé non disponible";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          "$index. $questionText",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextField(
          decoration: const InputDecoration(
            hintText: "Votre réponse",
            border: OutlineInputBorder(),
          ),
          minLines: 4, // Hauteur minimale (4 lignes)
          maxLines: 8, // Hauteur maximale
        ),
        const SizedBox(height: 26),
        Text(
          "Points : $points",
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        Divider(color: Colors.grey[400], thickness: 1),
      ],
    );
  }
}
