import 'package:flutter/material.dart';
import 'package:trash_hunt/core/routing/app_router.dart';

class QuestCard extends StatelessWidget {
  final String trashType;
  const QuestCard({super.key, required this.trashType});


  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    String capitalizedTrashType = trashType[0].toUpperCase() + trashType.substring(1);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRouter.questDetail,
            arguments: {'type': trashType},
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 12),
                Icon(
                  Icons.recycling
                ),
                const SizedBox(width: 12),
                Text(
                  capitalizedTrashType,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: const Icon(
                Icons.camera_enhance,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}