import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/note.dart';
import '../providers/theme_provider.dart';

class NoteCard extends StatelessWidget {
  final Note         note;
  final bool         isGrid;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const NoteCard({
    super.key,
    required this.note,
    required this.isGrid,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark     = context.watch<ThemeProvider>().isDark;
    final colors     = isDark ? AppColors.noteColorsDark : AppColors.noteColorsLight;
    final accent     = AppColors.noteAccents[note.colorIndex % AppColors.noteAccents.length];
    final cardColor  = colors[note.colorIndex % colors.length];
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSec    = isDark ? AppColors.darkTextSec : const Color(0xFF606080);
    final dividerC   = isDark ? AppColors.darkDivider : AppColors.lightDivider;

    return GestureDetector(
      onTap:       onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color:        cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: note.colorIndex == 0
                ? dividerC
                : accent.withOpacity(0.35),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withOpacity(isDark ? 0.25 : 0.06),
              blurRadius: 8,
              offset:     const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pin + title row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: note.title.isNotEmpty
                      ? Text(
                          note.title,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: textPrimary,
                            fontSize: isGrid ? 14 : 16,
                          ),
                          maxLines: isGrid ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          'Untitled',
                          style: AppTextStyles.titleSmall.copyWith(
                            color: textSec,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                ),
                if (note.isPinned) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.push_pin_rounded,
                      size: 14, color: accent),
                ],
              ],
            ),

            if (note.preview.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                note.preview,
                style: AppTextStyles.bodySmall.copyWith(
                  color:  textSec,
                  height: 1.5,
                ),
                maxLines: isGrid ? 4 : 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const Spacer(),

            // Tags
            if (note.tags.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing:    6,
                runSpacing: 4,
                children: note.tags.take(isGrid ? 2 : 3).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color:        accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag,
                      style: AppTextStyles.label.copyWith(
                          color: accent, fontSize: 10),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
            ],

            // Date
            Text(
              _formatDate(note.updatedAt),
              style: AppTextStyles.label.copyWith(
                  color: textSec.withOpacity(0.7), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now   = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date  = DateTime(dt.year, dt.month, dt.day);
    if (date == today) return DateFormat('h:mm a').format(dt);
    if (today.difference(date).inDays == 1) return 'Yesterday';
    if (today.difference(date).inDays < 7)  return DateFormat('EEEE').format(dt);
    return DateFormat('d MMM yyyy').format(dt);
  }
}
