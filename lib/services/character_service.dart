import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app_graphql/config/graphql_config.dart';
import 'package:app_graphql/models/character.dart';

class CharacterService {
  static final ValueNotifier<GraphQLClient> _client =
      GraphQLConfig.clientToQuery();

  // LISTA con paginación y filtro por nombre
  static const String charactersQuery = r'''
    query Characters($page: Int, $name: String) {
      characters(page: $page, filter: { name: $name }) {
        info { count pages next prev }
        results {
          id name status species image
          origin { name }
          location { name }
        }
      }
    }
  ''';

  // DETALLE por ID
  static const String characterByIdQuery = r'''
    query Character($id: ID!) {
      character(id: $id) {
        id name status species image
        type gender
        origin { name }
        location { name }
        episode { id name episode air_date }
      }
    }
  ''';

  Future<CharactersPage> getCharacters({int page = 1, String? name}) async {
    final result = await _client.value.query(
      QueryOptions(
        document: gql(charactersQuery),
        variables: {'page': page, 'name': name},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final data = result.data!['characters'];
    final info = data['info'] ?? {};
    final List results = data['results'] ?? [];

    return CharactersPage(
      results:
          results.map((e) => Character.fromJson(e)).toList().cast<Character>(),
      count: info['count'] ?? 0,
      pages: info['pages'] ?? 0,
      next: info['next'],
      prev: info['prev'],
    );
  }

  Future<Character> getCharacterById(String id) async {
    final result = await _client.value.query(
      QueryOptions(
        document: gql(characterByIdQuery),
        variables: {'id': id},
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    return Character.fromJson(result.data!['character']);
  }
}

class CharactersPage {
  final List<Character> results;
  final int count;
  final int pages;
  final int? next;
  final int? prev;

  CharactersPage({
    required this.results,
    required this.count,
    required this.pages,
    required this.next,
    required this.prev,
  });
}
