import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class JsonStorageService {
  Future<File> _getLocalFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  Future<List<Map<String, dynamic>>> readList(
    String fileName,
    List<Map<String, dynamic>> defaultData,
  ) async {
    final file = await _getLocalFile(fileName);

    if (!await file.exists()) {
      await writeList(fileName, defaultData);
      return defaultData;
    }

    final content = await file.readAsString();

    if (content.trim().isEmpty) {
      return [];
    }

    final decoded = jsonDecode(content);

    if (decoded is List) {
      return decoded.map((item) {
        return Map<String, dynamic>.from(item as Map);
      }).toList();
    }

    return [];
  }

  Future<void> writeList(
    String fileName,
    List<Map<String, dynamic>> data,
  ) async {
    final file = await _getLocalFile(fileName);
    final jsonString = jsonEncode(data);
    await file.writeAsString(jsonString);
  }
}
