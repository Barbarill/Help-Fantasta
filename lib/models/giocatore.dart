enum Ruolo { portiere, difensore, centrocampista, attaccante }

extension RuoloExtension on Ruolo {
  static Ruolo fromSigla(String sigla) {
    switch (sigla.trim().toUpperCase()) {
      case 'P':
        return Ruolo.portiere;
      case 'D':
        return Ruolo.difensore;
      case 'C':
        return Ruolo.centrocampista;
      case 'A':
        return Ruolo.attaccante;
      default:
        throw ArgumentError('Ruolo non riconosciuto: $sigla');
    }
  }

  String get sigla {
    switch (this) {
      case Ruolo.portiere:
        return 'P';
      case Ruolo.difensore:
        return 'D';
      case Ruolo.centrocampista:
        return 'C';
      case Ruolo.attaccante:
        return 'A';
    }
  }

  String get nomeCompleto {
    switch (this) {
      case Ruolo.portiere:
        return 'Portiere';
      case Ruolo.difensore:
        return 'Difensore';
      case Ruolo.centrocampista:
        return 'Centrocampista';
      case Ruolo.attaccante:
        return 'Attaccante';
    }
  }
}

class Giocatore {
  final int id;
  final String nome;
  final String squadra;
  final Ruolo ruolo;

  // Dal listone quotazioni (in arrivo quando disponibile in Excel)
  final double? quotazione;
  final double? fvm;

  // Dalle statistiche storiche (es. stagione 2025/26)
  final int? presenze;
  final double? mediaVoto;
  final double? fantamedia;
  final int? golFatti;
  final int? golSubiti;
  final int? rigoriParati;
  final int? rigoriCalciati;
  final int? rigoriSegnati;
  final int? rigoriSbagliati;
  final int? assist;
  final int? ammonizioni;
  final int? espulsioni;
  final int? autogol;

  const Giocatore({
    required this.id,
    required this.nome,
    required this.squadra,
    required this.ruolo,
    this.quotazione,
    this.fvm,
    this.presenze,
    this.mediaVoto,
    this.fantamedia,
    this.golFatti,
    this.golSubiti,
    this.rigoriParati,
    this.rigoriCalciati,
    this.rigoriSegnati,
    this.rigoriSbagliati,
    this.assist,
    this.ammonizioni,
    this.espulsioni,
    this.autogol,
  });

  /// true se abbiamo dati storici sufficienti per confronti statistici
  bool get haStatistiche => fantamedia != null;

  /// true se abbiamo il dato di quotazione/FVM dal listone d'asta
  bool get haQuotazione => quotazione != null;

  /// Indice di convenienza: fantamedia storica rapportata al costo d'asta.
  /// Disponibile solo quando entrambe le fonti (listone + statistiche)
  /// sono state importate e unite per questo giocatore.
  double? get indiceConvenienza {
    if (fantamedia == null || quotazione == null || quotazione == 0) {
      return null;
    }
    return fantamedia! / quotazione!;
  }

  /// Crea una copia arricchendo solo i campi passati (non nulli),
  /// lasciando invariati quelli già presenti. Usato per il merge
  /// tra fonti diverse (listone + statistiche) sullo stesso giocatore.
  Giocatore copyWith({
    double? quotazione,
    double? fvm,
    int? presenze,
    double? mediaVoto,
    double? fantamedia,
    int? golFatti,
    int? golSubiti,
    int? rigoriParati,
    int? rigoriCalciati,
    int? rigoriSegnati,
    int? rigoriSbagliati,
    int? assist,
    int? ammonizioni,
    int? espulsioni,
    int? autogol,
  }) {
    return Giocatore(
      id: id,
      nome: nome,
      squadra: squadra,
      ruolo: ruolo,
      quotazione: quotazione ?? this.quotazione,
      fvm: fvm ?? this.fvm,
      presenze: presenze ?? this.presenze,
      mediaVoto: mediaVoto ?? this.mediaVoto,
      fantamedia: fantamedia ?? this.fantamedia,
      golFatti: golFatti ?? this.golFatti,
      golSubiti: golSubiti ?? this.golSubiti,
      rigoriParati: rigoriParati ?? this.rigoriParati,
      rigoriCalciati: rigoriCalciati ?? this.rigoriCalciati,
      rigoriSegnati: rigoriSegnati ?? this.rigoriSegnati,
      rigoriSbagliati: rigoriSbagliati ?? this.rigoriSbagliati,
      assist: assist ?? this.assist,
      ammonizioni: ammonizioni ?? this.ammonizioni,
      espulsioni: espulsioni ?? this.espulsioni,
      autogol: autogol ?? this.autogol,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'squadra': squadra,
        'ruolo': ruolo.sigla,
        'quotazione': quotazione,
        'fvm': fvm,
        'presenze': presenze,
        'mediaVoto': mediaVoto,
        'fantamedia': fantamedia,
        'golFatti': golFatti,
        'golSubiti': golSubiti,
        'rigoriParati': rigoriParati,
        'rigoriCalciati': rigoriCalciati,
        'rigoriSegnati': rigoriSegnati,
        'rigoriSbagliati': rigoriSbagliati,
        'assist': assist,
        'ammonizioni': ammonizioni,
        'espulsioni': espulsioni,
        'autogol': autogol,
      };

  factory Giocatore.fromJson(Map<String, dynamic> json) {
    return Giocatore(
      id: json['id'] as int,
      nome: json['nome'] as String,
      squadra: json['squadra'] as String,
      ruolo: RuoloExtension.fromSigla(json['ruolo'] as String),
      quotazione: (json['quotazione'] as num?)?.toDouble(),
      fvm: (json['fvm'] as num?)?.toDouble(),
      presenze: json['presenze'] as int?,
      mediaVoto: (json['mediaVoto'] as num?)?.toDouble(),
      fantamedia: (json['fantamedia'] as num?)?.toDouble(),
      golFatti: json['golFatti'] as int?,
      golSubiti: json['golSubiti'] as int?,
      rigoriParati: json['rigoriParati'] as int?,
      rigoriCalciati: json['rigoriCalciati'] as int?,
      rigoriSegnati: json['rigoriSegnati'] as int?,
      rigoriSbagliati: json['rigoriSbagliati'] as int?,
      assist: json['assist'] as int?,
      ammonizioni: json['ammonizioni'] as int?,
      espulsioni: json['espulsioni'] as int?,
      autogol: json['autogol'] as int?,
    );
  }
}