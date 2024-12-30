import 'package:flutter/material.dart';
import 'package:challenger/view/screens/home.dart'; // Page d'accueil
import 'package:challenger/view/screens/test.dart'; // Page de test
import 'package:challenger/view/screens/evaluation.dart'; // Page d'évaluation
import 'package:challenger/view/screens/competition.dart'; // Page de compétition
import 'package:challenger/view/theme/color.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> with TickerProviderStateMixin {
  int _activeTab = 0;

  final List<Map<String, dynamic>> _barItems = [
    {
      "icon": Icons.home_outlined,
      "active_icon": Icons.home,
      "page": HomePage(),
      "label": "Accueil",
    },
    {
      "icon": Icons.assignment_outlined,
      "active_icon": Icons.assignment,
      "page": TestPage(),
      "label": "Test",
    },
    {
      "icon": Icons.school_outlined,
      "active_icon": Icons.school,
      "page": EvaluationPage(),
      "label": "Évaluation",
    },
    {
      "icon": Icons.emoji_events_outlined,
      "active_icon": Icons.emoji_events,
      "page": CompetitionPage(),
      "label": "Compétition",
    },
  ];

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    _controller.reset();
    setState(() {
      _activeTab = index;
    });
    _controller.forward();
  }

  Widget _buildPage() {
    return IndexedStack(
      index: _activeTab,
      children: List.generate(
        _barItems.length,
            (index) => FadeTransition(
          opacity: _animation,
          child: _barItems[index]["page"],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 75,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.bottomBarColor,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_barItems.length, (index) {
          final isActive = _activeTab == index;
          return GestureDetector(
            onTap: () => onPageChanged(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isActive)
                  Container(
                    height: 3,
                    width: 20,
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                Icon(
                  isActive
                      ? _barItems[index]["active_icon"]
                      : _barItems[index]["icon"],
                  color: isActive ? AppColor.primary : AppColor.inactive,
                ),
                const SizedBox(height: 4),
                Text(
                  _barItems[index]["label"],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? AppColor.primary : AppColor.inactive,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      bottomNavigationBar: _buildBottomBar(),
      body: _buildPage(),
    );
  }
}
