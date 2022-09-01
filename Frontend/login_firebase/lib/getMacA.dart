import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
//import 'package:mac_address/mac_address.dart';
import 'package:get_mac/get_mac.dart';
import 'package:macadress_gen/macadress_gen.dart';

// class getMac extends StatefulWidget {
//   @override
//   getMacState createState() => getMacState();
// }

class getMac {
  MacadressGen macadressGen = MacadressGen();
  String? mac;
  //1
  // String _deviceMAC= "OK";
  //  static Future<void> initializeApp() async {
  //   String platformVersion;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     platformVersion = await GetMac.macAddress;
  //     print("Esta es la mac del dispositivo: ${platformVersion}");
  //   } on PlatformException {
  //     platformVersion = 'Failed to get Device MAC Address.';
  //   }
  //2
    // setState((){
    //   _deviceMAC= platformVersion;
    // });
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  //}
  Future getMACADDRESS() async {
  mac = await macadressGen.getMac();
  print(mac);
}
}