import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:master_utility/master_utility.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/features/create_post/views/create_post_screen.dart';
import 'package:tune_stack/features/home/controllers/home_state_notifier.dart';
import 'package:tune_stack/features/home/views/home_screen.dart';
import 'package:tune_stack/features/profile/views/profile_screen.dart';

class BottomNavBarScreen extends ConsumerStatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  ConsumerState<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends ConsumerState<BottomNavBarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CreatePostScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      NavigationHelper.navigatePush(route: const CreatePostScreen());
      return;
    }
    setState(() {
      if (_selectedIndex == 0 && index == 0) {
        ref.read(homeStateNotifierProvider.notifier).getAllPosts();
      } else if (_selectedIndex == 2 && index == 2) {
        ref.read(homeStateNotifierProvider.notifier).getUserByUserId();
      }
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeStateNotifierProvider.notifier).getAllPosts();
      ref.read(homeStateNotifierProvider.notifier).getUserByUserId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
          color: AppColors.white,
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.white,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.divider,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              activeIcon: Icon(Icons.add_box),
              label: 'Create Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
