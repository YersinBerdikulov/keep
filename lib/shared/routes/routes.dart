// Define route names for the application
class RouteName {
  const RouteName._();

  static String home = '/';
  static String splash = '/splash';
  static String signin = '/signin';
  static String signup = '/signup';
  static String onboarding = '/onboarding';
  static String groupList = '/group';
  static String createGroup = '/group/create';
  static String updateGroup = '/group/update';
  static String groupDetail(String? groupId) => '/group/${groupId ?? ":groupId"}';
  static String addGroupMember = '/group/add-member';
  static String manageGroupMembers = '/group/manage-members';
  static String createBox = '/box/create';
  static String updateBox = '/box/update';
  static String boxDetail = '/box/detail';
  static String addBoxMember = '/box/add-member';
  static String createExpense = '/expense/create';
  static String updateExpense = '/expense/update';
  static String expenseDetail = '/expense/detail';
} 