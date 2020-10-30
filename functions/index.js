const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// This Firebase Cloud Functions for push notifications for messages,
// requires Credit card as it uses NodeJS 10.
// And to use Firebase Cloud Functions for NodeJS 10, Firebase requires
// Credit card details.

exports.myFunction = functions.firestore
    .document('chat/{message}')
    .onWrite((snapshot, context) => {
        console.log(snapshot.data());
        return admin.messaging().sendToTopic("chat", {
            notification: {
                title: snapshot.data().username,
                body: snapshot.data().text,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK',
            },
        });
        // .sendToTopic(topic) - topic should be same as the one given in the 'chatScreen.dart'
    });