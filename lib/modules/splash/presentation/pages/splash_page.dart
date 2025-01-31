import 'package:dongi/core/router/router_names.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
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
      final user =
          await ref.read(authControllerProvider.notifier).currentUser();

      if (user != null) {
        // Update the state or provider with the user data
        ref.watch(currentUserProvider.notifier).state = user;
        // Push to home
        context.go(RouteName.home);
      } else {
        context.go(RouteName.onboarding);
      }
    } catch (error) {
      // Handle the error, such as showing an error message
      debugPrint('Error fetching user data: $error');
      //Navigator.pushReplacementNamed(context, '/error');
      context.go(RouteName.signin);
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
