import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  // Biến lưu giá trị Slider
  double volume = 50;

  // Biến lưu trạng thái Switch
  bool isNotificationOn = true;

  // Biến lưu lựa chọn Radio
  String selectedLevel = 'Beginner';

  // Biến lưu ngày được chọn
  DateTime? selectedDate;

  // Hàm định dạng ngày tháng cho dễ nhìn
  String get formattedDate {
    if (selectedDate == null) {
      return 'No date selected';
    }

    return '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
  }

  // Hàm mở DatePicker
  Future<void> _pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2035),
    );

    // Nếu người dùng chọn ngày thì cập nhật giao diện bằng setState
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2 - Input Widgets'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Input Controls Demo',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // Slider cho phép người dùng kéo để chọn giá trị
              Text(
                'Volume: ${volume.round()}',
                style: const TextStyle(fontSize: 18),
              ),

              Slider(
                value: volume,
                min: 0,
                max: 100,
                divisions: 10,
                label: volume.round().toString(),
                onChanged: (value) {
                  // setState giúp Flutter vẽ lại UI khi dữ liệu thay đổi
                  setState(() {
                    volume = value;
                  });
                },
              ),

              const Divider(height: 32),

              // Switch dùng để bật / tắt một chức năng
              SwitchListTile(
                title: const Text('Enable Notifications'),
                subtitle: const Text('Turn notification setting on or off'),
                value: isNotificationOn,
                onChanged: (value) {
                  setState(() {
                    isNotificationOn = value;
                  });
                },
              ),

              const Divider(height: 32),

              const Text(
                'Choose your level:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              // RadioListTile nhóm lựa chọn, mỗi lần chỉ chọn được một option
              RadioListTile<String>(
                title: const Text('Beginner'),
                value: 'Beginner',
                groupValue: selectedLevel,
                onChanged: (value) {
                  setState(() {
                    selectedLevel = value!;
                  });
                },
              ),

              RadioListTile<String>(
                title: const Text('Intermediate'),
                value: 'Intermediate',
                groupValue: selectedLevel,
                onChanged: (value) {
                  setState(() {
                    selectedLevel = value!;
                  });
                },
              ),

              RadioListTile<String>(
                title: const Text('Advanced'),
                value: 'Advanced',
                groupValue: selectedLevel,
                onChanged: (value) {
                  setState(() {
                    selectedLevel = value!;
                  });
                },
              ),

              const Divider(height: 32),

              // DatePicker được mở bằng button
              ElevatedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_month),
                label: const Text('Choose Date'),
              ),

              const SizedBox(height: 20),

              // Hiển thị toàn bộ giá trị đã chọn
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Values',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text('Volume: ${volume.round()}'),
                      Text('Notifications: ${isNotificationOn ? "On" : "Off"}'),
                      Text('Selected Level: $selectedLevel'),
                      Text('Selected Date: $formattedDate'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
