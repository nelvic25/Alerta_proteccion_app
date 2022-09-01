import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_firebase/inicio_pequeñaEscala.dart';
import 'package:login_firebase/token.dart';

class AddUser extends StatelessWidget {


  final router=TextEditingController();
  final macAttacker1=TextEditingController();
  final macAttacker2=TextEditingController();

  String router_name= '';
  String attacker1= '';
  String attacker2= '';
  List<String?> Lmacs= [];
  String? _token='';
  Future<String?> _tokenFuture = ShowToken.write_token();



  //AddUser(this.user, this.macUser
  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('mac_attackers');

    //users.get().then(res => console.log(res.size));
    void convertToken(Future<String?> t) async{
      this._token = await t;
    }
    convertToken(_tokenFuture);

    Future<void> addUser() {
      convertToken(_tokenFuture);
      Lmacs.add(attacker1);
      Lmacs.add(attacker2);
      // Call the mac_attackers CollectionReference to add a new user
      return
        users
          .doc(router_name)
            .set({
              'attackers': Lmacs,
              'token': _token,
        });
          // .then((DocumentReference doc) => print('DocumentSnapshot added with ID: ${doc.id}'))
          // .catchError((error) => print("Failed to add user: $error"));

    }



    return Scaffold(

      backgroundColor: Colors.white,
      appBar:AppBar(
        title: Text("REGISTRE LOS DATOS"),
        backgroundColor: Colors.pink[900],
      ),

//para poner imagen de fondo, cambiar listview a container y crear un child : Column( antes del
      /////children
      //agregar funcion que permita ir ingresando mac de atackers segun lo vaya
      //pidiendo el usuario
      body:ListView(

          children: [

      Container(
      padding: EdgeInsets.all(15),
      child: TextField(
        controller: router,
        decoration: InputDecoration(
            hintText: "Ingrese la MAC de su router"
        ),
      ),
    ),

        Container(
          padding: EdgeInsets.all(15),
          child: TextField(
          controller: macAttacker1,
          decoration: InputDecoration(
          hintText: "Inserte MAC de Agresor 1"
        ),
        ),
        ),

            Container(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: macAttacker2,
                decoration: InputDecoration(
                    hintText: "Inserte MAC de Agresor 2"
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.all(25),
              alignment:Alignment.center,
              child:
              RaisedButton(
                  padding: EdgeInsets.symmetric(vertical:10, horizontal: 30),
                  color: Colors.pink[900],
                  child: Text(
                    "Confirmar datos",
                    style: TextStyle(
                        fontSize: 18,color: Colors.white,
                        fontFamily: "rbold"
                    ),
                  ),
                  onPressed:(){
                    router_name=router.text;
                    attacker1=macAttacker1.text;
                    attacker2=macAttacker2.text;
                    addUser();
                    print("Usuario Registrado: Mac_Router: ${router}, MacAttacker1: ${attacker1}, MacAttacker2: ${attacker2}" );
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => newAttacker()));

                  }
              ),
            ),

  ],
    ),
    );

  }
}

class newAttacker extends StatelessWidget {
  AddUser a=AddUser();


  newAttacker createState() => newAttacker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Container(
          decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/background1.jpg"),
          fit: BoxFit.cover,
          ),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 120.0, bottom: 0.0),
                  child: Text(
                    'Usuario Registrado',
                    style: TextStyle (
                      fontSize: 40,
                      color: Colors.indigo[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(25),
                  alignment:Alignment.center,
                  child:
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical:10, horizontal: 30),
                    color: Colors.pink[900],
                    child: Text(
                      "Volver",
                      style: TextStyle(
                          fontSize: 18,color: Colors.white,
                          fontFamily: "rbold"
                      ),
                    ),
                    onPressed:() {

                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Home()));
                    }

                  ),

                ),


              ],
    ),
        ),

    );

  }
}


