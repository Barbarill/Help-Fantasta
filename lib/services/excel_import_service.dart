import 'dart:typed_data';
import 'package:excel/excel.dart';
import '../models/giocatore.dart';

class ImportResult {
  final List<Giocatore> giocatori;
  final List<String> righeScartate;

  ImportResult({required this.giocatori, required this.righeScartate});
}

class ExcelImportService {
  /// Importa il file "Statistiche" di fantacalcio.it (foglio "Tutti").
  /// Colonne attese: Id, R, Rm, Nome, Squadra, Pv, Mv, Fm, Gf, Gs,
  /// Rp, Rc, R+, R-, Ass, Amm, Esp, Au
  ImportResult importStatistiche(Uint8List bytes) {
    final excel = Excel.decodeBytes(bytes);

    final sheet = excel.tables['Tutti'] ?? excel.tables[excel.tables.keys.first];
    if (sheet == null) {
      throw Exception('Nessun foglio trovato nel file Excel.');
    }

    final rows = sheet.rows;
    if (rows.length < 3) {
      throw Exception('Il file sembra vuoto o in un formato inatteso.');
    }

    final giocatori = <Giocatore>[];
    final scartate = <String>[];

    for (var i = 2; i < rows.length; i++) {
      final row = rows[i];
      try {
        final giocatore = _rigaToGiocatore(row);
        if (giocatore != null) giocatori.add(giocatore);
      } catch (e) {
        scartate.add('Riga ${i + 1}: $e');
      }
    }

    return ImportResult(giocatori: giocatori, righeScartate: scartate);
  }

  Giocatore? _rigaToGiocatore(List<Data?> row) {
    if (row.isEmpty || row[0]?.value == null) return null;

    final id = _asInt(row[0]?.value);
    final ruoloSigla = row[1]?.value?.toString() ?? '';
    final ruoloMantra = row[2]?.value?.toString();
    final nome = row[3]?.value?.toString() ?? '';
    final squadra = row[4]?.value?.toString() ?? '';

    if (id == null || nome.isEmpty) return null;

    return Giocatore(
      id: id,
      nome: nome,
      squadra: squadra,
      ruolo: RuoloExtension.fromSigla(ruoloSigla),
      ruoloMantra: ruoloMantra,
      presenze: _asInt(row[5]?.value),
      mediaVoto: _asDouble(row[6]?.value),
      fantamedia: _asDouble(row[7]?.value),
      golFatti: _asInt(row[8]?.value),
      golSubiti: _asInt(row[9]?.value),
      rigoriParati: _asInt(row[10]?.value),
      rigoriCalciati: _asInt(row[11]?.value),
      rigoriSegnati: _asInt(row[12]?.value),
      rigoriSbagliati: _asInt(row[13]?.value),
      assist: _asInt(row[14]?.value),
      ammonizioni: _asInt(row[15]?.value),
      espulsioni: _asInt(row[16]?.value),
      autogol: _asInt(row[17]?.value),
    );
  }

  int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().replaceAll(',', '.').trim());
  }

  double? _asDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(',', '.').trim());
  }
}