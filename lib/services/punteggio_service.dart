import '../models/giocatore.dart';

class PesiPunteggio {
  final double fantamedia;
  final double gol;
  final double assist;
  final double rigoriSegnati;
  final double ammonizioni;
  final double espulsioni;
  final double autogol;
  final double rigoriParati;
  final double golSubitiAPartita;

  const PesiPunteggio({
    this.fantamedia = 10,
    this.gol = 3,
    this.assist = 2,
    this.rigoriSegnati = 2,
    this.ammonizioni = 0.5,
    this.espulsioni = 2,
    this.autogol = 1,
    this.rigoriParati = 3,
    this.golSubitiAPartita = 5,
  });

  PesiPunteggio copyWith({
    double? fantamedia,
    double? gol,
    double? assist,
    double? rigoriSegnati,
    double? ammonizioni,
    double? espulsioni,
    double? autogol,
    double? rigoriParati,
    double? golSubitiAPartita,
  }) {
    return PesiPunteggio(
      fantamedia: fantamedia ?? this.fantamedia,
      gol: gol ?? this.gol,
      assist: assist ?? this.assist,
      rigoriSegnati: rigoriSegnati ?? this.rigoriSegnati,
      ammonizioni: ammonizioni ?? this.ammonizioni,
      espulsioni: espulsioni ?? this.espulsioni,
      autogol: autogol ?? this.autogol,
      rigoriParati: rigoriParati ?? this.rigoriParati,
      golSubitiAPartita: golSubitiAPartita ?? this.golSubitiAPartita,
    );
  }
}

class PunteggioService {
  /// Calcola un punteggio sintetico per confrontare giocatori dello
  /// stesso ruolo. Non è una verità assoluta: è una stima pesata
  /// pensata per aiutare la scelta, non per sostituirla.
  double calcola(Giocatore g, PesiPunteggio pesi) {
    final fm = g.fantamedia ?? 0;
    final presenze = g.presenze ?? 0;

    if (g.ruolo == Ruolo.portiere) {
      final golSubitiMedia = presenze > 0 ? (g.golSubiti ?? 0) / presenze : 0;
      return (fm * pesi.fantamedia)
          + ((g.rigoriParati ?? 0) * pesi.rigoriParati)
          - (golSubitiMedia * pesi.golSubitiAPartita)
          - ((g.ammonizioni ?? 0) * pesi.ammonizioni)
          - ((g.espulsioni ?? 0) * pesi.espulsioni);
    }

    return (fm * pesi.fantamedia)
        + ((g.golFatti ?? 0) * pesi.gol)
        + ((g.assist ?? 0) * pesi.assist)
        + ((g.rigoriSegnati ?? 0) * pesi.rigoriSegnati)
        - ((g.ammonizioni ?? 0) * pesi.ammonizioni)
        - ((g.espulsioni ?? 0) * pesi.espulsioni)
        - ((g.autogol ?? 0) * pesi.autogol);
  }

  /// Ordina una lista di giocatori dello stesso ruolo dal migliore al peggiore.
  List<Giocatore> ordina(List<Giocatore> giocatori, PesiPunteggio pesi) {
    final copia = List<Giocatore>.from(giocatori);
    copia.sort((a, b) => calcola(b, pesi).compareTo(calcola(a, pesi)));
    return copia;
  }
}