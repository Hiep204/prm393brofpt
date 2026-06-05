import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 1 - Core Widgets'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Flutter Core Widgets',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              const Text(
                'This screen demonstrates Text, Icon, Image, Card and ListTile.',
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 24),

              const Center(
                child: Icon(Icons.flutter_dash, size: 90, color: Colors.blue),
              ),

              const SizedBox(height: 24),

              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://picsum.photos/600/300',
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: Colors.grey,
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 60),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              Card(
                elevation: 4,
                child: const ListTile(
                  leading: Icon(Icons.phone_android, color: Colors.blue),
                  title: Text(
                    'Mobile UI Design',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Card widget containing a ListTile'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),

              const SizedBox(height: 16),

              Card(
                elevation: 4,
                child: const ListTile(
                  leading: Icon(Icons.star, color: Colors.orange),
                  title: Text('Flutter is flexible'),
                  subtitle: Text('You can build beautiful UI using widgets.'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
