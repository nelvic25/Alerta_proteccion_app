import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_firebase/inicio_pequeñaEscala.dart';
import 'package:intl/intl.dart';
import 'package:login_firebase/token.dart';
import 'dart:async';

void main() => runApp(getData());


class getData extends StatelessWidget {

  final String documentId='29-65-EC-6D-C4-56';
  String docID= '';
  String nearApName= '';
  String userName= '';
  String SSID= '';
  String mac= '';



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
                  'Historial de Registros',
                  textAlign: TextAlign.center,
                  style: TextStyle (
                    fontSize: 40,
                    color: Colors.pink[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

             // ver los usuarios de la coleccion mac_attackers
              Container(
                padding: EdgeInsets.all(25),
                alignment:Alignment.center,
                child:
                RaisedButton(
                    padding: EdgeInsets.symmetric(vertical:30, horizontal: 50),
                    color: Colors.cyan[800],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                    child: Text(
                      "Usuarios Registrados como Agresores",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,color: Colors.white,
                          fontFamily: "rbold"
                      ),
                    ),
                    onPressed:() {

                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => getNameAttacker()));
                    }
                ),
              ),
              // ver los usuarios de la coleccion mac_attackers
              Container(
                padding: EdgeInsets.all(25),
                alignment:Alignment.center,
                child:
                RaisedButton(
                    padding: EdgeInsets.symmetric(vertical:30, horizontal: 50),
                    color: Colors.cyan[800],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                    child: Text(
                      "Registro de Alertas",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,color: Colors.white,
                          fontFamily: "rbold"
                      ),
                    ),
                    onPressed:() {
                      //print("Esta es la lista final ${names}");
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => getName()));

                    },

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

            ]
        ),
      ),
    );

    // return TextButton(
    //   onPressed: (){
    //     getId();
    //     print(ids);
    //   },
    //   child: Text(
    //     "Lista de usuarios cercanos: ${ids}",
    //   ),
    // );
    // print(ids);



  }
}



//OBTIENE DATOS DE COLECCIÓN ALERTAS
class getName extends StatelessWidget {
   //final getData n = getData();
   // getName({this.names});
  String? _token=ShowToken.write_token2();
 // Future<String?> _tokenFuture = ShowToken.write_token();

  @override
  Widget build(BuildContext context) {

      CollectionReference users = FirebaseFirestore.instance.collection('alerts');


      //llena la list ids con los ids que encuentre en firestore

        // users.get().then((event) {
        //   for (var doc in event.docs) {
        //     String i=doc.id;
        //     ids.add(i);
        //     print("${doc.id} added");
        //     users.doc(i).get().then((DocumentSnapshot c) {
        //       final data = c.data() as Map<String, dynamic>;
        //      // map=data;
        //       var userName = data['user'];
        //       print(data['user']);
        //       names.add(i);
        //       names.add(userName);
        //       names.add("Rebeca");             //print("names de getName1${names}");
        //       //print(map);
        //     });
        //
        //   }
        //   // for (Strin
        //   //g i in ids) {
        //   //
        //   // }
        //   print("names añadidos${names}");
        //
        //   print("ids añadidos${ids}");
        //
        //   //recorrer la lista ids y usar la funcion para obtener el nombre del id
        //
        //   //print("lista que deberia retornar${names}");
        // });

      // return MaterialApp(
      //   title: title,
      //   home: Scaffold(
      //     appBar: AppBar(
      //       title: Text(title),
      //     ),
      //     body: ListView.builder(
      //       itemCount: names.length,
      //       itemBuilder: (context, index) {
      //         return ListTile(
      //           title: Text('${names[index]}'),
      //         );
      //       },
      //     ),
      //   ),
      // );


      final title = 'Registro de Alertas';


      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan[800],

          title: Text("Historial de Alertas"),

        ),

        body: StreamBuilder(

          stream: FirebaseFirestore.instance.collection('alerts').where("token", isEqualTo: _token).snapshots(),

          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: EdgeInsets.all(20),

              child: ListView(
              children: snapshot.data!.docs.map((document) {
                return Container(
                  child: Center(child: _buildItem(document['fecha'], "Mac Agresor:${document['mac_agresor']}" ,
                    // style: TextStyle(
                    //     fontSize: 24,color: Colors.black,
                    //     fontFamily: "rbold"
                    // ),
                  )
                  )
                  );
              }).toList(),
            )
            );
          },
        ),
      );

//https://guillermogarcia.es/listas-en-flutter-con-listview/
  }
}

Widget _buildItem(Timestamp dateT, String subT) {
 // var date = new DateTime.fromMillisecondsSinceEpoch(dateT);
  DateTime date = DateTime.fromMicrosecondsSinceEpoch(dateT.microsecondsSinceEpoch);
  String textTitle = DateFormat.yMd().format(date);
  return new ListTile(
    title: new Text("FECHA: ${textTitle}"),
    subtitle: new Text(subT),
    leading: new Icon(Icons.add_alert),
    onTap: (){
      //Se puede poner la opcion que lo muestre en el mapa
      print(textTitle);
    },
  );
}

//solo muestra los dos +ultimos registros
Widget _buildItemArray(String textTitle, String subT) {
  //print(textTitle);
  String newtexTitle=textTitle.replaceAll("[","").replaceAll("]","");
  List<String> Lmacs=newtexTitle.split(",");
  int n= Lmacs.length;
  print(Lmacs);

  String newsubT=subT.replaceAll("[","").replaceAll("]","");
  List<String> Lnames=newsubT.split(",");
  int n2= Lnames.length;
  print(Lnames);

  return new ListTile(
    title: new Text("Agresor(es) Registrado(s):\n \n -Nombre: ${Lnames[n-2]}\n Mac: ${Lmacs[n-2]} \n  \n -Nombre: ${ Lnames[n-1]}\n Mac: ${Lmacs[n-1]}\n"),
    //subtitle: new Text("MAC de Agresor(es) Registrado(s):\n \n - ${Lmacs[n-2]}\n \n - ${ Lmacs[n-1]}\n"),
   //  style: TextStyle(
   //    fontSize: 12,color: Colors.black
   // ),
//  ),
    leading: new Icon(Icons.accessibility),
    onTap: (){
      //Se puede poner la opcion que lo muestre en el mapa
      print(textTitle);
    },
  );
}


//OBTIENE DATOS DE LA COLECCIÓN MAC_ATTACKERS
class getNameAttacker extends StatelessWidget {
  List<String> ids =[];
  List<String> names =[];
  String _token=ShowToken.write_token2();
  //String _mac=ShowToken.write_MAC2();

  @override
  Widget build(BuildContext context) {
    Fuente: https://www.iteramos.com/pregunta/88344/flutter-ejecutar-el-metodo-en-la-construccion-del-widget-completa

    //ids.add(convertToken(this._tokenFuture,this._token).toString());

    print("final token ${_token}");
    //print("final mac ${_mac}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[800],
        title: Text("MACS de Atacantes"),
      ),

      body: StreamBuilder(

        stream: FirebaseFirestore.instance.collection('mac_attackers').where("token", isEqualTo:_token).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background1.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.all(20),

              child: ListView(
                children: snapshot.data!.docs.map((document) {
                  return Container(
                      child: Center(child: _buildItemArray("${document['attackers']}", " ${document['names_attackers']}"
                        // style: TextStyle(
                        //     fontSize: 24,color: Colors.black,
                        //     fontFamily: "rbold"
                        // ),
                      )
                      )
                  );
                }).toList(),
              )
          );
          //https://es.acervolima.com/flutter-leer-y-escribir-datos-en-firebase/
        },
      ),
    );
  }
}