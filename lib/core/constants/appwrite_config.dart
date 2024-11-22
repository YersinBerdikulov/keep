class AppwriteConfig {
  static String endPoint = 'https://cloud.appwrite.io/v1';
  static String projectId = '669e542d000c80288e0e';
  static String databaseId = '6687c9910025465bb7d3';
  static String boxCollection = '6697b86600200a44a26d';
  static String boxUserCollection = '66991e8b0006f7a5e1a6';
  static String groupCollection = '6687cc90003689fd4849';
  static String groupUserCollection = '66991fab00086ada0493';
  static String expenseCollection = '6697cc00000f154bb971';
  static String expenseUserCollection = '66991f18003c857748fd';
  static String usersCollection = '6687c9bc0026b33e80c1';
  static String userFriendCollection = '66992010001fe10595f9';
  static String imagesBucket = '6697ba71001fc29781b9';
  static String imageUrl(String imageId) =>
      'https://cloud.appwrite.io/v1/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
