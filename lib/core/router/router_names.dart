class RouteName {
  const RouteName._();

  static String home = '/';
  static String splash = '/splash';
  static String signin = '/auth/signin';
  static String authHome = '/auth';
  static String signupEmail = '/auth/signup/email';
  static String signupOTPInput = '/auth/signup/otp';
  static String setPassword = '/auth/signup/password';
  static String onboarding = '/onboarding';
  static String groupList = '/groups';
  static String createGroup = '/groups/create';
  static String updateGroup = '/groups/update';
  static String addGroupMember = '/groups/members/add';
  static String manageGroupMembers = '/groups/members/manage';
  static String createBox = '/boxes/create';
  static String updateBox = '/box/update';
  static String addBoxMember = '/boxes/members/add';
  static String friendList = '/friends';
  static String addFriend = '/friends/add';
  static String createExpense = '/expenses/create';
  static String updateExpense = '/expenses/update';
  static String expenseMadeBy = '/expenses/made-by';
  static String expenseSplit = '/expenses/split';
  static String expenseAdvancedSplit = '/expenses/split/advanced';
  static String expenseDetail = '/expenses/detail';
  static String allTransactions = '/transactions/all';
  static String profile = '/profile';
  static String enterName = '/auth/name';
  static String group = '/group';
  static String box = '/box';
  static String expense = '/expense';
  static String category = '/category';
  static String search = '/search';
  static String notification = '/notification';
  static String settings = '/settings';
  static String about = '/about';
  static String help = '/help';
  static String privacy = '/privacy';
  static String terms = '/terms';
  static String contact = '/contact';
  static String feedback = '/feedback';
  static String report = '/report';
  static String error = '/error';
  static String notFound = '/404';
  static String settleUp = '/settle-up';

  static String groupDetail(String? groupId) =>
      '/groups/${groupId ?? ':groupId'}';
  static String boxDetail(String? boxId) => '/boxes/${boxId ?? ':boxId'}';
}
