import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:app_graphql/controllers/character_controller.dart';
import 'package:app_graphql/widgets/character_card.dart';
import 'package:app_graphql/screens/character_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final CharacterController c = Get.find<CharacterController>();
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rick & Morty - Caracteristicas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Buscar por nombre (ej. "Rick")',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (v) => c.searchByName(v.trim()),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar'),
                  onPressed: () => c.searchByName(_searchCtrl.text.trim()),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (c.isLoading.value && c.items.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (c.error.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error:\n${c.error.value}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => c.fetch(reset: true),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (c.items.isEmpty) {
                return const Center(child: Text('Sin resultados'));
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (sn) {
                  if (sn.metrics.pixels >= sn.metrics.maxScrollExtent - 200 &&
                      !c.isLoading.value &&
                      c.canLoadMore) {
                    c.loadMore();
                  }
                  return false;
                },
                child: RefreshIndicator(
                  onRefresh: () => c.fetch(reset: true),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: c.items.length + 1,
                    itemBuilder: (context, index) {
                      if (index == c.items.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child:
                                c.canLoadMore
                                    ? const CircularProgressIndicator()
                                    : const Text('No hay más'),
                          ),
                        );
                      }
                      final ch = c.items[index];
                      return CharacterCard(
                        character: ch,
                        onTap:
                            () =>
                                Get.to(() => CharacterDetailScreen(id: ch.id)),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
