import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:login_firebase/funciones_firestore_Read.dart';
import 'package:login_firebase/main.dart';
import 'package:login_firebase/funciones_firestore_Write.dart';




class Home2 extends StatelessWidget {
  Login log =Login();
  //late final FirebaseMessaging _messaging;
  Home2 createState() => Home2();


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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:<Widget> [
              Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 0.0),
                child: Text(
                  'Outdoor',
                  style: TextStyle (
                    fontSize: 30,
                    color: Colors.pink[900],
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    },
                    child:
                    //const Text('Bontón de Panico'),
                    const Icon(Icons.add_alert),
                    backgroundColor: Colors.red,
                  ),
                ],
              ),




              Container(
                child: FlatButton(
                  child: Text(
                    "VER EN EL MAPA",
                    style: TextStyle(
                        fontSize: 20, color: Colors.white
                    ),
                  ),
                  onPressed:() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddUser()
                        ));
                    // print("AGREGAR AGRESOR");
                  },
                  padding:EdgeInsets.symmetric(vertical: 20, horizontal: 40),
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

}