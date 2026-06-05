import 'package:flutter/material.dart';

import 'core_widgets_demo.dart';
import 'input_controls_demo.dart';
import 'layout_basics_demo.dart';
import 'scaffold_theme_demo.dart';
import 'debug_fix_demo.dart';

void main() {
  runApp(const Lab4App());
}

class Lab4App extends StatelessWidget {
  const Lab4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 - Flutter UI Fundamentals',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const Lab4HomePage(),
    );
  }
}

class Lab4HomePage extends StatelessWidget {
  const Lab4HomePage({super.key});

  // Hàm dùng để mở từng màn hình bài tập
  void _openPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  // Widget tạo button cho từng exercise
  Widget _buildExerciseButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget page,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _openPage(context, page),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold tạo cấu trúc màn hình cơ bản
      appBar: AppBar(
        title: const Text('Lab 4 - Flutter UI Fundamentals'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Choose an Exercise',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            _buildExerciseButton(
              context: context,
              title: 'Exercise 1',
              subtitle: 'Core Widgets: Text, Image, Icon, Card, ListTile',
              icon: Icons.widgets,
              page: CoreWidgetsDemo(),
            ),

            _buildExerciseButton(
              context: context,
              title: 'Exercise 2',
              subtitle: 'Input Widgets: Slider, Switch, Radio, DatePicker',
              icon: Icons.input,
              page: InputControlsDemo(),
            ),

            _buildExerciseButton(
              context: context,
              title: 'Exercise 3',
              subtitle: 'Layout Basics: Column, Row, Padding, ListView',
              icon: Icons.dashboard,
              page: LayoutBasicsDemo(),
            ),

            _buildExerciseButton(
              context: context,
              title: 'Exercise 4',
              subtitle: 'Scaffold, AppBar, FAB, ThemeData, Dark Mode',
              icon: Icons.phone_android,
              page: ScaffoldThemeDemoApp(),
            ),

            _buildExerciseButton(
              context: context,
              title: 'Exercise 5',
              subtitle: 'Debug & Fix Common UI Errors',
              icon: Icons.bug_report,
              page: DebugFixDemo(),
            ),
          ],
        ),
      ),
    );
  }
}
