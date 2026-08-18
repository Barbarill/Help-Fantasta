import 'package:flutter/foundation.dart';
import '../models/asta.dart';
import '../models/giocatore.dart';
import '../services/asta_repository.dart';

class AstaProvider extends ChangeNotifier {
  final AstaRepository _repository = AstaRepository();

  AstaConfig? config;
  List<Acquisto> acquisti = [];
  bool caricamento = false;

  double get budgetSpeso => acquisti.fold(0, (tot, a) => tot + a.prezzo);

  double get budgetRimanente =>
      (config?.budgetTotale ?? 0) - budgetSpeso;

  int slotOccupati(Ruolo ruolo) =>
      acquisti.where((a) => a.ruolo == ruolo).length;

  int slotLiberi(Ruolo ruolo) {
    if (config == null) return 0;
    return config!.slotPerRuolo(ruolo) - slotOccupati(ruolo);
  }

  double spesoPerRuolo(Ruolo ruolo) => acquisti
      .where((a) => a.ruolo == ruolo)
      .fold(0, (tot, a) => tot + a.prezzo);

  bool get astaConfigurata => config != null;

  bool giaAcquistato(int giocatoreId) =>
      acquisti.any((a) => a.giocatoreId == giocatoreId);

  Future<void> carica() async {
    caricamento = true;
    notifyListeners();
    config = await _repository.caricaConfig();
    acquisti = await _repository.caricaAcquisti();
    caricamento = false;
    notifyListeners();
  }

  Future<void> impostaConfig(AstaConfig nuovaConfig) async {
    config = nuovaConfig;
    await _repository.salvaConfig(config);
    notifyListeners();
  }

  Future<void> aggiungiAcquisto(Giocatore giocatore, double prezzo) async {
    if (giaAcquistato(giocatore.id)) return;
    acquisti.add(Acquisto(
      giocatoreId: giocatore.id,
      ruolo: giocatore.ruolo,
      prezzo: prezzo,
    ));
    await _repository.salvaAcquisti(acquisti);
    notifyListeners();
  }

  Future<void> rimuoviAcquisto(int giocatoreId) async {
    acquisti.removeWhere((a) => a.giocatoreId == giocatoreId);
    await _repository.salvaAcquisti(acquisti);
    notifyListeners();
  }

  Future<void> reset() async {
    config = null;
    acquisti = [];
    await _repository.salvaConfig(null);
    await _repository.salvaAcquisti([]);
    notifyListeners();
  }
}