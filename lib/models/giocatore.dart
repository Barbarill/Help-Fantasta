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
  final String id;
  final String nome;
  final String squadra;
  final Ruolo ruolo;
  final double quotazione;
  final double fantamedia;
  final double mediaVoto;
  final int presenze;
  final int gol;
  final int assist;

  const Giocatore({
    required this.id,
    required this.nome,
    required this.squadra,
    required this.ruolo,
    required this.quotazione,
    required this.fantamedia,
    required this.mediaVoto,
    required this.presenze,
    required this.gol,
    required this.assist,
  });

  /// Indice di convenienza: fantamedia rapportata alla quotazione.
  /// Più alto = giocatore "conveniente" rispetto al costo.
  double get indiceConvenienza {
    if (quotazione <= 0) return 0;
    return fantamedia / quotazione;
  }

  factory Giocatore.fromRow(Map<String, dynamic> row) {
    return Giocatore(
      id: row['id']?.toString() ?? '',
      nome: row['nome']?.toString() ?? '',
      squadra: row['squadra']?.toString() ?? '',
      ruolo: RuoloExtension.fromSigla(row['ruolo']?.toString() ?? ''),
      quotazione: _parseDouble(row['quotazione']),
      fantamedia: _parseDouble(row['fantamedia']),
      mediaVoto: _parseDouble(row['mediaVoto']),
      presenze: _parseInt(row['presenze']),
      gol: _parseInt(row['gol']),
      assist: _parseInt(row['assist']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(',', '.')) ?? 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'squadra': squadra,
        'ruolo': ruolo.sigla,
        'quotazione': quotazione,
        'fantamedia': fantamedia,
        'mediaVoto': mediaVoto,
        'presenze': presenze,
        'gol': gol,
        'assist': assist,
      };

  factory Giocatore.fromJson(Map<String, dynamic> json) {
    return Giocatore(
      id: json['id'] as String,
      nome: json['nome'] as String,
      squadra: json['squadra'] as String,
      ruolo: RuoloExtension.fromSigla(json['ruolo'] as String),
      quotazione: (json['quotazione'] as num).toDouble(),
      fantamedia: (json['fantamedia'] as num).toDouble(),
      mediaVoto: (json['mediaVoto'] as num).toDouble(),
      presenze: json['presenze'] as int,
      gol: json['gol'] as int,
      assist: json['assist'] as int,
    );
  }
}