import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:login_firebase/funciones_firestore_Read.dart';
import 'package:login_firebase/main.dart';
import 'package:login_firebase/funciones_firestore_Write.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';




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
        backgroundColor:  Colors.purple[200],
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

                    //FUNCIÓN QUE LLAMA DIRECTAMENTE A LA POLICIA(911)
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text(" LLAMAR A EMERGENCIAS Y ENVIAR ALERTAS A USUARIOS CERCANOS!"),
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
                  padding:EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  color:  Colors.purple[200],
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

//
// child: Image.asset(
// 'assets/building.png',
// fit: BoxFit.cover, // Fixes border issues
// width: 180.0,
// height: 180.0,
// ),