import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:login_firebase/funciones_firestore_Read.dart';
import 'package:login_firebase/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_firebase/funciones_firestore_Write.dart';
import 'package:login_firebase/token.dart';
import 'package:mac_address/mac_address.dart';
import 'package:login_firebase/inicio_pequeñaEscala.dart';

//OPCIONES DE RESGISTRO DE DATOS
class tipo_Escenario2 extends StatefulWidget {
  @override
  tipo_EscenarioState createState() => tipo_EscenarioState();
}

class tipo_EscenarioState extends State<tipo_Escenario2> {

  String? _token='';
  String? _mac='';
  Future<String?> _tokenFuture = ShowToken.write_token();
  //Future<String?> MAC=ShowToken.write_MAC2();

  tipo_Escenario2 createState() => tipo_Escenario2();

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('data_devices');

    Future<void> write_MAC2() async {
      String mac2;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        mac2 = await GetMac.macAddress;
      }on PlatformException {
        mac2 = 'Error getting the MAC address.';
      }
      setState(() {
        _mac = mac2;
      });
    }


    void convertToken(Future<String?> t) async{
      this._token = await t;
    }

    // void convertMac(Future<String?> m) async{
    //   this._mac = await m;
    // }
    Future<void> addDevice() {
      convertToken(_tokenFuture);
      //print ("TOKEN ${_token} AND MAC ${MAC}");
      //convertToken(MAC);
      // Call the data_devices CollectionReference to add a new user
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


        child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [

            Container(
              child: FlatButton(
                child: Text(
                  "Añadir AGRESOR",
                  style: TextStyle(
                      fontSize: 18, color: Colors.white
                  ),
                ),
                onPressed:() {
                //  addDevice();
                 // write_MAC2();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddUser()
                      ));
                  //cuando elija este escenario se almacena en data_devices
                  //nombre de doc: mac del device y atributo token del device
                  //AddUser.addDevice();

                },
                padding:EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                color: Colors.cyan[800],
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
                  "Eliminar un AGRESOR",
                  style: TextStyle(
                      fontSize: 18, color: Colors.white
                  ),
                ),
                onPressed:() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>  DeleteUser()
                      ));
                },
                padding:EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                color: Colors.cyan[800],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),
            //VOLVER AL MENU
            // Container(
            //   padding: EdgeInsets.all(25),
            //   alignment:Alignment.center,
            //   child:
            //   RaisedButton(
            //       padding: EdgeInsets.symmetric(vertical:30, horizontal: 50),
            //       color: Colors.black26,
            //       child: Text(
            //         "Volver",
            //         style: TextStyle(
            //             fontSize: 18,color: Colors.white,
            //             fontFamily: "rbold"
            //         ),
            //       ),
            //       onPressed:() {
            //
            //         Navigator.push(context,
            //             MaterialPageRoute(
            //                 builder: (BuildContext context) => Home()));
            //       }
            //
            //   ),
            //
            // ),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 30),
                FloatingActionButton.large(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Home()));
                  },
                  child:
                  const Icon(Icons.account_balance_sharp),
                  backgroundColor: Colors.pink[900],
                ),
              ],
            ),



          ],
        ),
      ),
      ),

    );

  }



}