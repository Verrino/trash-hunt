import 'package:flutter/material.dart';
import 'package:trash_hunt/core/routing/app_router.dart';

class QuestCard extends StatelessWidget {
  final Map<String, dynamic> questData;
  const QuestCard({super.key, required this.questData});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    String capitalizedTitle = questData['trash'][0].toUpperCase() + questData['trash'].substring(1);
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
            arguments: {'questData': questData},
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
                  capitalizedTitle,
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