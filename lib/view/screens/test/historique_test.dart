import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:challenger/database/database.dart';

class HistoriqueTest extends StatefulWidget {
  const HistoriqueTest({Key? key}) : super(key: key);

  @override
  _HistoriqueTestState createState() => _HistoriqueTestState();
}

class _HistoriqueTestState extends State<HistoriqueTest> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final db = await DatabaseHelper.getDatabase();
    final rows = await db.rawQuery('''
      SELECT
        ts.score,
        ts.max_score,
        
        t.titre        AS test_titre,
        m.title        AS matiere_titre,
        m.icon         AS matiere_icon,
        m.color        AS matiere_color
      FROM test_results ts
      JOIN test_results t ON ts.id = t.id
      JOIN matieres m ON t.matiere_id = m.id
      ORDER BY t.titre DESC
    ''');
    setState(() => _history = rows);
  }

  IconData _getIconFromName(String? iconName) {
    switch (iconName) {
      case 'calculate':
        return Icons.calculate;
      case 'science':
        return Icons.science;
      case 'biologie':
        return Icons.grass;
      case 'public':
        return Icons.public;
      case 'computer':
        return Icons.computer;
      case 'emoji_objects':
        return Icons.emoji_objects;
      case 'translate':
        return Icons.translate;
      case 'palette':
        return Icons.palette;
      case 'book':
        return Icons.book;
      case 'music_note':
        return Icons.music_note;
      case 'flask':
        return Icons.science;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'account_balance':
        return Icons.account_balance;
      default:
        return Icons.help;
    }
  }

  Color _getColorFromName(String? colorName) {
    switch (colorName?.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'deeppurple':
        return Colors.deepPurple;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      case 'pink':
        return Colors.pink;
      case 'yellow':
        return Colors.yellow;
      case 'cyan':
        return Colors.cyan;
      case 'indigo':
        return Colors.indigo;
      case 'lime':
        return Colors.lime;
      case 'amber':
        return Colors.amber;
      case 'teal':
        return Colors.teal;
      case 'brown':
        return Colors.brown;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'grey':
      case 'gray':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  String _fmtDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return DateFormat('dd MMM yyyy • HH:mm').format(dt);
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des Tests'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _history.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _history.length,
              itemBuilder: (ctx, i) {
                final row = _history[i];
                final score = row['score'] as int;
                final max = row['max_score'] as int;
                final pct = (score / max) * 100;
                final icon = _getIconFromName(row['matiere_icon'] as String?);
                final color =
                    _getColorFromName(row['matiere_color'] as String?);
                final title = row['test_titre'] as String? ?? '—';
                final mat = row['matiere_titre'] as String? ?? '—';
                final date = row['date'] as String? ?? '';

                return Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: color, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.2),
                      child: Icon(icon, color: color),
                    ),
                    title: Text(title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('$mat • ${_fmtDate(date)}'),
                    trailing: Text(
                      '${pct.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: pct >= 50 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => _showDetails(context, row, icon, color),
                  ),
                );
              },
            ),
    );
  }

  void _showDetails(
      BuildContext c, Map<String, dynamic> r, IconData icon, Color color) {
    final score = r['score'] as int;
    final max = r['max_score'] as int;
    final title = r['test_titre'] as String? ?? '';
    final mat = r['matiere_titre'] as String? ?? '';
    final date = r['date'] as String? ?? '';

    showModalBottomSheet(
      context: c,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(children: [
          Center(child: Icon(icon, size: 60, color: color)),
          const SizedBox(height: 12),
          Center(
              child: Text(
            title,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: color),
          )),
          const Divider(height: 24),
          _detailRow('Matière', mat),
          _detailRow('Score', '$score / $max'),
          _detailRow('Date', _fmtDate(date)),
        ]),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$label :', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
