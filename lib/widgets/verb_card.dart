import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/verb.dart';
import '../theme/app_theme.dart';

class VerbCard extends StatelessWidget {
  final Verb verb;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onToggleFavorite;
  final VoidCallback onEdit;

  const VerbCard({
    super.key,
    required this.verb,
    required this.onTap,
    required this.onDelete,
    required this.onToggleFavorite,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.42,
          children: [
            SlidableAction(
              onPressed: (_) => onEdit(),
              backgroundColor: AppTheme.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit_outlined,
              label: 'Edit',
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
            ),
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: AppTheme.red,
              foregroundColor: Colors.white,
              icon: Icons.delete_outline,
              label: 'Delete',
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(14)),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                // ── Base card with uniform border ─────────────────────
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.lightGray.withOpacity(0.6),
                      width: 0.5,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      verb.isFavorite ? 17 : 14,
                      12,
                      10,
                      12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Verb name + type label ────────────
                              Row(
                                children: [
                                  Text(
                                    verb.baseForm,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.black,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Always show the label: regular or irregular
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                     color: verb.isIrregular
                                        ? AppTheme.amberSoft
                                        : const Color(0xFFFFF8E1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      verb.isIrregular ? 'irregular' : 'regular',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        color: verb.isIrregular
                                            ? const Color(0xFF854F0B)
                                            : const Color(0xFF6D6B11),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              // ── Verb form pills ───────────────────
                              Row(
                                children: [
                                  _FormPill(
                                    text: verb.pastSimple,
                                    color: AppTheme.blueSoft,
                                    textColor: const Color(0xFF185FA5),
                                  ),
                                  const SizedBox(width: 6),
                                  _FormPill(
                                    text: verb.pastParticiple,
                                    color: AppTheme.greenSoft,
                                    textColor: const Color(0xFF3B6D11),
                                  ),
                                ],
                              ),
                              if (verb.meaning != null &&
                                  verb.meaning!.isNotEmpty) ...[
                                const SizedBox(height: 5),
                                Text(
                                  verb.meaning!,
                                  style: const TextStyle(
                                      fontSize: 12, color: AppTheme.medGray),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        // ── Favorite star ─────────────────────────
                        GestureDetector(
                          onTap: onToggleFavorite,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              verb.isFavorite
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: verb.isFavorite
                                  ? AppTheme.amber
                                  : AppTheme.lightGray,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Favorite accent bar (left edge) ───────────────────
                if (verb.isFavorite)
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 3,
                      decoration: const BoxDecoration(
                        color: AppTheme.amber,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(14),
                        ),
                      ),
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

class _FormPill extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _FormPill(
      {required this.text, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 11, color: textColor, fontWeight: FontWeight.w500),
      ),
    );
  }
}
