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


  tipo_Escenario2 createState() => tipo_Escenario2();

  @override
  Widget build(BuildContext context) {


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

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddUser()
                      ));


                },
                padding:EdgeInsets.symmetric(vertical: 40, horizontal: 50),
                color:  Colors.purple[200],
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
                padding:EdgeInsets.symmetric(vertical: 40, horizontal: 50),
                color:  Colors.purple[200],
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