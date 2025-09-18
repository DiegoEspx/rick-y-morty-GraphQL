import 'package:flutter/material.dart';
import 'package:app_graphql/models/character.dart';
import 'package:app_graphql/services/character_service.dart';

class CharacterDetailScreen extends StatefulWidget {
  final String id;
  const CharacterDetailScreen({super.key, required this.id});

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  final _service = CharacterService();
  late Future<Character> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getCharacterById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caracteristicas detalladas')),
      body: FutureBuilder<Character>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error: ${snap.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (!snap.hasData) {
            return const Center(child: Text('No data'));
          }

          final ch = snap.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundImage: NetworkImage(ch.image),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        ch.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _card('Informacion', [
                  _row('Estado', ch.status),
                  _row('Especie', ch.species),
                  _row('Origen', ch.origin?.name ?? '-'),
                  _row('Ubicacion', ch.location?.name ?? '-'),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _card(String title, List<Widget> children) => Card(
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    ),
  );

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
