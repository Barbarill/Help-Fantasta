import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/asta.dart';

class AstaRepository {
  static const _chiaveConfig = 'asta_config';
  static const _chiaveAcquisti = 'asta_acquisti';

  Future<void> salvaConfig(AstaConfig? config) async {
    final prefs = await SharedPreferences.getInstance();
    if (config == null) {
      await prefs.remove(_chiaveConfig);
    } else {
      await prefs.setString(_chiaveConfig, jsonEncode(config.toJson()));
    }
  }

  Future<AstaConfig?> caricaConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final content = prefs.getString(_chiaveConfig);
    if (content == null || content.trim().isEmpty) return null;
    return AstaConfig.fromJson(jsonDecode(content) as Map<String, dynamic>);
  }

  Future<void> salvaAcquisti(List<Acquisto> acquisti) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = acquisti.map((a) => a.toJson()).toList();
    await prefs.setString(_chiaveAcquisti, jsonEncode(jsonList));
  }

  Future<List<Acquisto>> caricaAcquisti() async {
    final prefs = await SharedPreferences.getInstance();
    final content = prefs.getString(_chiaveAcquisti);
    if (content == null || content.trim().isEmpty) return [];
    final jsonList = jsonDecode(content) as List;
    return jsonList
        .map((j) => Acquisto.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}