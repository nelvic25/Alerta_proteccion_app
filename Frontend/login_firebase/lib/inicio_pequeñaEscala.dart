import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:login_firebase/funciones_firestore_Read.dart';
import 'package:login_firebase/getMacA.dart';
import 'package:login_firebase/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_firebase/funciones_firestore_Write.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:login_firebase/token.dart';
//import 'package:get_mac/get_mac.dart';
import 'package:macadress_gen/macadress_gen.dart';
import 'dart:async';
import 'package:login_firebase/tipo_Escenario.dart';





class Home extends StatelessWidget  {
  Login log =Login();
  // MacadressGen macadressGen = MacadressGen();
  // var mac;
  static const Channel = MethodChannel('com.example.getmac');
  //late final FirebaseMessaging _messaging;
  Home createState() => Home();

  String _platformID = 'Unknown';


  @override

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    //traer user
    final User? usuario = FirebaseAuth.instance.currentUser;
    String? email = "";

    if (usuario!=null)
      email = usuario.email;

    return Scaffold(

      appBar: AppBar(
        leading: new Container(),
        title: TextButton.icon(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => tipo_Escenario()
                ));
          },
          label: Text('Salir',
              style: TextStyle(fontSize: 25, color: Colors.white)),
          icon: Icon(
            Icons.logout,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.cyan[800],
      ),




      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background1.jpg"),
              fit: BoxFit.fill,
            ),
          ),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:<Widget> [
          Padding(
            padding: const EdgeInsets.only(top: 50.0, bottom: 0.0),
            child: Text(
              'Indoor',
              style: TextStyle (
                fontSize: 30,
                color: Colors.pink[00],
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const Text('Necesitas Ayuda? ->',
                style: TextStyle (
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),

              ),
              const SizedBox(width: 40),
              // An example of the extended floating action button.
              //
              // https://m3.material.io/components/extended-fab/specs#686cb8af-87c9-48e8-a3e1-db9da6f6c69b
              FloatingActionButton.large(
                onPressed: () {
                  //FUNCIÓN QUE LLAMA DIRECTAMENTE A LA POLICIA(911)
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: Text(" LLAMANDO A EMERGENCIAS (911)"),
                      content: Text("Está seguro?"),
                      actions:<Widget> [
                        FlatButton(
                          child: Text("SÍ"),
                          onPressed:() async {
                            FlutterPhoneDirectCaller.callNumber("911");
                          },
                        ),
                        FlatButton(
                          child: Text("CANCELAR"),
                          onPressed:() {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
                child:
                 //const Text('Bontón de Panico'),
                const Icon(Icons.add_alert),
                backgroundColor: Colors.red,
              ),
            ],
          ),




          Container(
            padding: EdgeInsets.all(30),
            child: FlatButton(
              child: Text(
                "CREAR REGISTRO",
                style: TextStyle(
                    fontSize: 20, color: Colors.white
                ),
              ),
              onPressed:() {
                Navigator.push(context,
                   MaterialPageRoute(builder: (context) => tipo_Escenario2()
                    ));
                ShowToken.write_token();
               // getmac();
               //mac();
              },
              padding:EdgeInsets.symmetric(vertical: 40, horizontal: 60),
              color: Colors.cyan[800],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
              ),
            ),
          ),

          //permite ver los usuarios que esten en la coleccion data_devices y macttakers
          Container(
            padding: EdgeInsets.all(30),
            //  child:GestureDetector(
            child: FlatButton(
              child: Text(
                "REGISTROS",
                style: TextStyle(
                    fontSize: 18, color: Colors.white
                ),
              ),
              onPressed:() {

                Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  getData()
                ));
              },
              padding:EdgeInsets.symmetric(vertical: 40, horizontal: 60),
              color: Colors.cyan[800],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
              ),
            ),
          ),



        ],


          ),

      ),
      ),

    );

  }

//me lleva a la pantalla anterior
  void _salir(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }
  // Future getMAC() async {
  //   mac = await macadressGen.getMac();
  //   print("Esta es la mac: ${mac}");
  // }

  // Future<void> getmac() async {
  //   String mac = await Channel.invokeMethod('getMAC');
  //   print("Esta es la mac: ${mac}");
  // }



//   void registerNotification() async {
//     // 1. Initialize the Firebase app
//     await Firebase.initializeApp();
//
//     // 2. Instantiate Firebase Messaging
//     _messaging = FirebaseMessaging.instance;
//
//     // 3. On iOS, this helps to take the user permissions
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       provisional: false,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//
//       // For handling the received notifications
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         // Parse the message received
//         PushNotification notification = PushNotification(
//           title: message.notification?.title,
//           body: message.notification?.body,
//         );
//
//         setState(() {
//           _notificationInfo = notification;
//           _totalNotifications++;
//         });
//       });
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }
//
}



