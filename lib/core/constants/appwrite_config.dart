class AppwriteConfig {
  static String endPoint = 'https://fra.cloud.appwrite.io/v1';
  static String projectId = '6825a463002d35b87b9c';
  static String databaseId = '682606330003d48f1808';
  static String boxCollection = '68260679002e501c45f6';
  static String boxUserCollection = '682606af000d51ba45b3';
  static String groupCollection = '6826071c00145957dc64';
  static String groupUserCollection = '68260747001353af3782';
  static String expenseCollection = '6826075600215b66ed3d';
  static String expenseUserCollection = '682607700032d7528aa1';
  static String usersCollection = '68260781000ac685fc36';
  static String userFriendCollection = '6826078f001b57cc9d37';
  static String imagesBucket = '682607b2003c4d883989';
  static String imageUrl(String imageId) =>
      'https://fra.cloud.appwrite.io/v1/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}

