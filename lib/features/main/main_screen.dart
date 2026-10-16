import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newst/features/bookmark/bookmark_screen.dart';
import 'package:newst/features/home/repositories/news_repository.dart';
import 'package:newst/features/home/screens/home_screen.dart';
import 'package:newst/features/home/services/news_service.dart';
import 'package:newst/features/profile/controller/profile_controller.dart';
import 'package:newst/features/profile/profile_screen.dart';
import 'package:newst/features/search/search_screen.dart';
import 'package:provider/provider.dart';

import '../search/cubit/news_search_cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    BlocProvider(
      create: (_) => NewsSearchCubit(NewsRepository(NewsService.instance)),
      child: const SearchScreen(),
    ),
    const BookmarkScreen(),
    ChangeNotifierProvider(
      create: (_) => ProfileController()..initialize(),
      child: const ProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
