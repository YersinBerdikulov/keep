import { Client, Databases } from 'node-appwrite';

// Initialize the Appwrite client
const client = new Client()
  .setEndpoint(process.env.END_POINT)
  .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
  .setKey(process.env.APPWRITE_API_KEY);

const databases = new Databases(client);

// The Appwrite function
export default async ({ req, res, log, error }) => {
  try {
    // Check if request method is POST
    if (req.method === 'POST') {
      const { title, description, creatorId, groupId, image, boxUsers, total } =
        req.body;

      log(req.body);
      log(title, description, creatorId, groupId, image, boxUsers, total);

      // Validate input
      if (!title || !groupId || !creatorId) {
        return res.json({ status: 400, error: 'Missing required fields' });
      }

      // Prepare the box data
      const boxData = {
        title: title,
        description: description,
        creatorId: creatorId,
        groupId: groupId,
        image: image,
        boxUsers: boxUsers,
        total: total,
      };

      // Add box to the database
      const addBoxResult = await databases.createDocument(
        process.env.DATABASE_ID,
        process.env.BOX_COLLECTION_ID,
        'unique()',
        boxData
      );

      const boxId = addBoxResult.$id;

      // Retrieve the group document
      const groupDocument = await databases.getDocument(
        process.env.DATABASE_ID,
        process.env.GROUP_COLLECTION_ID,
        groupId
      );

      // Update the group document by adding the new boxId
      const updatedBoxIds = [...groupDocument.boxIds, boxId];

      const updatedGroupData = {
        ...groupDocument,
        boxIds: updatedBoxIds,
      };

      await databases.updateDocument(
        process.env.DATABASE_ID,
        process.env.GROUP_COLLECTION_ID,
        groupId,
        updatedGroupData
      );

      // Respond with the result
      return res.json({ status: 200, data: addBoxResult });
    } else {
      return res.json({ status: 403, error: 'Method Not Allowed' }); // Use `res.json()` to set the response and status
    }
  } catch (err) {
    error(err.message);
    return res.json({ status: 500, error: err.message }); // Use `res.json()` to set the response and status
  }
};
