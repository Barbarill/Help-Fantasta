import 'giocatore.dart';

class AstaConfig {
  final double budgetTotale;
  final int slotPortieri;
  final int slotDifensori;
  final int slotCentrocampisti;
  final int slotAttaccanti;

  const AstaConfig({
    required this.budgetTotale,
    required this.slotPortieri,
    required this.slotDifensori,
    required this.slotCentrocampisti,
    required this.slotAttaccanti,
  });

  int slotPerRuolo(Ruolo ruolo) {
    switch (ruolo) {
      case Ruolo.portiere:
        return slotPortieri;
      case Ruolo.difensore:
        return slotDifensori;
      case Ruolo.centrocampista:
        return slotCentrocampisti;
      case Ruolo.attaccante:
        return slotAttaccanti;
    }
  }

  int get slotTotali =>
      slotPortieri + slotDifensori + slotCentrocampisti + slotAttaccanti;

  Map<String, dynamic> toJson() => {
        'budgetTotale': budgetTotale,
        'slotPortieri': slotPortieri,
        'slotDifensori': slotDifensori,
        'slotCentrocampisti': slotCentrocampisti,
        'slotAttaccanti': slotAttaccanti,
      };

  factory AstaConfig.fromJson(Map<String, dynamic> json) => AstaConfig(
        budgetTotale: (json['budgetTotale'] as num).toDouble(),
        slotPortieri: json['slotPortieri'] as int,
        slotDifensori: json['slotDifensori'] as int,
        slotCentrocampisti: json['slotCentrocampisti'] as int,
        slotAttaccanti: json['slotAttaccanti'] as int,
      );
}

class Acquisto {
  final int giocatoreId;
  final Ruolo ruolo;
  final double prezzo;

  const Acquisto({
    required this.giocatoreId,
    required this.ruolo,
    required this.prezzo,
  });

  Map<String, dynamic> toJson() => {
        'giocatoreId': giocatoreId,
        'ruolo': ruolo.sigla,
        'prezzo': prezzo,
      };

  factory Acquisto.fromJson(Map<String, dynamic> json) => Acquisto(
        giocatoreId: json['giocatoreId'] as int,
        ruolo: RuoloExtension.fromSigla(json['ruolo'] as String),
        prezzo: (json['prezzo'] as num).toDouble(),
      );
}