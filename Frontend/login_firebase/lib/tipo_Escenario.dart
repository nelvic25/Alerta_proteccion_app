import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:login_firebase/funciones_firestore_Read.dart';
import 'package:login_firebase/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_firebase/funciones_firestore_Write.dart';
import 'package:login_firebase/token.dart';


class tipo_Escenario extends StatefulWidget {
  @override
  tipo_EscenarioState createState() => tipo_EscenarioState();
}

class tipo_EscenarioState extends State<tipo_Escenario> {

  String? _token='';
  String? _mac='';
  Future<String?> _tokenFuture = ShowToken.write_token();
  Future<String?> MAC=ShowToken.getMAC();

  //late final FirebaseMessaging _messaging;

  tipo_Escenario createState() => tipo_Escenario();


  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('data_devices');

    void convertToken(Future<String?> t) async{
      this._token = await t;
    }

    void convertMac(Future<String?> m) async{
      this._mac = await m;
    }

    Future<void> addDevice() {
      convertToken(_tokenFuture);
      convertToken(MAC);
      print ("${_token} AND ${_mac}");

      // Call the mac_attackers CollectionReference to add a new user
      return
        users
            .doc(_mac)
            .set({
          'token': _token,
        });
    }



    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background1.jpg"),
            fit: BoxFit.fill,
          ),
        ),


        child: ListView(
          children: [


            Container(
              child: FlatButton(
                child: Text(
                  "Escenario: PEQUEÑA ESCALA",
                  style: TextStyle(
                      fontSize: 18, color: Colors.white
                  ),
                ),
                onPressed:() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainPage()
                      ));
                    addDevice();
                  //cuando elija este escenario se almacena en data_devices
                  //nombre de doc: mac del device y atributo token del device
                  //AddUser.addDevice();

                },
                padding:EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                color: Colors.pink[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),


            Container(
              padding: EdgeInsets.all(20),
              //  child:GestureDetector(
              child: FlatButton(
                child: Text(
                  "Escenario: GRAN ESCALA",
                  style: TextStyle(
                      fontSize: 18, color: Colors.white
                  ),
                ),
                onPressed:() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>  MainPage()
                      ));
                },
                padding:EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                color: Colors.pink[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),


          ],
        ),
      ),

    );

  }



}