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
        backgroundColor: Colors.indigo[400],
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
            //mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget> [
              Padding(
                padding: const EdgeInsets.only(top: 120.0, bottom: 0.0),
                child: Text(
                  'GRAN-ESCALA',
                  style: TextStyle (
                    fontSize: 40,
                    color: Colors.indigo[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.all(20),
                //  child:GestureDetector(
                child: FlatButton(
                  child: Text(
                    "BOTON DE PÁNICO",
                    style: TextStyle(
                        fontSize: 18, color: Colors.white
                    ),
                  ),
                  onPressed:() {
                    print("Alerta enviada");

                  },
                  padding:EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              Container(
                child: FlatButton(
                  child: Text(
                    "VER EN EL MAPA",
                    style: TextStyle(
                        fontSize: 18, color: Colors.white
                    ),
                  ),
                  onPressed:() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddUser()
                        ));
                    // print("AGREGAR AGRESOR");
                  },
                  padding:EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  color: Colors.indigo[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
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