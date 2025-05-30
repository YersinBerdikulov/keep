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
  static String addGroupMember = '/group/add-member';
  static String createBox = '/box/create';
  static String updateBox = '/box/update';
  static String addBoxMember = '/box/add-member';
  static String friendList = '/friend/list';
  static String addFriend = '/friend/add';
  static String createExpense = '/expense/create';
  static String updateExpense = '/expense/update';
  static String expenseMadeBy = '/expense/madeBy';
  static String expenseSplit = '/expense/split';
  static String expenseAdvancedSplit = '/expense/split/advanced';
  static String expenseDetail = '/expense/detail';
  static String profile = '/profile';
  static String enterName = '/auth/enter-name';
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

  static String groupDetail(String? groupId) =>
      '/group/${groupId ?? ":groupId"}';
  static String boxDetail(String? boxId) => '/box/${boxId ?? ":boxId"}';
}
