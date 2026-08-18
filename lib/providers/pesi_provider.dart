import 'package:flutter/foundation.dart';
import '../services/punteggio_service.dart';

class PesiProvider extends ChangeNotifier {
  PesiPunteggio pesi = const PesiPunteggio();

  void aggiorna(PesiPunteggio nuovi) {
    pesi = nuovi;
    notifyListeners();
  }

  void reset() {
    pesi = const PesiPunteggio();
    notifyListeners();
  }
}