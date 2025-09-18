import 'package:get/get.dart';
import 'package:app_graphql/models/character.dart';
import 'package:app_graphql/services/character_service.dart';

class CharacterController extends GetxController {
  final CharacterService _service = CharacterService();

  final RxList<Character> items = <Character>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final RxInt _page = 1.obs;
  final RxString _nameFilter = ''.obs;
  int? _next;
  int? _prev;

  int get currentPage => _page.value;
  String? get nameFilter =>
      _nameFilter.value.isEmpty ? null : _nameFilter.value;
  bool get canLoadMore => _next != null;

  @override
  void onInit() {
    super.onInit();
    fetch(reset: true);
  }

  Future<void> fetch({bool reset = false}) async {
    if (reset) {
      _page.value = 1;
      items.clear();
      _next = null;
      _prev = null;
    }

    try {
      isLoading.value = true;
      error.value = '';
      final pageData = await _service.getCharacters(
        page: _page.value,
        name: nameFilter,
      );
      items.addAll(pageData.results);
      _next = pageData.next;
      _prev = pageData.prev;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      error.value = e.toString();
    }
  }

  Future<void> searchByName(String name) async {
    _nameFilter.value = name;
    await fetch(reset: true);
  }

  Future<void> loadMore() async {
    if (!canLoadMore) return;
    _page.value = _next!;
    await fetch();
  }
}
