import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/giocatore.dart';
import '../providers/giocatori_provider.dart';

class ImportScreen extends StatelessWidget {
  const ImportScreen({super.key});

  Future<void> _importaStatistiche(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );
    if (result == null || result.files.single.bytes == null) return;

    final bytes = result.files.single.bytes!;
    if (!context.mounted) return;
    await context.read<GiocatoriProvider>().importaStatistiche(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Fantasta')),
      body: Consumer<GiocatoriProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: provider.caricamento
                      ? null
                      : () => _importaStatistiche(context),
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Importa file Statistiche (.xlsx)'),
                ),
                const SizedBox(height: 16),
                if (provider.caricamento) const CircularProgressIndicator(),
                if (provider.ultimoErrore != null)
                  Text(
                    'Errore: ${provider.ultimoErrore}',
                    style: const TextStyle(color: Colors.red),
                  ),
                Text('Giocatori in memoria: ${provider.giocatori.length}'),
                if (provider.ultimeRigheScartate.isNotEmpty)
                  Text(
                    '${provider.ultimeRigheScartate.length} righe scartate nell\'ultimo import',
                    style: const TextStyle(color: Colors.orange),
                  ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.giocatori.length,
                    itemBuilder: (context, index) {
                      final g = provider.giocatori[index];
                      return ListTile(
                        title: Text('${g.nome} (${g.ruolo.sigla})'),
                        subtitle: Text(
                          '${g.squadra} — Fantamedia: ${g.fantamedia ?? "N/D"}',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}