import 'package:flutter/material.dart';

class DebugFixDemo extends StatefulWidget {
  const DebugFixDemo({super.key});

  @override
  State<DebugFixDemo> createState() => _DebugFixDemoState();
}

class _DebugFixDemoState extends State<DebugFixDemo> {
  int counter = 0;
  DateTime? selectedDate;

  final List<String> items = List.generate(
    20,
    (index) => 'Fixed List Item ${index + 1}',
  );

  String get formattedDate {
    if (selectedDate == null) {
      return 'No date selected';
    }

    return '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
  }

  Future<void> _chooseDate() async {
    // DatePicker được gọi từ context hợp lệ trong widget tree
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      // setState giúp cập nhật lại giao diện
      setState(() {
        selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 - Debug & Fix UI Errors'),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // Expanded giúp phần nội dung phía trên có kích thước hợp lý
          Expanded(
            child: SingleChildScrollView(
              // SingleChildScrollView giúp sửa lỗi overflow khi màn hình nhỏ
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Common UI Errors Fixed',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildFixCard(
                      title: 'Fix 1: ListView inside Column',
                      description:
                          'Use Expanded to give ListView a clear height when it is placed inside Column.',
                      icon: Icons.list,
                    ),

                    _buildFixCard(
                      title: 'Fix 2: Overflow on small screens',
                      description:
                          'Use SingleChildScrollView when the content may be taller than the screen.',
                      icon: Icons.open_in_full,
                    ),

                    _buildFixCard(
                      title: 'Fix 3: State update issue',
                      description:
                          'Use setState() when changing variables that appear on the UI.',
                      icon: Icons.refresh,
                    ),

                    _buildFixCard(
                      title: 'Fix 4: DatePicker context error',
                      description:
                          'Call showDatePicker from a valid BuildContext inside the widget tree.',
                      icon: Icons.calendar_month,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'setState() Demo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Counter: $counter',
                      style: const TextStyle(fontSize: 18),
                    ),

                    const SizedBox(height: 8),

                    ElevatedButton.icon(
                      onPressed: () {
                        // Nếu không có setState, số counter thay đổi nhưng UI không cập nhật
                        setState(() {
                          counter++;
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Increase Counter'),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'DatePicker Demo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Selected Date: $formattedDate',
                      style: const TextStyle(fontSize: 18),
                    ),

                    const SizedBox(height: 8),

                    ElevatedButton.icon(
                      onPressed: _chooseDate,
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Choose Date'),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          // Khu vực này minh họa sửa lỗi ListView nằm trong Column
          Container(
            height: 240,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: const Border(top: BorderSide(color: Colors.grey)),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fixed ListView inside Column',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                // Expanded là cách sửa lỗi ListView không có chiều cao trong Column
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.check_circle),
                          title: Text(items[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget phụ để tránh lặp code Card nhiều lần
  Widget _buildFixCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
