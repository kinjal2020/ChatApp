import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasedemo/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'chatapp',
      options: FirebaseOptions(
          apiKey: 'AIzaSyB3Y-IuGZX_JWBIvs06HWLY1Q7EM_cOEKg',
          appId: '1:206311270927:android:40a786b8146733166f917a',
          messagingSenderId: '206311270927',
          projectId: 'chatapp-ebfa7'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool isLogin = false;
  bool isGoogleLogin = false;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signIn() async {
    try {
      setState(() {
        isLogin = true;
      });
      var auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: nameController.text, password: passwordController.text);
      print(auth.user!);

      // await FirebaseFirestore.instance.collection('User').doc().set({
      //   'email': nameController.text,
      //   'password': passwordController.text,
      //   'uid': auth.user!.uid,
      // });

      Fluttertoast.showToast(msg: 'Registration sucessfully.');
      setState(() {
        isLogin = false;
      });

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomeScreen(
                email: nameController.text,
                type: 'emailPassword',
                image: 'https://avatars.githubusercontent.com/u/1566403?v=4',
              )));
    } on Exception catch (e) {
      if (e.toString().contains('firebase_auth/invalid-credential')) {
        Fluttertoast.showToast(
          msg: 'Invalid credential.Please try again.',
        );
        setState(() {
          isLogin = false;
        });
      }
      print(e);
      // TODO
    }
  }

  signInWithGoogle() async {
    try {
      setState(() {
        isGoogleLogin = true;
      });
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print(googleUser?.email);

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        isGoogleLogin = false;
      });

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomeScreen(
                email: googleUser!.email,
                type: 'googleLogin',
                image: googleUser.photoUrl!,
              )));
      final GoogleSignInAccount? user = await GoogleSignIn().signOut();
    } catch (e) {
      setState(() {
        isGoogleLogin = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter email';
                    }
                  },
                  controller: nameController,
                  decoration: InputDecoration(hintText: 'Email'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter password';
                    }
                  },
                  controller: passwordController,
                  decoration: InputDecoration(hintText: 'Password'),
                ),
                SizedBox(
                  height: 20,
                ),
                (isLogin == true)
                    ? OutlinedButton(
                        onPressed: null, child: CircularProgressIndicator())
                    : OutlinedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            signIn();
                          }
                        },
                        child: Text('SignIn')),
                (isGoogleLogin == true)
                    ? OutlinedButton(
                        onPressed: null, child: CircularProgressIndicator())
                    : OutlinedButton(
                        onPressed: () async {
                          signInWithGoogle();
                        },
                        child: Text('Google Login'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
