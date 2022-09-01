import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_mac/get_mac.dart';
import 'package:flutter/services.dart';


// class getToken{
//     static FirebaseMessaging messaging = FirebaseMessaging.instance;
//     static String? token;
//
//     Future<String?> initializeApp() async{
//
//         Firebase.initializeApp();
//         token = await FirebaseMessaging.instance.getToken();
//         print("este es el token: ${token}");
//         return
//             token;
// }
// }

class ShowToken{
    static FirebaseMessaging messaging = FirebaseMessaging.instance;
    static String? token;
    CollectionReference users = FirebaseFirestore.instance.collection('mac_attackers');

    static Future initializeApp() async{

        await Firebase.initializeApp();
        token = await FirebaseMessaging.instance.getToken();
        print("este es el token: ${token}");

    }

    static Future<String?> write_token() async{

        Firebase.initializeApp();
        token = await FirebaseMessaging.instance.getToken();
        print("Token para almacenar: ${token}");
        return
            token;
    }

    static Future<String?> convertToken(Future<String?> t) async{
        String? _token = "";
       _token= await t;
       return _token;
    }

    static Future<String?> getMAC() async{

        String mac;
        // Platform messages may fail, so we use a try/catch PlatformException.
        try {
            mac = await GetMac.macAddress;
            print("Esta es la mac: ${mac} 30-65-EC-6F-C4-58");
        } on PlatformException {
            mac = 'Failed to get Device MAC Address.';
        }
        return mac;
    }


}


