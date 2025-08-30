import 'package:flutter/material.dart';
import 'package:trash_hunt/core/routing/app_router.dart';

class QuestCard extends StatelessWidget {
  final Map<String, dynamic> questData;
  final VoidCallback? onQuestCompleted;
  const QuestCard({super.key, required this.questData, this.onQuestCompleted});

  @override
  Widget build(BuildContext context) {
    String capitalizedTitle = questData['trash'][0].toUpperCase() + questData['trash'].substring(1);

    final int progress = questData['progress'] ?? 0;
    final int target = questData['target_count'] ?? 1;
    final bool isDone = questData['is_done'] == true;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.green.shade100,
        highlightColor: Colors.green.shade50,
        onTap: () async {
          await Navigator.pushNamed(
            context,
            AppRouter.questDetail,
            arguments: {'questData': questData},
          );
          if (onQuestCompleted != null) {
            onQuestCompleted!();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isDone ? Colors.green.shade100 : Colors.green.shade50,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.green.shade100.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isDone ? Colors.green.shade400 : Colors.green.shade200,
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              // Icon utama
              CircleAvatar(
                backgroundColor: isDone ? Colors.green.shade400 : Colors.green.shade700,
                radius: 26,
                child: Icon(
                  isDone ? Icons.verified : Icons.flag,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Info quest
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      capitalizedTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange.shade400, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          'XP: ${questData['exp_reward']}',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.monetization_on, color: Colors.amber.shade700, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          'Coins: ${questData['coins_reward']}',
                          style: TextStyle(
                            color: Colors.amber.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (!isDone)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (progress / target).clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: Colors.green.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
                        ),
                      ),
                    if (!isDone)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          "$progress / $target selesai",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ),
                    if (isDone)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          "Misi selesai 🎉",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Icon kamera
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: isDone
                    ? Icon(Icons.check_circle, key: const ValueKey('done'), color: Colors.green.shade700, size: 28)
                    : Icon(Icons.camera_enhance, key: const ValueKey('camera'), color: Colors.green.shade400, size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}