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
            const { 
              title,
description,
creatorId,
groupId,
image,
boxUsers,
total, 
             } = req.body;

log(req.body)

            log(
              title, 
              description,
              creatorId,
              groupId,
              image,
              boxUsers,
              total,
            );

            // Validate input
            if (!boxTitle || !boxDescription || !groupId || !creatorId) {
                return res.json({ error: 'Missing required fields' }); // Use `res.json()` to set the response and status
            }

            // Prepare the box data
            const boxData = { 
              title:      title, 
              description:               description,
                creatorId:               creatorId,
                groupId:               groupId,
                image:               image,
                boxUsers:               boxUsers,
                total:               total,
            };

            // Add box to the database
            const addBoxResult = await databases.createDocument(
                '6687c9910025465bb7d3',  // Replace with your database ID
                '6697b86600200a44a26d', // Replace with your collection ID
                'unique()', // Document ID
                boxData
            );

            // Respond with the result
            return res.json(addBoxResult); // Send JSON response
        } else {
            return res.json({ error: 'Method Not Allowed' }); // Use `res.json()` to set the response and status
        }
    } catch (err) {
        error(err.message);
        return res.json({ error: err.message }); // Use `res.json()` to set the response and status
    }
};
