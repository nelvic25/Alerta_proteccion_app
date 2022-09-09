
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:login_firebase/token.dart';
import 'package:login_firebase/getMacA.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';



import 'package:login_firebase/inicio_pequeñaEscala.dart';
import 'package:login_firebase/inicio_granEscala.dart';
import 'package:login_firebase/registro.dart';
import 'package:login_firebase/auxiliar.dart';
import 'package:login_firebase/tipo_Escenario.dart';
import 'package:google_sign_in/google_sign_in.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ShowToken.initializeApp();
  //await getMac.initializeApp();
  //inicializa conexion con firebase
  runApp(MainPage());
}



class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging;
  // final _firestore = FirebaseFirestore.instance;
  // final key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    this._estaUsuarioAutenticado();

    // firebaseMessaging.configure(
    //   //called when app is in foreground
    //   onMessage: (Map<String, dynamic> message) async {
    //     print('init called onMessage');
    //     final snackBar = SnackBar(
    //       content: Text(message['notification']['body']),
    //       action: SnackBarAction(label: 'GO', onPressed: () {}),
    //     );
    //     key.currentState.showSnackBar(snackBar);
    //   },
    //   //called when app is completely closed and open from push notification
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print('init called onLaunch');
    //   },
    //   //called when app is in background  and open from push notification
    //
    //   onResume: (Map<String, dynamic> message) async {
    //     print('init called onResume');
    //   },
    // );

  }

  void _estaUsuarioAutenticado() {
  //suscribe a un flujo para verificar auth de user
    FirebaseAuth.instance.authStateChanges().listen( (User? user) {
      if (user == null)
        print ("Usuario no autenticado");
      else
        print ("Usuario autenticado");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Login());
  }
}




class tipo_Escenario extends StatefulWidget {
  @override
  tipo_EscenarioState createState() => tipo_EscenarioState();
}

class tipo_EscenarioState extends State<tipo_Escenario> {

  tipo_Escenario createState() => tipo_Escenario();

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

        child: Center(
          child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
            Padding(
            padding: const EdgeInsets.only(top: 40.0, bottom: 10.0),
            child: Text(
              'Donde se encuentra?',
              textAlign: TextAlign.center,
              style: TextStyle (
                fontSize: 40,
                color: Colors.pink[900],
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          //MENU DE ESCENARIOS

            //Esc pequeña cobertura
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  Home()
                    ));
              }, // Image tapped
              child: Image.asset(
                'assets/home.png',
                fit: BoxFit.cover, // Fixes border issues
                width: 180.0,
                height: 180.0,
              ),
            ),

          //Esc gran cobertura
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  Home2()
                    ));
              }, // Image tapped
              child: Image.asset(
                'assets/building.png',
                fit: BoxFit.cover, // Fixes border issues
                width: 180.0,
                height: 180.0,
              ),
            )


          ],
        ),
      ),
      ),

    );

  }
}




class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static bool _contrasenaVisible = false;
  static bool visible = false;
  static bool googleVisible = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contrasenaController = TextEditingController();
  //define la variable que conecta con FB auth
  FirebaseAuth auth = FirebaseAuth.instance;


  void initState() {
    super.initState();
    visible = false;
    googleVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);


    return Scaffold(


      key: _scaffoldKey,
      backgroundColor: Colors.pink[800],
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 120.0, bottom: 0.0),
                child: Text(
                  'Hera',
                  style: TextStyle (
                    fontSize: 70,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 50.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Image.asset('assets/female_logo.png')),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.mail_outline_rounded,
                        color: Colors.white70,
                      ),
                      filled: true,
                      fillColor: Colors.black12,
                      labelStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.white54,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.white, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.white, width: 1.5),
                      ),
                      labelText: 'Email',
                      hintText: 'Email'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 10.0, bottom: 30.0),
                //padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: TextFormField(
                  controller: _contrasenaController,
                  obscureText: !_contrasenaVisible,
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.white70,
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _contrasenaVisible? Icons.visibility : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _contrasenaVisible = !_contrasenaVisible;
                            });
                          }),
                      filled: true,
                      fillColor: Colors.black12,
                      labelStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.white54,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5.0)),
                        borderSide:
                        BorderSide(color: Colors.white, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5.0)),
                        borderSide:
                        BorderSide(color: Colors.white, width: 2),
                      ),
                      labelText: 'Contraseña',
                      hintText: 'Contraseña'),
                ),
              ),

              Container(
                height: 50,
                width: 350,
                child: ElevatedButton(
                  onPressed: () {
                    if (!_emailController.text.contains('@')) {
                      mostrarSnackBar('Email no correcto', context);
                    } else if (_contrasenaController.text.length < 6) {
                      mostrarSnackBar(
                          'La contraseña debe contener al menos 6 caracteres',context);
                    } else {
                      setState(() {
                        _cambiarEstadoIndicadorProgreso();
                      });
                      acceder(context);

                    }
                  },
                  child: Text(
                    'Acceder',
                    //style: TextStyle(color: Colors.white, fontSize: 20,),
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black45,
                    onPrimary: Colors.white,
                    shadowColor: Colors.black45,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: Colors.white70,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: visible,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                          width: 320,
                          margin: EdgeInsets.only(),
                          child: LinearProgressIndicator(
                            minHeight: 2,
                            backgroundColor: Colors.blueGrey[800],
                            valueColor:
                            AlwaysStoppedAnimation(Colors.white),
                          )
                      )
                  )
              ),
              Container(
                height: 30,
                width: 300,
                child: TextButton(
                  onPressed: () {
                  },
                  child: Text(
                    '¿Olvidó la contraseña?',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                height: 60,
                width: 350,
                padding: EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _cambiarEstadoIndicadorProgresoGoogle();
                    });
                    accederGoogle(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/google_logo.png'),
                          height: 30.0,
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 40, right: 55),
                          child: Text(
                            'Acceder con Google',
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              backgroundColor: Colors.transparent,
                              letterSpacing: 0.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onPrimary: Colors.white,
                    shadowColor: Colors.black45,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: Colors.white70,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: googleVisible,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                          width: 320,
                          margin: EdgeInsets.only(bottom: 20),
                          child: LinearProgressIndicator(
                            minHeight: 2,
                            backgroundColor: Colors.blueGrey[800],
                            valueColor:
                            AlwaysStoppedAnimation(Colors.white),
                          )))),
              Container(
                height: 30,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => PaginaRegistro()));

                  },

                  child: Text(
                    'Registrar',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> acceder(BuildContext context) async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        UserCredential credencial = await auth.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _contrasenaController.text.trim()
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => new tipo_Escenario()));
        setState((){
          _cambiarEstadoIndicadorProgreso();
        });
        //comprobar credenciales
      } on FirebaseAuthException catch(e) {
        if (e.code == "user-not-found")
          mostrarSnackBar("Usuario desconocido", context);
        else if (e.code == "wrong-password")
          mostrarSnackBar("Contraseña incorrecta", context);
        else
          mostrarSnackBar("Lo sentimos, hubo un error", context);
        setState((){
          _cambiarEstadoIndicadorProgreso();
        });
      }
    }
  }

  Future<void> accederGoogle(BuildContext context) async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    //definir objeto y atrapar exepciones
    try {

      final GoogleSignInAccount? _googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication _googleSignInAuthentication = await _googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          //pasamos parámetros
          accessToken: _googleSignInAuthentication.accessToken,
          idToken: _googleSignInAuthentication.idToken
      );
      await _auth.signInWithCredential(credential);
      _formKey.currentState!.save();
      //así me haya logeado con credenciales de google, ya no se escribe codigo nuevo para ir a home

      Navigator.push(context, MaterialPageRoute(builder: (context) => new tipo_Escenario()));

    } catch(e) {
      mostrarSnackBar("Lo sentimos, se produjo un error", context);
    } finally {
      setState((){
        _cambiarEstadoIndicadorProgresoGoogle();
      });

    }

  }

  void _cambiarEstadoIndicadorProgreso() {
    visible = !visible;
  }

  void _cambiarEstadoIndicadorProgresoGoogle() {
    googleVisible = !googleVisible;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }
}