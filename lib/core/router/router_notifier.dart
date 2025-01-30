import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/auth/presentation/pages/auth_home_page.dart';
import 'package:dongi/modules/auth/presentation/pages/sign_up_otp_input_page.dart';
import 'package:dongi/modules/auth/presentation/pages/sign_up_set_password_page.dart';
import 'package:dongi/modules/box/presentation/pages/box_detail_page.dart';
import 'package:dongi/modules/expense/presentation/pages/create_expense_page.dart';
import 'package:dongi/modules/expense/presentation/pages/made_by_page.dart';
import 'package:dongi/modules/expense/presentation/pages/split_page.dart';
import 'package:dongi/modules/friend/presentation/pages/add_friend_page.dart';
import 'package:dongi/modules/friend/presentation/pages/friends_list_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../modules/auth/presentation/pages/sign_in_page.dart';
import '../../modules/auth/presentation/pages/sign_up_email_page.dart';
import '../../modules/box/presentation/pages/create_box_page.dart';
import '../../modules/box/presentation/pages/update_box_page.dart';
import '../../modules/expense/presentation/pages/expense_detail_page.dart';
import '../../modules/expense/presentation/pages/update_expense_page.dart';
import '../../modules/group/presentation/pages/create_group_page.dart';
import '../../modules/group/presentation/pages/group_detail_page.dart';
import '../../modules/group/presentation/pages/group_list_page.dart';
import '../../modules/group/presentation/pages/update_group_page.dart';
import '../../modules/home/presentation/pages/home_page.dart';
import '../../modules/onboarding/presentation/pages/onboarding_page.dart';
import '../../modules/splash/presentation/pages/splash_page.dart';
import '../../modules/group/domain/models/group_model.dart';

final navigatorKey = GlobalKey<NavigatorState>();
// final routerProvider = StateProvider.family(
//   (ref, arg) => _goRouterConfig(ref),
// );

final goRouterProvider = Provider<GoRouter>(
  (ref) => _goRouterConfig(ref),
);

class RouteName {
  const RouteName._();

  static String home = '/';
  static String splash = '/splash';
  static String signin = '/signin';
  static String authHome = '/auth';
  static String signupEmail = '/signup/email';
  static String signupOTPInput = '/signup/otp';
  static String setPassword = '/set-password';
  static String onboarding = '/onboarding';
  static String groupList = '/group';
  static String createGroup = '/group/create';
  static String updateGroup = '/group/update';
  static String createBox = '/box/create';
  static String updateBox = '/box/update';
  static String groupDetail(String? groupId) =>
      '/group/${groupId ?? ":groupId"}';
  static String boxDetail(String? boxId) => '/box/${boxId ?? ":boxId"}';
  static String friendList = '/friend/list';
  static String addFriend = '/friend/add';
  static String createExpense = '/expense/create';
  static String updateExpense = '/expense/update';
  static String expenseMadeBy = '/expense/madeByd';
  static String expenseSplit = '/expense/split';
  static String expenseDetail = '/expense/detail';
}

GoRouter _goRouterConfig(Ref ref) {
  return GoRouter(
    initialLocation: RouteName.splash,
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: RouteName.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteName.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteName.authHome,
        builder: (context, state) => const AuthHomePage(),
      ),
      GoRoute(
        path: RouteName.signupEmail,
        builder: (context, state) => SignUpEmailPage(),
      ),
      GoRoute(
        path: RouteName.signupOTPInput,
        builder: (context, state) {
          Map<String, String> extra = state.extra as Map<String, String>;

          return SignUpOTPInputPage(
            userId: extra['userId']!,
            email: extra['email']!,
          );
        },
      ),
      GoRoute(
        path: RouteName.signin,
        builder: (context, state) {
          Map<String, String>? extra = state.extra as Map<String, String>?;

          return SignInPage(email: extra != null ? extra["email"] : null);
        },
      ),
      GoRoute(
        path: RouteName.setPassword,
        builder: (context, state) {
          Map<String, String> extra = state.extra as Map<String, String>;

          return SetPasswordPage(userId: extra["userId"]!);
        },
      ),
      GoRoute(
        path: RouteName.onboarding,
        builder: (context, state) => OnboardingPage(),
      ),
      GoRoute(
        path: RouteName.groupList,
        builder: (context, state) => const GroupListPage(),
      ),
      GoRoute(
        path: RouteName.createGroup,
        builder: (context, state) => CreateGroupPage(),
      ),
      GoRoute(
        path: RouteName.friendList,
        builder: (context, state) => const FriendsListPage(),
      ),
      GoRoute(
        path: RouteName.addFriend,
        builder: (context, state) => const AddFriendPage(),
      ),
      GoRoute(
        path: RouteName.createBox,
        builder: (context, state) {
          Map extra = state.extra as Map<String, dynamic>;
          return CreateBoxPage(
            groupModel: extra["groupModel"],
          );
        },
      ),
      GoRoute(
        path: RouteName.updateGroup,
        builder: (context, state) {
          GroupModel groupModel = state.extra as GroupModel;
          return UpdateGroupPage(groupModel: groupModel);
        },
      ),
      GoRoute(
        path: RouteName.updateBox,
        builder: (context, state) {
          Map extra = state.extra as Map<String, dynamic>;
          return UpdateBoxPage(boxModel: extra['boxModel']);
        },
      ),
      GoRoute(
        path: RouteName.boxDetail(null),
        builder: (context, state) {
          String boxId = state.pathParameters['boxId']!;
          Map extra = state.extra as Map<String, dynamic>;
          return BoxDetailPage(
            boxId: boxId,
            groupModel: extra['groupModel'],
          );
        },
      ),
      GoRoute(
        path: RouteName.groupDetail(null),
        builder: (context, state) {
          String groupId = state.pathParameters['groupId']!;
          return GroupDetailPage(groupId: groupId);
        },
      ),
      GoRoute(
        path: RouteName.createExpense,
        builder: (context, state) {
          Map extra = state.extra as Map<String, dynamic>;
          return CreateExpensePage(
            boxModel: extra['boxModel'],
            groupModel: extra['groupModel'],
          );
        },
      ),
      GoRoute(
        path: RouteName.updateExpense,
        builder: (context, state) {
          Map extra = state.extra as Map<String, dynamic>;
          return UpdateExpensePage(
            expenseModel: extra['expenseModel'],
            boxModel: extra['boxModel'],
            groupModel: extra['groupModel'],
          );
        },
      ),
      GoRoute(
        path: RouteName.expenseMadeBy,
        builder: (context, state) => const MadeByPage(),
      ),
      GoRoute(
        path: RouteName.expenseSplit,
        builder: (context, state) {
          Map extra = state.extra as Map<String, dynamic>;
          return SplitPage(
            expenseCost: extra["expenseCost"],
          );
        },
      ),
      GoRoute(
        path: RouteName.expenseDetail,
        builder: (context, state) {
          Map extra = state.extra as Map<String, dynamic>;
          return ExpenseDetailPage(
            expenseId: extra["expenseId"],
          );
        },
      ),
    ],
    redirect: (context, state) async {
      if (state.uri.toString() == RouteName.signupEmail ||
          state.uri.toString() == RouteName.signin ||
          state.uri.toString() == RouteName.splash ||
          state.uri.toString() == RouteName.onboarding ||
          state.uri.toString() == RouteName.signupOTPInput) {
        //user try to sign in or sign up
        return null;
      }

      final user = ref.watch(currentUserProvider);
      if (user != null) {
        return null;
      }

      return RouteName.authHome;
    },
  );
}
