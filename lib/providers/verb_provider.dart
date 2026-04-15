import 'package:flutter/foundation.dart';
import '../models/verb.dart';
import '../database/database_helper.dart';

enum SortOrder { alphabetical, recent }

class VerbProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<Verb> _verbs = [];        // master list, always all verbs from DB
  List<Verb> _filteredVerbs = []; // what the UI sees after all filters
  String _searchQuery = '';
  SortOrder _sortOrder = SortOrder.alphabetical;
  bool? _typeFilter;              // null=all, true=irregular, false=regular
  bool _favoritesOnly = false;   // true = show only favorites
  bool _isLoading = false;
  bool _loaded = false;

  List<Verb> get verbs => _filteredVerbs;
  String get searchQuery => _searchQuery;
  SortOrder get sortOrder => _sortOrder;
  bool? get typeFilter => _typeFilter;
  bool get favoritesOnly => _favoritesOnly;
  bool get isLoading => _isLoading;
  int get totalCount => _verbs.length;
  bool get isLoaded => _loaded;

  Future<void> loadVerbs() async {
    _isLoading = true;
    notifyListeners();
    _verbs = await _db.getAllVerbs(orderBy: _getOrderByClause());
    _applyFilters();
    _isLoading = false;
    _loaded = true;
    notifyListeners();
  }

  String _getOrderByClause() {
    switch (_sortOrder) {
      case SortOrder.alphabetical:
        return 'base_form ASC';
      case SortOrder.recent:
        return 'created_at DESC';
    }
  }

  void _applyFilters() {
    List<Verb> result = List.from(_verbs);

    // 1. Favorites filter
    if (_favoritesOnly) {
      result = result.where((v) => v.isFavorite).toList();
    }

    // 2. Type filter (regular / irregular)
    if (_typeFilter != null) {
      result = result.where((v) => v.isIrregular == _typeFilter).toList();
    }

    // 3. Search query
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((v) {
        return v.baseForm.contains(q) ||
            v.pastSimple.contains(q) ||
            v.pastParticiple.contains(q) ||
            (v.meaning?.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    _filteredVerbs = result;
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setSortOrder(SortOrder order) {
    _sortOrder = order;
    loadVerbs();
  }

  void setTypeFilter(bool? filter) {
    _typeFilter = (_typeFilter == filter) ? null : filter;
    _applyFilters();
    notifyListeners();
  }

  void toggleFavoritesFilter() {
    _favoritesOnly = !_favoritesOnly;
    _applyFilters();
    notifyListeners();
  }

  Future<void> addVerb(Verb verb) async {
    await _db.insertVerb(verb);
    await loadVerbs();
  }

  Future<void> updateVerb(Verb verb) async {
    await _db.updateVerb(verb);
    await loadVerbs();
  }

  Future<void> deleteVerb(int id) async {
    await _db.deleteVerb(id);
    await loadVerbs();
  }

  Future<void> toggleFavorite(Verb verb) async {
    // 1. Optimistic update in the master list so UI reflects instantly
    final idx = _verbs.indexWhere((v) => v.id == verb.id);
    if (idx != -1) {
      _verbs[idx] = _verbs[idx].copyWith(isFavorite: !verb.isFavorite);
      _applyFilters();
      notifyListeners();
    }

    // 2. Persist to DB — write only the is_favorite column, never touches
    //    other fields so there is no risk of data loss
    await _db.setFavorite(verb.id!, !verb.isFavorite);

    // 3. Re-read from DB to guarantee consistency
    await loadVerbs();
  }

  // Returns ALL verbs (ignores all active filters) — used by Practice
  List<Verb> getAllVerbsForPractice() => List<Verb>.from(_verbs);

  List<Verb> getRandomVerbs(int count) {
    final all = List<Verb>.from(_verbs);
    all.shuffle();
    return all.take(count.clamp(0, all.length)).toList();
  }
}
