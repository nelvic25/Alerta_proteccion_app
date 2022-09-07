import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(SOS());
class SOS extends StatelessWidget{
  const SOS({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: SOSScreen(),
    );
  }
  SOSScreen createState() => SOSScreen();
}

class SOSScreen extends StatelessWidget{
  String number="911";
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("Abre el cuadro de diálogo"),
          onPressed: (){
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: Text(" LLAMANDO A EMERGENCIAS (911)"),
                  content: Text("Está seguro?"),
                  actions:<Widget> [
                    FlatButton(
                        child: Text("SÍ"),
                        onPressed:() async {
                          FlutterPhoneDirectCaller.callNumber(number);
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
        ),
      ),
    );
  }
}
