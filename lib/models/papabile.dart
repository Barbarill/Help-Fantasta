class Papabile {
  final int giocatoreId;
  final int priorita;

  const Papabile({required this.giocatoreId, required this.priorita});

  Map<String, dynamic> toJson() => {
        'giocatoreId': giocatoreId,
        'priorita': priorita,
      };

  factory Papabile.fromJson(Map<String, dynamic> json) => Papabile(
        giocatoreId: json['giocatoreId'] as int,
        priorita: json['priorita'] as int,
      );
}