import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/giocatore.dart';

class GiocatoriRepository {
  static const _chiave = 'giocatori_data';

  /// Unisce una nuova lista di giocatori (es. da un nuovo import) con
  /// quella esistente, usando l'id come chiave. copyWith arricchisce
  /// i campi non nulli senza cancellare dati già presenti.
  List<Giocatore> merge(List<Giocatore> esistenti, List<Giocatore> nuovi) {
    final mappa = {for (final g in esistenti) g.id: g};

    for (final nuovo in nuovi) {
      final attuale = mappa[nuovo.id];
      if (attuale == null) {
        mappa[nuovo.id] = nuovo;
      } else {
        mappa[nuovo.id] = attuale.copyWith(
          quotazione: nuovo.quotazione,
          fvm: nuovo.fvm,
          presenze: nuovo.presenze,
          mediaVoto: nuovo.mediaVoto,
          fantamedia: nuovo.fantamedia,
          golFatti: nuovo.golFatti,
          golSubiti: nuovo.golSubiti,
          rigoriParati: nuovo.rigoriParati,
          rigoriCalciati: nuovo.rigoriCalciati,
          rigoriSegnati: nuovo.rigoriSegnati,
          rigoriSbagliati: nuovo.rigoriSbagliati,
          assist: nuovo.assist,
          ammonizioni: nuovo.ammonizioni,
          espulsioni: nuovo.espulsioni,
          autogol: nuovo.autogol,
        );
      }
    }
    return mappa.values.toList();
  }

  Future<void> salva(List<Giocatore> giocatori) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = giocatori.map((g) => g.toJson()).toList();
    await prefs.setString(_chiave, jsonEncode(jsonList));
  }

  Future<List<Giocatore>> carica() async {
    final prefs = await SharedPreferences.getInstance();
    final content = prefs.getString(_chiave);
    if (content == null || content.trim().isEmpty) return [];
    final jsonList = jsonDecode(content) as List;
    return jsonList
        .map((j) => Giocatore.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}