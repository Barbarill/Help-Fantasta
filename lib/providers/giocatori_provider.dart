import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/giocatore.dart';
import '../services/excel_import_service.dart';
import '../services/giocatori_repository.dart';

class GiocatoriProvider extends ChangeNotifier {
  final ExcelImportService _importService = ExcelImportService();
  final GiocatoriRepository _repository = GiocatoriRepository();

  List<Giocatore> _giocatori = [];
  bool caricamento = false;
  String? ultimoErrore;
  List<String> ultimeRigheScartate = [];

  List<Giocatore> get giocatori => _giocatori;

  Future<void> caricaDaStorage() async {
    caricamento = true;
    ultimoErrore = null;
    notifyListeners();
    try {
      _giocatori = await _repository.carica();
    } catch (e) {
      ultimoErrore = 'Errore nel caricamento dati salvati: $e';
    } finally {
      caricamento = false;
      notifyListeners();
    }
  }

  Future<void> importaStatistiche(Uint8List bytes) async {
    caricamento = true;
    ultimoErrore = null;
    notifyListeners();

    try {
      final risultato = _importService.importStatistiche(bytes);
      _giocatori = _repository.merge(_giocatori, risultato.giocatori);
      ultimeRigheScartate = risultato.righeScartate;
      await _repository.salva(_giocatori);
    } catch (e) {
      ultimoErrore = e.toString();
    } finally {
      caricamento = false;
      notifyListeners();
    }
  }
}