import 'dart:convert';
import 'package:flutter/services.dart';

class LocalLevelDataSource {
  const LocalLevelDataSource();

  Future<List<Map<String, dynamic>>> loadLevelsJson() async {
    final jsonString = await rootBundle.loadString('assets/data/levels.json');
    final decoded = jsonDecode(jsonString) as List<dynamic>;

    return decoded.map((item) => item as Map<String, dynamic>).toList();
  }
}
