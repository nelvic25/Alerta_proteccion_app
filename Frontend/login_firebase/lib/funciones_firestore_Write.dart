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
            .update({
              'attackers': FieldValue.arrayUnion([attacker1]) ,
              'token': _token,

        }
      );
          // .then((DocumentReference doc) => print('DocumentSnapshot added with ID: ${doc.id}'))
          // .catchError((error) => print("Failed to add user: $error"));

    }

// db.collection("mac_attackers").doc("router_name")
// .set({attackers:[XXXXXX]},SetOptions(merge:true));


    //users
    //           .doc(router_name)
    //             .set({
    //               'attackers': Lmacs,
    //               'token': _token,

    //db.collection("mac_attackers").doc("router_name").update({"attackers":[XXXXXX]});

    Future<void> deleteUser() {
      convertToken(_tokenFuture);
      Lmacs.add(attacker1);
      Lmacs.add(attacker2);
      // Call the mac_attackers CollectionReference to add a new user
      return
        users
            .doc(router_name)
            .update({
          'attackers': FieldValue.arrayUnion([attacker1]) ,
          'token': _token,

        }
        );
      // .then((DocumentReference doc) => print('DocumentSnapshot added with ID: ${doc.id}'))
      // .catchError((error) => print("Failed to add user: $error"));

    }

    return Scaffold(

      backgroundColor: Colors.white,
      appBar:AppBar(
        title: Text("REGISTRE LOS DATOS"),
        backgroundColor: Colors.cyan[800],
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

            // Container(
            //   padding: EdgeInsets.all(15),
            //   child: TextField(
            //     controller: macAttacker2,
            //     decoration: InputDecoration(
            //         hintText: "Inserte MAC de Agresor 2"
            //     ),
            //   ),
            // ),

            Container(
              padding: EdgeInsets.all(25),
              alignment:Alignment.center,
              child:
              RaisedButton(
                  padding: EdgeInsets.symmetric(vertical:10, horizontal: 30),
                  color: Colors.cyan[800],
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
                    //attacker2=macAttacker2.text;
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
                      fontSize: 50,
                      color: Colors.cyan[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

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

    );

  }
}
//DELETE

class DeleteUser extends StatelessWidget {


  final router=TextEditingController();
  final macAttacker1=TextEditingController();

  String router_name= '';
  String attacker= '';
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


    Future<void> deleteUser() {
      convertToken(_tokenFuture);

      // Call the mac_attackers CollectionReference to DELETE a ATTACKER user
      return
        users
            .doc(router_name)
            .update({
          'attackers': FieldValue.arrayRemove([attacker]) ,
          'token': _token,

        }
        );

    }

    return Scaffold(

      backgroundColor: Colors.white,
      appBar:AppBar(
        title: Text("Registre la MAC a Eliminar"),
        backgroundColor: Colors.cyan[800],
      ),

//para poner imagen de fondo, cambiar listview a container y crear un child : Column( antes del
      /////children
      //agregar funcion que permita ir ingresando mac de atackers segun lo vaya
      //pidiendo el usuario
      body:ListView(

        children: [
         // mainAxisAlignment: MainAxisAlignment.center,

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
                  hintText: "Inserte MAC de Agresor a Eliminar"
              ),
            ),
          ),

          // Container(
          //   padding: EdgeInsets.all(15),
          //   child: TextField(
          //     controller: macAttacker2,
          //     decoration: InputDecoration(
          //         hintText: "Inserte MAC de Agresor 2"
          //     ),
          //   ),
          // ),

          Container(
            padding: EdgeInsets.all(25),
            alignment:Alignment.center,
            child:
            RaisedButton(
                padding: EdgeInsets.symmetric(vertical:10, horizontal: 30),
                color: Colors.cyan[800],
                child: Text(
                  "Confirmar datos",
                  style: TextStyle(
                      fontSize: 18,color: Colors.white,
                      fontFamily: "rbold"
                  ),
                ),
                onPressed:(){
                  router_name=router.text;
                  attacker=macAttacker1.text;
                  //attacker2=macAttacker2.text;
                  DeleteUser();
                  print("Usuario Eliminado: Mac_Router: ${router}, MacAttacker1: ${attacker}" );
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => AttackerDelete()));

                }
            ),
          ),

        ],
      ),
    );

  }
}



class AttackerDelete extends StatelessWidget {
  //AddUser a=AddUser();


  AttackerDelete createState() => AttackerDelete();

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
                'MAC Eliminada',
                style: TextStyle (
                  fontSize: 40,
                  color: Colors.cyan[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

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

    );

  }
}


