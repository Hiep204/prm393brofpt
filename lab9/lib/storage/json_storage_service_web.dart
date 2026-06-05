import 'dart:convert';
import 'dart:html' as html;

class JsonStorageService {
  String _key(String fileName) {
    return 'lab9_$fileName';
  }

  Future<List<Map<String, dynamic>>> readList(
    String fileName,
    List<Map<String, dynamic>> defaultData,
  ) async {
    final key = _key(fileName);
    final content = html.window.localStorage[key];

    if (content == null || content.trim().isEmpty) {
      await writeList(fileName, defaultData);
      return defaultData;
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
    final key = _key(fileName);
    html.window.localStorage[key] = jsonEncode(data);
  }
}
