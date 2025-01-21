import 'package:flutter/material.dart';
import 'package:challenger/controler/evaluation/evaluation.dart';

class EvaluationContents {
  // Contenu pour la Partie I : Vérification des connaissances
  static Widget getKnowledgeRetrievalContent(Map<String, dynamic> matiere) {
    return KnowledgeVerificationContent(points: 20);
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
class KnowledgeVerificationContent extends StatelessWidget {
  final int points;

  const KnowledgeVerificationContent({required this.points});

  @override
  Widget build(BuildContext context) {
    final QuestionController questionController = QuestionController();

    return FutureBuilder(
      future: questionController.loadAndFormatQuestions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Affichage d'un indicateur de chargement
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Affichage d'un message d'erreur
          return Center(child: Text("Une erreur s'est produite lors du chargement des questions."));
        } else {
          // Récupération des questions formatées
          final List<Map<String, dynamic>> questions = questionController.getFormattedQuestions();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dans cet exercice, lisez les questions et trouvez la bonne réponse.",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                Column(
                  children: List.generate(
                    questions.length,
                        (index) => QuestionWithOptions(
                      question: questions[index],
                      index: index + 1,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

}

class QuestionWithOptions extends StatefulWidget {
  final Map<String, dynamic> question;
  final int index;

  const QuestionWithOptions({
    required this.question,
    required this.index,
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
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      // Annulation de la couleur de fond et du contour
                      color: isSelected ? Colors.blue[50] : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      // Retrait de l'ombre portée
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent, // Pas de bordure sauf si sélectionnée
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Re-ajout des puces à gauche avec la même couleur que le texte
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? Colors.blue : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey, // Couleur de la bordure des puces
                            ),
                          ),
                          child: isSelected
                              ? Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected ? Colors.blue : Colors.black, // Couleur du texte
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Séparateur horizontal entre les options
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
class KnowledgeApplicationContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> questions = [
      {
        "question": "Expliquez comment vous pourriez résoudre un conflit en équipe.",
        "points": 10,
      },
      {
        "question": "Décrivez les étapes de la résolution d’un problème technique.",
        "points": 10,
      },
      {
        "question": "Proposez une méthode pour organiser efficacement une réunion.",
        "points": 10,
      },
      {
        "question": "Comment mesurer le succès d’un projet après sa livraison ?",
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
        const SizedBox(height: 5),
        TextField(
          controller: _controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: "Votre réponse ici...",
            border: OutlineInputBorder(),
          ),
          style: TextStyle(fontSize: 14),
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

// Partie III : Cas pratique
class PracticalCaseContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> caseStudy = {
      "title": "Cas pratique : Résolution de conflit",
      "description":
      "Vous êtes responsable d’une équipe qui fait face à un conflit majeur. Identifiez les points bloquants, proposez des solutions, et élaborez un plan pour résoudre la situation.",
      "points": 20,
    };

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dans cette section, vous devrez résoudre un cas pratique en proposant une solution détaillée.",
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10),
          CaseStudyQuestion(
            caseStudy: caseStudy,
          ),
        ],
      ),
    );
  }
}

class CaseStudyQuestion extends StatefulWidget {
  final Map<String, dynamic> caseStudy;

  const CaseStudyQuestion({required this.caseStudy});

  @override
  _CaseStudyQuestionState createState() => _CaseStudyQuestionState();
}

class _CaseStudyQuestionState extends State<CaseStudyQuestion> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final caseStudy = widget.caseStudy;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          caseStudy["title"],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          caseStudy["description"],
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _controller,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: "Proposez votre solution...",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Points : ${caseStudy["points"]}",
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
