import 'package:flutter/material.dart';
import 'package:newst/features/profile/components/profile_header.dart';
import 'package:newst/features/profile/components/profile_info.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),

      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20),

              ProfileHeader(),

              // Profile Info will come here
              SizedBox(height: 28),

              ProfileInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
