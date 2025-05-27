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

class AddFriendPage extends HookConsumerWidget {
  const AddFriendPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController(text: '');
    final searchResults = useState<List<UserModel>>([]);
    final isLoading = useState<bool>(false);
    final debouncer = useState<Future<void>?>(null);

    /// Listening to changes in the friendNotifierProvider without rebuilding the UI
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

    useEffect(() {
      void performSearch() async {
        if (searchController.text.length > 2) {
          isLoading.value = true;
          try {
            final results = await ref
                .read(friendNotifierProvider.notifier)
                .searchFriends(searchController.text);
            if (!context.mounted) return;
            searchResults.value = results;
          } catch (e) {
            if (context.mounted) {
              showSnackBar(context, content: e.toString());
            }
          } finally {
            if (context.mounted) {
              isLoading.value = false;
            }
          }
        } else {
          searchResults.value = [];
        }
      }

      void debouncedSearch() {
        // Cancel previous debouncer if it exists
        debouncer.value?.ignore();

        // Create new debouncer
        debouncer.value = Future.delayed(const Duration(milliseconds: 300), () {
          if (context.mounted) {
            performSearch();
          }
        });
      }

      searchController.addListener(debouncedSearch);

      return () {
        searchController.removeListener(debouncedSearch);
        debouncer.value?.ignore();
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
                  : searchController.text.length <= 2
                      ? const Center(
                          child: Text('Enter at least 3 characters to search'),
                        )
                      : AddFriendList(searchResults.value),
            ),
          ],
        ),
      ),
    );
  }
}
