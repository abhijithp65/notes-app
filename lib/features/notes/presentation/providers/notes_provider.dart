import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/constants.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/notes_usecases.dart';

enum SortOrder { updatedDesc, updatedAsc, titleAsc, titleDesc }

class NotesProvider extends ChangeNotifier {
  final GetAllNotes    _getAll;
  final SaveNote       _save;
  final DeleteNote     _delete;
  final DeleteAllNotes _deleteAll;
  final GetAllTags     _getTags;

  NotesProvider({
    required GetAllNotes    getAll,
    required SearchNotes    search,
    required GetNotesByTag  getByTag,
    required SaveNote       save,
    required DeleteNote     delete,
    required DeleteAllNotes deleteAll,
    required GetAllTags     getTags,
  })  : _getAll    = getAll,
        _save      = save,
        _delete    = delete,
        _deleteAll = deleteAll,
        _getTags   = getTags {
    _init();
  }

  List<Note>   _allNotes     = [];
  List<Note>   _displayNotes = [];
  List<String> _allTags      = [];
  String       _searchQuery  = '';
  String       _activeTag    = '';
  SortOrder    _sortOrder    = SortOrder.updatedDesc;
  bool         _isLoading    = false;
  bool         _isGridView   = true;
  String?      _error;
  Timer?       _debounce;

  List<Note>   get notes       => _displayNotes;
  List<Note>   get pinnedNotes => _displayNotes.where((n) => n.isPinned).toList();
  List<Note>   get otherNotes  => _displayNotes.where((n) => !n.isPinned).toList();
  List<String> get allTags     => _allTags;
  String       get searchQuery => _searchQuery;
  String       get activeTag   => _activeTag;
  SortOrder    get sortOrder   => _sortOrder;
  bool         get isLoading   => _isLoading;
  bool         get isGridView  => _isGridView;
  String?      get error       => _error;
  int          get noteCount   => _allNotes.length;

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _isGridView = prefs.getBool(AppConstants.viewPrefKey) ?? true;
    await refresh();
  }

  Future<void> refresh() async {
    _isLoading = true;
    _error     = null;
    notifyListeners();
    try {
      _allNotes = await _getAll();
      _allTags  = await _getTags();
      _applyFilters();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void _applyFilters() {
    List<Note> result = List.from(_allNotes);

    if (_activeTag.isNotEmpty) {
      result = result.where((n) => n.tags.contains(_activeTag)).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      result = result
          .where((n) =>
              n.title.toLowerCase().contains(q) ||
              n.content.toLowerCase().contains(q) ||
              n.tags.any((t) => t.toLowerCase().contains(q)))
          .toList();
    }

    switch (_sortOrder) {
      case SortOrder.updatedDesc:
        result.sort((a, b) {
          if (a.isPinned && !b.isPinned) return -1;
          if (!a.isPinned && b.isPinned) return 1;
          return b.updatedAt.compareTo(a.updatedAt);
        });
        break;
      case SortOrder.updatedAsc:
        result.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
      case SortOrder.titleAsc:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOrder.titleDesc:
        result.sort((a, b) => b.title.compareTo(a.title));
        break;
    }

    _displayNotes = result;
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _searchQuery = query;
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _applyFilters();
      notifyListeners();
    });
  }

  void clearSearch() {
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }

  void setActiveTag(String tag) {
    _activeTag = _activeTag == tag ? '' : tag;
    _applyFilters();
    notifyListeners();
  }

  void setSortOrder(SortOrder order) {
    _sortOrder = order;
    _applyFilters();
    notifyListeners();
  }

  Future<void> toggleGridView() async {
    _isGridView = !_isGridView;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.viewPrefKey, _isGridView);
  }

  Future<void> saveNote({
    String?      id,
    required String title,
    required String content,
    List<String>? tags,
    int           colorIndex = 0,
    bool          isPinned   = false,
    DateTime?     createdAt,
  }) async {
    final now  = DateTime.now();
    final note = Note(
      id:         id ?? const Uuid().v4(),
      title:      title.trim(),
      content:    content.trim(),
      tags:       tags ?? [],
      colorIndex: colorIndex,
      isPinned:   isPinned,
      createdAt:  createdAt ?? now,
      updatedAt:  now,
    );
    await _save(note);
    await refresh();
  }

  Future<void> togglePin(Note note) async {
    await _save(note.copyWith(isPinned: !note.isPinned, updatedAt: DateTime.now()));
    await refresh();
  }

  Future<void> deleteNote(String id) async {
    await _delete(id);
    await refresh();
  }

  Future<void> deleteAll() async {
    await _deleteAll();
    await refresh();
  }

  Note? getNoteById(String id) {
    try {
      return _allNotes.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }
}
