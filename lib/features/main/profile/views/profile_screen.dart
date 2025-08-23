import 'package:flutter/material.dart';
import 'package:trash_hunt/widgets/showcase_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const CircleAvatar(
                radius: 50,
              ),
              const SizedBox(height: 16),
              const Text(
                'John Doe',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                "1",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Exp bar
              SizedBox(
                width: 300,
                child: LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              const Text('100/200'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ShowcaseCard(title: "Total Hunt:", value: "10"),
                  ShowcaseCard(title: "Total Hunt:", value: "10"),
                  ShowcaseCard(title: "Total Hunt:", value: "10"),
                ],
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
          
                },
                child: Container(
                  width: 350,
                  height: 60,
                  decoration: BoxDecoration(
                    color: scheme.inversePrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit Profile'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
          
                },
                child: Container(
                  width: 350,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Sign Out'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
