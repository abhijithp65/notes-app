import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/note.dart';
import '../providers/notes_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/note_card.dart';
import '../widgets/notes_search_bar.dart';
import '../widgets/tag_filter_bar.dart';
import 'note_editor_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openEditor(BuildContext context, {Note? note}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<NotesProvider>(),
          child: ChangeNotifierProvider.value(
            value: context.read<ThemeProvider>(),
            child: NoteEditorPage(existing: note),
          ),
        ),
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    final provider = context.read<NotesProvider>();
    showModalBottomSheet(
      context:         context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sort by',
                style: AppTextStyles.titleMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 16),
            ...SortOrder.values.map((order) {
              final label = _sortLabel(order);
              final selected = provider.sortOrder == order;
              return ListTile(
                leading: Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected
                      ? AppColors.primary
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                ),
                title: Text(label,
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
                onTap: () {
                  provider.setSortOrder(order);
                  Navigator.pop(context);
                },
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              );
            }),
          ],
        ),
      ),
    );
  }

  String _sortLabel(SortOrder o) {
    switch (o) {
      case SortOrder.updatedDesc: return 'Last modified (newest first)';
      case SortOrder.updatedAsc:  return 'Last modified (oldest first)';
      case SortOrder.titleAsc:    return 'Title (A → Z)';
      case SortOrder.titleDesc:   return 'Title (Z → A)';
    }
  }

  void _showNoteOptions(BuildContext context, Note note) {
    final provider = context.read<NotesProvider>();
    final scheme   = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context:         context,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 36, height: 4,
                decoration: BoxDecoration(
                    color: scheme.onSurface.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(
                  note.isPinned
                      ? Icons.push_pin_rounded
                      : Icons.push_pin_outlined,
                  color: AppColors.primary),
              title: Text(note.isPinned ? 'Unpin note' : 'Pin note',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: scheme.onSurface)),
              onTap: () {
                provider.togglePin(note);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined,
                  color: AppColors.primary),
              title: Text('Edit note',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: scheme.onSurface)),
              onTap: () {
                Navigator.pop(context);
                _openEditor(context, note: note);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.danger),
              title: Text('Delete note',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.danger)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, note);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete note?',
            style: AppTextStyles.titleMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface)),
        content: Text(
            note.title.isNotEmpty
                ? '"${note.title}" will be permanently deleted.'
                : 'This note will be permanently deleted.',
            style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<NotesProvider>().deleteNote(note.id);
              Navigator.pop(context);
            },
            child: const Text('Delete',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider  = context.watch<NotesProvider>();
    final theme     = context.watch<ThemeProvider>();
    final scheme    = Theme.of(context).colorScheme;
    final isGrid    = provider.isGridView;
    final notes     = provider.notes;
    final pinned    = provider.pinnedNotes;
    final others    = provider.otherNotes;

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (ctx, _) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Notes',
                          style: AppTextStyles.displayLarge
                              .copyWith(color: scheme.onSurface)),
                    ),
                    // Dark mode toggle
                    IconButton(
                      icon: Icon(
                          theme.isDark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          size: 22),
                      onPressed: theme.toggle,
                      color: scheme.onSurface.withOpacity(0.6),
                      tooltip: 'Toggle theme',
                    ),
                    // Sort
                    IconButton(
                      icon: const Icon(Icons.sort_rounded, size: 22),
                      onPressed: () => _showSortSheet(context),
                      color: scheme.onSurface.withOpacity(0.6),
                      tooltip: 'Sort',
                    ),
                    // Grid/List toggle
                    IconButton(
                      icon: Icon(
                          isGrid
                              ? Icons.view_list_rounded
                              : Icons.grid_view_rounded,
                          size: 22),
                      onPressed: provider.toggleGridView,
                      color: scheme.onSurface.withOpacity(0.6),
                      tooltip: isGrid ? 'List view' : 'Grid view',
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                child: const NotesSearchBar(),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 14),
                child: TagFilterBar(),
              ),
            ),
          ],
          body: provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primary, strokeWidth: 2))
              : notes.isEmpty
                  ? _EmptyState(
                      hasSearch: provider.searchQuery.isNotEmpty ||
                          provider.activeTag.isNotEmpty,
                      onAdd: () => _openEditor(context),
                    )
                  : RefreshIndicator(
                      onRefresh: provider.refresh,
                      color: AppColors.primary,
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        slivers: [
                          if (pinned.isNotEmpty) ...[
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                                child: Row(
                                  children: [
                                    Icon(Icons.push_pin_rounded,
                                        size: 14,
                                        color: scheme.onSurface.withOpacity(0.45)),
                                    const SizedBox(width: 6),
                                    Text('PINNED',
                                        style: AppTextStyles.label.copyWith(
                                            color: scheme.onSurface
                                                .withOpacity(0.45))),
                                  ],
                                ),
                              ),
                            ),
                            _NotesGrid(
                              notes:   pinned,
                              isGrid:  isGrid,
                              onTap:   (n) => _openEditor(context, note: n),
                              onLong:  (n) => _showNoteOptions(context, n),
                            ),
                          ],
                          if (others.isNotEmpty) ...[
                            if (pinned.isNotEmpty)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                                  child: Text('OTHERS',
                                      style: AppTextStyles.label.copyWith(
                                          color: scheme.onSurface
                                              .withOpacity(0.45))),
                                ),
                              ),
                            _NotesGrid(
                              notes:  others,
                              isGrid: isGrid,
                              onTap:  (n) => _openEditor(context, note: n),
                              onLong: (n) => _showNoteOptions(context, n),
                            ),
                          ],
                          const SliverToBoxAdapter(
                              child: SizedBox(height: 100)),
                        ],
                      ),
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context),
        tooltip:   'New note',
        child:     const Icon(Icons.edit_rounded, size: 24),
      ),
    );
  }
}

class _NotesGrid extends StatelessWidget {
  final List<Note>        notes;
  final bool              isGrid;
  final void Function(Note) onTap;
  final void Function(Note) onLong;

  const _NotesGrid({
    required this.notes,
    required this.isGrid,
    required this.onTap,
    required this.onLong,
  });

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:   2,
            childAspectRatio: 0.78,
            crossAxisSpacing: 12,
            mainAxisSpacing:  12,
          ),
          delegate: SliverChildBuilderDelegate(
            (_, i) => NoteCard(
              note:        notes[i],
              isGrid:      true,
              onTap:       () => onTap(notes[i]),
              onLongPress: () => onLong(notes[i]),
            ),
            childCount: notes.length,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: NoteCard(
              note:        notes[i],
              isGrid:      false,
              onTap:       () => onTap(notes[i]),
              onLongPress: () => onLong(notes[i]),
            ),
          ),
          childCount: notes.length,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool         hasSearch;
  final VoidCallback onAdd;

  const _EmptyState({required this.hasSearch, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(hasSearch ? '🔍' : '📝',
              style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            hasSearch ? 'No notes found' : 'No notes yet',
            style: AppTextStyles.titleMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 6),
          Text(
            hasSearch
                ? 'Try a different search or tag'
                : 'Tap + to create your first note',
            style: AppTextStyles.bodyMedium,
          ),
          if (!hasSearch) ...[
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon:  const Icon(Icons.edit_rounded, size: 18),
              label: const Text('New Note'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
