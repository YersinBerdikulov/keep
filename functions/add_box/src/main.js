import { Client, Databases } from 'node-appwrite';

// Initialize the Appwrite client
const client = new Client()
    .setEndpoint('https://cloud.appwrite.io/v1') // Your Appwrite Endpoint
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID) // Your project ID
    .setKey(process.env.APPWRITE_API_KEY); // Your API Key

const databases = new Databases(client);

// The Appwrite function
export default async ({ req, res, log, error }) => {
    try {
        // Check if request method is POST
        if (req.method === 'POST') {
            const { imageUrl, boxTitle, boxDescription, groupId, creatorId } = req.body;

            // Validate input
            if (!boxTitle || !boxDescription || !groupId || !creatorId) {
                return res.status(400).json({ error: 'Missing required fields' });
            }

            // Prepare the box data
            const boxData = {
                title: boxTitle,
                description: boxDescription,
                creatorId: creatorId,
                groupId: groupId,
                image: imageUrl, // Use the image URL provided
                boxUsers: [creatorId],
                total: 0
            };

            // Add box to the database
            const addBoxResult = await databases.createDocument(
                'database_id',  // Replace with your database ID
                'collection_id', // Replace with your collection ID
                'unique()', // Document ID
                boxData
            );

            // Respond with the result
            return res.json(addBoxResult);
        } else {
            return res.status(405).json({ error: 'Method Not Allowed' });
        }
    } catch (err) {
        error(err.message);
        return res.status(500).json({ error: err.message });
    }
};
