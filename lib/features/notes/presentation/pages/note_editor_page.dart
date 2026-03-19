import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/note.dart';
import '../providers/notes_provider.dart';
import '../providers/theme_provider.dart';

class NoteEditorPage extends StatefulWidget {
  final Note? existing;
  const NoteEditorPage({super.key, this.existing});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  final _titleCtrl   = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _tagCtrl     = TextEditingController();

  int          _colorIndex = 0;
  bool         _isPinned   = false;
  List<String> _tags       = [];
  bool         _hasChanges = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final e = widget.existing!;
      _titleCtrl.text   = e.title;
      _contentCtrl.text = e.content;
      _colorIndex       = e.colorIndex;
      _isPinned         = e.isPinned;
      _tags             = List.from(e.tags);
    }
    _titleCtrl.addListener(_onChange);
    _contentCtrl.addListener(_onChange);
  }

  void _onChange() => setState(() => _hasChanges = true);

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _tagCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title   = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();
    if (title.isEmpty && content.isEmpty) {
      Navigator.pop(context);
      return;
    }
    HapticFeedback.selectionClick();
    await context.read<NotesProvider>().saveNote(
          id:         _isEditing ? widget.existing!.id : null,
          title:      title,
          content:    content,
          tags:       _tags,
          colorIndex: _colorIndex,
          isPinned:   _isPinned,
          createdAt:  _isEditing ? widget.existing!.createdAt : null,
        );
    if (mounted) Navigator.pop(context);
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;
    final title   = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();
    if (title.isEmpty && content.isEmpty) return true;
    await _save();
    return false;
  }

  void _addTag(String tag) {
    final t = tag.trim();
    if (t.isEmpty || _tags.contains(t)) return;
    setState(() {
      _tags.add(t);
      _hasChanges = true;
    });
    _tagCtrl.clear();
  }

  void _removeTag(String tag) => setState(() {
        _tags.remove(tag);
        _hasChanges = true;
      });

  void _showColorPicker() {
    final isDark = context.read<ThemeProvider>().isDark;
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
            Text('Note Color',
                style: AppTextStyles.titleMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 20),
            Wrap(
              spacing:    14,
              runSpacing: 14,
              children: List.generate(
                AppColors.noteColorsDark.length,
                (i) {
                  final colors  = isDark
                      ? AppColors.noteColorsDark
                      : AppColors.noteColorsLight;
                  final accent  = AppColors.noteAccents[i];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _colorIndex = i;
                        _hasChanges = true;
                      });
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        color:        colors[i],
                        shape:        BoxShape.circle,
                        border: Border.all(
                          color: _colorIndex == i
                              ? accent
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withOpacity(0.3),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: _colorIndex == i
                          ? Icon(Icons.check_rounded,
                              color: accent, size: 22)
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showTagSuggestions() {
    showModalBottomSheet(
      context:         context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Tags',
                  style: AppTextStyles.titleMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
              const SizedBox(height: 16),
              TextField(
                controller:         _tagCtrl,
                autofocus:          true,
                style: AppTextStyles.bodyLarge.copyWith(
                    color: Theme.of(context).colorScheme.onSurface),
                textInputAction:    TextInputAction.done,
                onSubmitted:        (v) {
                  _addTag(v);
                  Navigator.pop(context);
                },
                decoration: const InputDecoration(hintText: 'Type a tag...'),
              ),
              const SizedBox(height: 16),
              Text('Suggestions',
                  style: AppTextStyles.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: DefaultTags.all
                    .where((t) => !_tags.contains(t))
                    .map((t) => GestureDetector(
                          onTap: () {
                            _addTag(t);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3)),
                            ),
                            child: Text(t,
                                style: AppTextStyles.label.copyWith(
                                    color: AppColors.primary)),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark  = context.watch<ThemeProvider>().isDark;
    final colors  = isDark ? AppColors.noteColorsDark : AppColors.noteColorsLight;
    final accent  = AppColors.noteAccents[_colorIndex % AppColors.noteAccents.length];
    final bgColor = colors[_colorIndex % colors.length];
    final scheme  = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation:       0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () async {
              if (await _onWillPop()) Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isPinned
                    ? Icons.push_pin_rounded
                    : Icons.push_pin_outlined,
                color: _isPinned ? accent : scheme.onSurface.withOpacity(0.5),
              ),
              onPressed: () => setState(() {
                _isPinned   = !_isPinned;
                _hasChanges = true;
              }),
              tooltip: 'Pin note',
            ),
            IconButton(
              icon: Icon(Icons.palette_outlined,
                  color: accent),
              onPressed: _showColorPicker,
              tooltip: 'Change color',
            ),
            IconButton(
              icon: Icon(Icons.check_rounded, color: accent),
              onPressed: _save,
              tooltip: 'Save',
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                TextField(
                  controller:  _titleCtrl,
                  style: AppTextStyles.displayMedium.copyWith(
                      color: scheme.onSurface),
                  maxLines:    null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText:    'Title',
                    hintStyle:   AppTextStyles.displayMedium.copyWith(
                        color: scheme.onSurface.withOpacity(0.25)),
                    border:      InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled:      false,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 4),

                // Tags row
                if (_tags.isNotEmpty)
                  Wrap(
                    spacing: 6, runSpacing: 6,
                    children: [
                      ..._tags.map((tag) => Chip(
                            label: Text(tag,
                                style: AppTextStyles.label.copyWith(
                                    color: accent, fontSize: 11)),
                            backgroundColor: accent.withOpacity(0.12),
                            side: BorderSide(
                                color: accent.withOpacity(0.3)),
                            deleteIcon: Icon(Icons.close,
                                size: 14, color: accent),
                            onDeleted: () => _removeTag(tag),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4),
                            visualDensity: VisualDensity.compact,
                          )),
                      ActionChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 14,
                                color: scheme.onSurface.withOpacity(0.5)),
                            const SizedBox(width: 4),
                            Text('Tag',
                                style: AppTextStyles.label.copyWith(
                                    color: scheme.onSurface.withOpacity(0.5),
                                    fontSize: 11)),
                          ],
                        ),
                        onPressed: _showTagSuggestions,
                        backgroundColor: Colors.transparent,
                        side: BorderSide(
                            color: scheme.onSurface.withOpacity(0.15)),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  )
                else
                  TextButton.icon(
                    onPressed: _showTagSuggestions,
                    icon: Icon(Icons.label_outline_rounded,
                        size: 16,
                        color: scheme.onSurface.withOpacity(0.35)),
                    label: Text('Add tags',
                        style: AppTextStyles.bodySmall.copyWith(
                            color: scheme.onSurface.withOpacity(0.35))),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  ),
                const SizedBox(height: 12),

                // Content
                TextField(
                  controller:  _contentCtrl,
                  style: AppTextStyles.bodyLarge.copyWith(
                      color: scheme.onSurface.withOpacity(0.85)),
                  maxLines:    null,
                  minLines:    12,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText:    'Start writing...',
                    hintStyle:   AppTextStyles.bodyLarge.copyWith(
                        color: scheme.onSurface.withOpacity(0.25)),
                    border:      InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled:      false,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
