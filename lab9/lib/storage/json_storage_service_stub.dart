class JsonStorageService {
  final Map<String, List<Map<String, dynamic>>> _memory = {};

  Future<List<Map<String, dynamic>>> readList(
    String fileName,
    List<Map<String, dynamic>> defaultData,
  ) async {
    _memory.putIfAbsent(fileName, () => defaultData);
    return _memory[fileName]!;
  }

  Future<void> writeList(
    String fileName,
    List<Map<String, dynamic>> data,
  ) async {
    _memory[fileName] = data;
  }
}
