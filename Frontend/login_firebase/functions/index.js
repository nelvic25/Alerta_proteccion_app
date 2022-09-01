// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require("firebase-functions");
const admin= require ("firebase-admin");
var serviceAccount = require("./Key.json");

//admin.initializeApp(functions.config().firebase);
admin.initializeApp(functions.config().firebase);

var msgData;
//const tok= "dVsgRto8Semq6xsqPwYvyi:APA91bEetaI2MMEjYxTo6xp93_MGj7Z4l_iFAMxdoQ7z351UZy7JKPuNxZ641vFqxlgJknrMjlys5EnYCt2x5A_0A7WSLH1Q4tiTD-1Dv_2HUK0ZeX8wpUZKN2H1zcU-s0gyfsYrGjuT";


exports.offerTrigger = functions.firestore.document('data_devices/{Id}'
).onCreate(async (snapshot,context) => {
     if(snapshot.empty) {
            return;
        }

    msgData = snapshot.data();
    console.log(newData);

    var payload = {
        notification: {
          title: "This is a Notification",
          body: "This is the body of the notification message.",
        },

        data : {
                     //click_action: 'FLUTTER_NOTIFICATION_CLICK',
                    //  message: `${newData.username} y  ${newData.history} has been broken distancing. Date: ${newData.historydate}.`
                     message: "Broken Social Distancing!"
                 },
      };

      var options = {
        priority: "high",
      };

      var registrationToken ="cxb94o8ERCOzpMtL6B2rB1:APA91bFylPwmVGHBovI_qtucZdukruFAPJaJ6VusILQ3HEH1uc3MdAbGU6EaLe0Qp30iETespJ5hkBQO_-O-Uet798VuNrHCuqYW4EYZhQgaEEsOww7wvPmh6mZ_8AvW-TLkI7V2r5oe";

       return
       admin
         .messaging()
         .sendToDevice(registrationToken, payload, options)
        .then(function (response) {
           console.log("Mensajes enviados! :", response);
         })
         .catch(function (error) {
          console.log("Error sending message:", error);
         });
});