import 'package:dongi/core/router/router_names.dart';
import 'package:dongi/core/router/router_notifier.dart';
import 'package:dongi/modules/auth/presentation/pages/enter_name_page.dart';
import 'package:dongi/modules/expense/presentation/pages/made_by_page.dart';
import 'package:dongi/modules/expense/presentation/pages/split_page.dart';
import 'package:dongi/modules/user/presentation/pages/profile_page.dart';
import 'package:dongi/modules/group/presentation/pages/add_group_member_page.dart';
import 'package:dongi/modules/user/domain/di/user_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../modules/auth/domain/di/auth_controller_di.dart';
import '../../modules/auth/presentation/pages/auth_entry_page.dart';
import '../../modules/auth/presentation/pages/sign_in_page.dart';
import '../../modules/auth/presentation/pages/sign_up_email_page.dart';
import '../../modules/auth/presentation/pages/sign_up_otp_input_page.dart';
import '../../modules/auth/presentation/pages/sign_up_set_password_page.dart';
import '../../modules/box/presentation/pages/box_detail_page.dart';
import '../../modules/box/presentation/pages/create_box_page.dart';
import '../../modules/expense/presentation/pages/create_expense_page.dart';
import '../../modules/expense/presentation/pages/expense_detail_page.dart';
import '../../modules/expense/presentation/pages/update_expense_page.dart';
import '../../modules/friend/presentation/pages/add_friend_page.dart';
import '../../modules/friend/presentation/pages/friends_list_page.dart';
import '../../modules/group/presentation/pages/create_group_page.dart';
import '../../modules/group/presentation/pages/group_detail_page.dart';
import '../../modules/group/presentation/pages/group_list_page.dart';
import '../../modules/group/presentation/pages/update_group_page.dart';
import '../../modules/home/presentation/pages/home_page.dart';
import '../../modules/onboarding/presentation/pages/onboarding_page.dart';
import '../../modules/splash/presentation/pages/splash_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: RouteName.splash,
      navigatorKey: navigatorKey,
      refreshListenable: ref.watch(goRouterNotifierProvider),
      redirect: (context, state) {
        final user = ref.read(currentUserProvider);

        // Allow public routes without redirection
        final publicRoutes = [
          RouteName.signupEmail,
          RouteName.signin,
          RouteName.splash,
          RouteName.onboarding,
          RouteName.signupOTPInput,
          RouteName.authHome,
          RouteName.enterName,
        ];

        // Check if the current location matches any public route
        if (publicRoutes.contains(state.fullPath)) {
          return null;
        }

        // If user is not authenticated, redirect to auth home
        if (user == null) {
          return RouteName.authHome;
        }

        // Get user data to check for name
        final userData = ref.read(userNotifierProvider).value;
        
        // Only redirect to enterName if we have loaded user data and confirmed there's no name
        if (userData != null && 
            (userData.userName == null || userData.userName!.isEmpty) && 
            state.fullPath != RouteName.enterName &&
            state.fullPath != RouteName.home) { // Allow home page access initially
          return RouteName.enterName;
        }

        // If we're on enterName page but user has a name, redirect to home
        if (userData != null && 
            userData.userName != null && 
            !userData.userName!.isEmpty && 
            state.fullPath == RouteName.enterName) {
          return RouteName.home;
        }

        return null;
      },
      routes: [
        GoRoute(
            path: RouteName.home,
            builder: (context, state) => const HomePage()),
        GoRoute(
            path: RouteName.splash,
            builder: (context, state) => const SplashPage()),
        GoRoute(
            path: RouteName.authHome,
            builder: (context, state) => const AuthEntryPage()),
        GoRoute(
            path: RouteName.signupEmail,
            builder: (context, state) => SignUpEmailPage()),
        GoRoute(
          path: RouteName.signupOTPInput,
          builder: (context, state) {
            Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
            return SignUpOTPInputPage(
                userId: extra['userId']!, email: extra['email']!);
          },
        ),
        GoRoute(
          path: RouteName.signin,
          builder: (context, state) {
            Map<String, dynamic>? extra = state.extra as Map<String, dynamic>?;
            return SignInPage(email: extra?["email"]);
          },
        ),
        GoRoute(
            path: RouteName.setPassword,
            builder: (context, state) => const SetPasswordPage()),
        GoRoute(
            path: RouteName.enterName,
            builder: (context, state) => const EnterNamePage()),
        GoRoute(
            path: RouteName.onboarding,
            builder: (context, state) => OnboardingPage()),
        GoRoute(
            path: RouteName.groupList,
            builder: (context, state) => const GroupListPage()),
        GoRoute(
            path: RouteName.createGroup,
            builder: (context, state) => CreateGroupPage()),
        GoRoute(
            path: RouteName.friendList,
            builder: (context, state) => const FriendsListPage()),
        GoRoute(
            path: RouteName.addFriend,
            builder: (context, state) => const AddFriendPage()),
        GoRoute(
            path: RouteName.profile,
            builder: (context, state) => const ProfilePage()),
        GoRoute(
          path: RouteName.createBox,
          builder: (context, state) {
            Map extra = state.extra as Map<String, dynamic>;
            return CreateBoxPage(groupModel: extra["groupModel"]);
          },
        ),
        GoRoute(
          path: RouteName.updateGroup,
          builder: (context, state) {
            return UpdateGroupPage(groupModel: state.extra as dynamic);
          },
        ),
        GoRoute(
          path: RouteName.addGroupMember,
          builder: (context, state) {
            return AddGroupMemberPage(groupModel: state.extra as dynamic);
          },
        ),
        GoRoute(
          path: RouteName.boxDetail(null),
          builder: (context, state) {
            String boxId = state.pathParameters['boxId']!;
            Map extra = state.extra as Map<String, dynamic>;
            return BoxDetailPage(boxId: boxId, groupModel: extra['groupModel']);
          },
        ),
        GoRoute(
          path: RouteName.groupDetail(null),
          builder: (context, state) {
            return GroupDetailPage(groupId: state.pathParameters['groupId']!);
          },
        ),
        GoRoute(
          path: RouteName.createExpense,
          builder: (context, state) {
            Map extra = state.extra as Map<String, dynamic>;
            return CreateExpensePage(
                boxModel: extra['boxModel'], groupModel: extra['groupModel']);
          },
        ),
        GoRoute(
          path: RouteName.updateExpense,
          builder: (context, state) {
            Map extra = state.extra as Map<String, dynamic>;
            return UpdateExpensePage(
                expenseModel: extra['expenseModel'],
                boxModel: extra['boxModel'],
                groupModel: extra['groupModel']);
          },
        ),
        GoRoute(
            path: RouteName.expenseMadeBy,
            builder: (context, state) => const MadeByPage()),
        GoRoute(
            path: RouteName.expenseSplit,
            builder: (context, state) {
              Map extra = state.extra as Map<String, dynamic>;
              return SplitPage(expenseCost: extra["expenseCost"]);
            }),
        GoRoute(
            path: RouteName.expenseDetail,
            builder: (context, state) {
              Map extra = state.extra as Map<String, dynamic>;
              return ExpenseDetailPage(expenseId: extra["expenseId"]);
            }),
      ],
    );
  },
);
