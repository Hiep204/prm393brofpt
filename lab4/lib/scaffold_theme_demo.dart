import 'package:flutter/material.dart';

class ScaffoldThemeDemoApp extends StatefulWidget {
  const ScaffoldThemeDemoApp({super.key});

  @override
  State<ScaffoldThemeDemoApp> createState() => _ScaffoldThemeDemoAppState();
}

class _ScaffoldThemeDemoAppState extends State<ScaffoldThemeDemoApp> {
  // Biến kiểm tra có bật dark mode hay không
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    // Lưu context bên ngoài MaterialApp để nút back có thể quay lại màn hình chính
    final outerContext = context;

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Theme sáng
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),

      // Theme tối
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),

      // themeMode thay đổi theo biến isDarkMode
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(outerContext).pop();
            },
          ),
          title: const Text('Exercise 4 - Scaffold & Theme'),
          centerTitle: true,
        ),

        body: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Complete Screen Structure',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              const Text(
                'This screen uses Scaffold, AppBar, Body, FloatingActionButton and ThemeData.',
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 24),

              Card(
                child: SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text(
                    'Toggle themeMode between light and dark',
                  ),
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.color_lens),
                  title: const Text('ThemeData'),
                  subtitle: Text(
                    isDarkMode
                        ? 'Dark theme is currently active'
                        : 'Light theme is currently active',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Card(
                child: ListTile(
                  leading: Icon(Icons.smartphone),
                  title: Text('Scaffold Structure'),
                  subtitle: Text('AppBar + Body + FloatingActionButton'),
                ),
              ),
            ],
          ),
        ),

        // FloatingActionButton nằm góc dưới bên phải màn hình
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('FloatingActionButton clicked!')),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
