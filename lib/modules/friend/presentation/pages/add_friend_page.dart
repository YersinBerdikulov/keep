import 'package:dongi/modules/friend/domain/models/user_friend_model.dart';
import 'package:dongi/modules/friend/domain/di/friend_controller_di.dart';
import 'package:dongi/modules/friend/presentation/widgets/add_friend_widget.dart';
import 'package:dongi/shared/utilities/helpers/snackbar_helper.dart';
import 'package:dongi/modules/user/domain/models/user_model.dart';
import 'package:dongi/shared/widgets/appbar/appbar.dart';
import 'package:dongi/shared/widgets/text_field/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';

class AddFriendPage extends HookConsumerWidget {
  const AddFriendPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController(text: '');
    final searchResults = useState<List<UserModel>>([]);
    final isLoading = useState<bool>(false);
    
    // Create a timer for debouncing
    final searchDebouncer = useState<Timer?>(null);

    // Cleanup timer when widget is disposed
    useEffect(() {
      return () {
        searchDebouncer.value?.cancel();
      };
    }, []);

    // Listen to friend provider changes
    ref.listen<AsyncValue<List<UserFriendModel>>>(
      friendNotifierProvider,
      (_, state) {
        state.whenOrNull(
          data: (_) {
            // Handle successful friend request if needed
          },
          error: (error, _) => showSnackBar(context, content: error.toString()),
        );
      },
    );

    // Function to perform the search
    void performSearch(String searchTerm) async {
      isLoading.value = true;
      try {
        final results = await ref
            .read(friendNotifierProvider.notifier)
            .searchFriends(searchTerm);
        searchResults.value = results;
      } catch (e) {
        showSnackBar(context, content: e.toString());
      } finally {
        isLoading.value = false;
      }
    }

    // Handle text field changes
    String? handleSearchInput(String? value) {
      // Cancel previous timer if it exists
      searchDebouncer.value?.cancel();
      
      if (value == null || value.isEmpty) {
        searchResults.value = [];
        return value;
      }

      // Set new timer
      searchDebouncer.value = Timer(
        const Duration(milliseconds: 500),
        () => performSearch(value),
      );

      return value;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: 'Add Friend',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFieldWidget(
              controller: searchController,
              hintText: 'Search by email or username',
              onChanged: handleSearchInput,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : AddFriendList(searchResults.value),
            ),
          ],
        ),
      ),
    );
  }
}
