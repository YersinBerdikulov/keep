import 'package:dongi/core/router/router_names.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/user/domain/di/user_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Make the API call to get user data
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Make the API call to Appwrite "get account" endpoint
      final user = await ref.read(authControllerProvider.notifier).currentUser();

      if (user != null) {
        // Update the auth state with the user data
        ref.read(currentUserProvider.notifier).state = user;

        // Get the user data from the database
        final userData = await ref.read(userNotifierProvider.notifier).currentUser;

        if (userData == null || userData.userName == null || userData.userName!.isEmpty) {
          // If user has no name, redirect to enter name page
          if (mounted) {
            context.go(RouteName.enterName);
          }
          return;
        }

        // If user has a name, proceed to home
        if (mounted) {
          context.go(RouteName.home);
        }
      } else {
        if (mounted) {
          context.go(RouteName.authHome);
        }
      }
    } catch (error) {
      // Handle the error, such as showing an error message
      debugPrint('Error fetching user data: $error');
      if (mounted) {
        context.go(RouteName.signin);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Display a loading indicator or a splash screen UI
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
