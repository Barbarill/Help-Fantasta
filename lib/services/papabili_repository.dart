import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/giocatore.dart';

class PapabiliRepository {
  static const _chiave = 'papabili_data';

  Future<void> salva(Map<Ruolo, List<int>> papabili) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonMap = papabili.map((ruolo, ids) => MapEntry(ruolo.sigla, ids));
    await prefs.setString(_chiave, jsonEncode(jsonMap));
  }

  Future<Map<Ruolo, List<int>>> carica() async {
    final prefs = await SharedPreferences.getInstance();
    final content = prefs.getString(_chiave);

    final base = {
      Ruolo.portiere: <int>[],
      Ruolo.difensore: <int>[],
      Ruolo.centrocampista: <int>[],
      Ruolo.attaccante: <int>[],
    };

    if (content == null || content.trim().isEmpty) return base;

    final jsonMap = jsonDecode(content) as Map<String, dynamic>;
    for (final entry in jsonMap.entries) {
      final ruolo = RuoloExtension.fromSigla(entry.key);
      base[ruolo] = List<int>.from(entry.value as List);
    }
    return base;
  }
}