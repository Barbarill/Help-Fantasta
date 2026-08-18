import 'package:flutter/foundation.dart';
import '../models/giocatore.dart';
import '../services/papabili_repository.dart';

class PapabiliProvider extends ChangeNotifier {
  final PapabiliRepository _repository = PapabiliRepository();

  Map<Ruolo, List<int>> _papabili = {
    Ruolo.portiere: [],
    Ruolo.difensore: [],
    Ruolo.centrocampista: [],
    Ruolo.attaccante: [],
  };

  bool caricamento = false;

  List<int> perRuolo(Ruolo ruolo) => _papabili[ruolo] ?? [];

  bool isPapabile(int giocatoreId, Ruolo ruolo) =>
      perRuolo(ruolo).contains(giocatoreId);

  Future<void> carica() async {
    caricamento = true;
    notifyListeners();
    _papabili = await _repository.carica();
    caricamento = false;
    notifyListeners();
  }

  Future<void> aggiungi(Giocatore giocatore) async {
    final lista = List<int>.from(_papabili[giocatore.ruolo] ?? []);
    if (!lista.contains(giocatore.id)) {
      lista.add(giocatore.id);
      _papabili[giocatore.ruolo] = lista;
      await _repository.salva(_papabili);
      notifyListeners();
    }
  }

  Future<void> rimuovi(Giocatore giocatore) async {
    final lista = List<int>.from(_papabili[giocatore.ruolo] ?? []);
    lista.remove(giocatore.id);
    _papabili[giocatore.ruolo] = lista;
    await _repository.salva(_papabili);
    notifyListeners();
  }

  Future<void> riordina(Ruolo ruolo, int oldIndex, int newIndex) async {
    final lista = List<int>.from(_papabili[ruolo] ?? []);
    if (newIndex > oldIndex) newIndex -= 1;
    final id = lista.removeAt(oldIndex);
    lista.insert(newIndex, id);
    _papabili[ruolo] = lista;
    await _repository.salva(_papabili);
    notifyListeners();
  }
}