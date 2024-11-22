import 'package:dongi/app/friends/add_friend/add_friend_widget.dart';
import 'package:dongi/app/friends/controller/friend_controller.dart';
import 'package:dongi/core/utilities/helpers/snackbar_helper.dart';
import 'package:dongi/models/user_model.dart';
import 'package:dongi/widgets/appbar/appbar.dart';
import 'package:dongi/widgets/text_field/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddFriendPage extends HookConsumerWidget {
  const AddFriendPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController(text: '');
    final searchResults = useState<List<UserModel>>([]);
    final isLoading = useState<bool>(false);

    /// Listen for changes in the friendNotifierProvider state
    ref.listen<FriendState>(
      friendNotifierProvider,
      (previous, next) {
        next.whenOrNull(
          loaded: () {
            // Pop to prev page
            Navigator.pop(context);

            // Refresh the friend list and handle the result
            ref.refresh(getFriendProvider);

            // Show success SnackBar
            showSnackBar(context, "Friend request sent successfully!");
          },
          error: (message) {
            // Show error SnackBar
            showSnackBar(context, message);
          },
        );
      },
    );

    useEffect(() {
      Future<void> searchFriends() async {
        if (searchController.text.length > 2) {
          isLoading.value = true; // Start loading
          final results = await ref
              .read(friendNotifierProvider.notifier)
              .searchFriends(searchController.text);
          searchResults.value = results;
          isLoading.value = false; // Stop loading
        } else {
          searchResults.value = [];
        }
      }

      searchFriends(); // Initial search on mount

      searchController.addListener(() {
        searchFriends();
      });

      return () {
        searchController.removeListener(() {
          searchFriends();
        });
      };
    }, [searchController]);

    return Scaffold(
      appBar: AppBarWidget(
        title: "Add Friend",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFieldWidget(
              controller: searchController,
              hintText: "Search with UserName or Email",
            ),
            const Divider(thickness: 1),
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
