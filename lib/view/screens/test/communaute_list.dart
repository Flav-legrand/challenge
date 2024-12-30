import 'package:flutter/material.dart';

class CommunauteList extends StatefulWidget {
  const CommunauteList({Key? key}) : super(key: key);

  @override
  _CommunauteListState createState() => _CommunauteListState();
}

class _CommunauteListState extends State<CommunauteList> {
  final List<Map<String, dynamic>> _communautes = List.generate(
    10,
        (index) => {
      'nom': 'Communauté ${index + 1}',
      'description': 'Description de la communauté ${index + 1}',
      'rang': '${index + 1}ème place',
      'membres': 1500 - (index * 100),
      'niveau': index % 2 == 0 ? 'Terminale D' : 'Première C',
      'tests': 50 + (index * 5),
      'points': 1000 - (index * 50),
    },
  );

  int _selectedIndex = -1;

  void _toggleExpand(int index) {
    setState(() {
      _selectedIndex = (_selectedIndex == index) ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Communautés',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        itemCount: _communautes.length,
        itemBuilder: (context, index) {
          final communaute = _communautes[index];
          final isSelected = _selectedIndex == index;

          return Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blueAccent.withOpacity(0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: const Icon(
                      Icons.group,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    communaute['nom'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    communaute['description'],
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: Icon(
                    isSelected
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.blueAccent,
                  ),
                  onTap: () => _toggleExpand(index),
                ),
              ),
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Rang', communaute['rang']),
                      const SizedBox(height: 10),
                      _buildDetailRow('Membres', '${communaute['membres']} membres'),
                      const SizedBox(height: 10),
                      _buildDetailRow('Niveau', communaute['niveau']),
                      const SizedBox(height: 10),
                      _buildDetailRow('Tests effectués', '${communaute['tests']} tests'),
                      const SizedBox(height: 10),
                      _buildDetailRow('Points globaux', '${communaute['points']} points'),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              print('J\'aime la communauté ${communaute['nom']}');
                            },
                            icon: const Icon(Icons.favorite, color: Colors.white),
                            label: const Text(
                              'J\'aime',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              print('Pas mal pour ${communaute['nom']}');
                            },
                            icon: const Icon(Icons.thumb_up, color: Colors.white),
                            label: const Text(
                              'Pas mal',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}
