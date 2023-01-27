const admin = require("firebase-admin");
const functions = require("firebase-functions");

admin.initializeApp();

const messaging = admin.messaging();

exports.notifySubscribers = functions.https.onCall(async (data, _) => {

    try {
        const multiCastMessage = {

            notification: {
                title: data.messageTitle,
                body: data.messageBody,

            },
            tokens: data.targetDevices
        }

        await messaging.sendMulticast(multiCastMessage);

        return true;

    } catch (ex) {
        return ex;
    }
});

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
