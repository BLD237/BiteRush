import 'package:flutter/material.dart';
import 'package:food_delivery/features/navigation/presentation/widgets/app_bottom_navigation_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _DestinationScaffold(
      title: 'Profile',
      subtitle: 'Manage your account and preferences',
      activeIndex: 1,
    );
  }
}

class _DestinationScaffold extends StatelessWidget {
  const _DestinationScaffold({
    required this.title,
    required this.subtitle,
    required this.activeIndex,
  });

  final String title;
  final String subtitle;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF3A2A26),
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF4F3B33),
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(activeIndex: activeIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFEF2A39),
        foregroundColor: Colors.white,
        elevation: 8,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
