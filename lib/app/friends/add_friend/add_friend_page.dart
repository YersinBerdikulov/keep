import 'package:dongi/app/friends/add_friend/add_friend_widget.dart';
import 'package:dongi/app/friends/controller/friend_controller.dart';
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

    useEffect(() {
      Future<void> searchFriends() async {
        if (searchController.text.length > 2) {
          final results = await ref
              .read(friendNotifierProvider.notifier)
              .searchFriends(searchController.text);
          searchResults.value = results;
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
            const Divider(),
            Expanded(child: AddFriendList(searchResults.value)),
          ],
        ),
      ),
    );
  }
}
