import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_firebase/funciones_firestore_Write.dart';
import 'package:login_firebase/token.dart';
import 'package:mac_address/mac_address.dart';
import 'package:login_firebase/inicio_pequeñaEscala.dart';

//OPCIONES DE RESGISTRO DE DATOS
class contacto_emergencia extends StatefulWidget {
  @override
  contacto_emergenciaState createState() => contacto_emergenciaState();
}

class contacto_emergenciaState extends State<contacto_emergencia> {

  String? _token='';
  String? _mac='';
  Future<String?> _tokenFuture = ShowToken.write_token();


  contacto_emergencia createState() => contacto_emergencia();

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
                    "Añadir Contacto de Emergencia",
                    style: TextStyle(
                        fontSize: 18, color: Colors.white
                    ),
                  ),
                  onPressed:() {
                    //  addDevice();
                    // write_MAC2();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddContact()
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