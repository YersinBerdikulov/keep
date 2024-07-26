import { Client, Databases, ID } from 'node-appwrite';

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
      log('Request body:', req.body);

      let requestBody = req.body;

      // Ensure requestBody is an object
      if (typeof requestBody !== 'object' || requestBody === null) {
        return res.json({ status: 400, error: 'Invalid request body' });
      }

      // Log requestBody to check its structure
      log('Request body:', requestBody);

      // Destructure the request body
      const { title, description, creatorId, groupId, image, boxUsers, total } =
        requestBody;

      // Log each field to ensure they are being accessed correctly
      log('Title:', typeof title, title);
      log('Description:', typeof description, description);
      log('CreatorId:', typeof creatorId, creatorId);
      log('GroupId:', typeof groupId, groupId);
      log('Image:', typeof image, image);
      log('BoxUsers:', typeof boxUsers, boxUsers);
      log('Total:', typeof total, total);

      // Validate input
      if (!title || !groupId || !creatorId) {
        return res.json({ status: 400, error: 'Missing required fields' });
      }

      // Prepare the box data
      const boxData = {
        title,
        description,
        creatorId,
        groupId,
        image,
        boxUsers,
        total,
      };

      // Add box to the database
      const addBoxResult = await databases.createDocument(
        process.env.DATABASE_ID,
        process.env.BOX_COLLECTION_ID,
        ID.unique(),
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
      return res.json({ status: 403, error: 'Method Not Allowed' });
    }
  } catch (err) {
    error(err.message);
    return res.json({ status: 500, error: err.message });
  }
};
