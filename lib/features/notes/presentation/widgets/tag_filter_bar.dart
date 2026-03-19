import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/notes_provider.dart';

class TagFilterBar extends StatelessWidget {
  const TagFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider  = context.watch<NotesProvider>();
    final tags      = provider.allTags;
    final activeTag = provider.activeTag;

    if (tags.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding:         const EdgeInsets.symmetric(horizontal: 20),
        itemCount:       tags.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          if (i == 0) {
            return _TagChip(
              label:    'All',
              selected: activeTag.isEmpty,
              onTap:    () => provider.setActiveTag(''),
            );
          }
          final tag = tags[i - 1];
          return _TagChip(
            label:    tag,
            selected: activeTag == tag,
            onTap:    () => provider.setActiveTag(tag),
          );
        },
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String       label;
  final bool         selected;
  final VoidCallback onTap;

  const _TagChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : Theme.of(context).dividerTheme.color ?? AppColors.darkDivider,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: selected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
