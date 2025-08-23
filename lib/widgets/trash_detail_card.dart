import 'package:flutter/material.dart';
import 'package:trash_hunt/core/routing/app_router.dart';

class TrashDetailCard extends StatelessWidget {
  final String type;
  final String description;
  const TrashDetailCard({super.key, required this.type, required this.description});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap:() {
        Navigator.pushNamed(
          context,
          AppRouter.trashDetail,
          arguments: {
            'type': type,
            'description': description,
          },
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: scheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}