import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_firebase/inicio_pequeñaEscala.dart';
import 'package:intl/intl.dart';




class getData extends StatelessWidget {

  final String documentId='29-65-EC-6D-C4-56';
  String docID= '';
  String nearApName= '';
  String userName= '';
  String SSID= '';
  String mac= '';



  //getData({required this.names, required this.ids});

  //getData(this.ids, this.names);


  // getData(this.nearApName,this.userName,this.SSID,this.mac);

  @override
  Widget build(BuildContext context) {
    //final List<String> ids =[];
    //final List<String> names =[];

   // CollectionReference users = FirebaseFirestore.instance.collection('data_devices');
    //llena la list ids con los ids que encuentre en firestore

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
                  'HISTORIAL DE REGISTROS',
                  textAlign: TextAlign.center,
                  style: TextStyle (
                    fontSize: 40,
                    color: Colors.indigo[600],
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
                    padding: EdgeInsets.symmetric(vertical:10, horizontal: 30),
                    color: Colors.pink[900],
                    child: Text(
                      "USUARIOS REGISTRADOS COMO AGRESORES",
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
                    padding: EdgeInsets.symmetric(vertical:10, horizontal: 30),
                    color: Colors.pink[900],
                    child: Text(
                      "REGISTRO DE ALERTAS",
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

                    }
                ),
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



  //getName({Key key, @required this.names}) : super(key: key);
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


      final title = 'Usuarios Cercanos';


      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[900],
          title: Text("Historial de Alertas"),
        ),

        body: StreamBuilder(

          stream: FirebaseFirestore.instance.collection('alerts').snapshots(),
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

  return new ListTile(
    title: new Text("MAC Address de Agresor(es) registrado(s):\n ${Lmacs[n-2]}\n ${ Lmacs[n-1]}\n"),
    subtitle: new Text(subT,
   //  style: TextStyle(
   //    fontSize: 12,color: Colors.black
   // ),
  ),
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
  Map<String,dynamic> map = {"ApName": "","SSID":"","mac":"","nearApName":"","user":""};


  //CollectionReference macsA = FirebaseFirestore.instance.collection('alerts');

  //llena la list ids con los ids que encuentre en firestore

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[900],
        title: Text("MACS Registradas como atacantes"),
      ),

      body: StreamBuilder(

        stream: FirebaseFirestore.instance.collection('mac_attackers').snapshots(),
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
                      child: Center(child: _buildItemArray("${document['attackers']}", "Token de Usuario: \n ${document['token']}",
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