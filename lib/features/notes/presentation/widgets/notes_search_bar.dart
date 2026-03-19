import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/notes_provider.dart';

class NotesSearchBar extends StatefulWidget {
  const NotesSearchBar({super.key});

  @override
  State<NotesSearchBar> createState() => _NotesSearchBarState();
}

class _NotesSearchBarState extends State<NotesSearchBar> {
  final _ctrl  = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<NotesProvider>();
    final scheme   = Theme.of(context).colorScheme;

    return TextField(
      controller: _ctrl,
      focusNode:  _focus,
      style:      AppTextStyles.bodyLarge.copyWith(color: scheme.onSurface),
      onChanged:  (q) {
        provider.onSearchChanged(q);
        setState(() {});
      },
      decoration: InputDecoration(
        hintText:   'Search notes...',
        prefixIcon: Icon(Icons.search_rounded,
            color: scheme.onSurface.withOpacity(0.4), size: 20),
        suffixIcon: _ctrl.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear_rounded,
                    color: scheme.onSurface.withOpacity(0.4), size: 18),
                onPressed: () {
                  _ctrl.clear();
                  provider.clearSearch();
                  _focus.unfocus();
                  setState(() {});
                },
              )
            : null,
      ),
    );
  }
}
