import 'package:flutter/material.dart';
import 'package:trash_hunt/core/routing/app_router.dart';

class TrashDetailCard extends StatelessWidget {
  final String type;
  final String description;
  const TrashDetailCard({super.key, required this.type, required this.description});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        splashColor: Colors.green.withValues(alpha: 0.12),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRouter.trashDetail,
            arguments: {
              'type': type,
              'description': description,
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.green.shade100.withValues(alpha: 0.18),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green.shade200,
                radius: 22,
                child: Icon(Icons.eco, color: Colors.green.shade700, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  type,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.green.shade900,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: scheme.primary,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}