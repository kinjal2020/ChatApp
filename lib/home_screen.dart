import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasedemo/chat_screen.dart';
import 'package:firebasedemo/main.dart';
import 'package:firebasedemo/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  final String type;
  final String image;

  const HomeScreen({super.key,
    required this.email,
    required this.type,
    required this.image});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    getUserDataFromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.image),
                      ),
                      Text(widget.email),
                    ],
                  ),
                )),
            ListTile(
              onTap: () async {
                if (widget.type == 'googleLogin') {
                  final GoogleSignInAccount? user =
                  await GoogleSignIn().signOut();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'title')));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'title')));
                }
              },
              title: Text('Logout'),
              trailing: Icon(Icons.logout),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: (userList.isEmpty)
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                String docId = '';
                var ss = FirebaseFirestore.instance
                    .collection('Chat')
                    .snapshots();

                ss.forEach((element) {
                  print(element.docs.first.id);
                  element.docs.forEach((element) {
                    print(element.id);
                    if (element.id == "${widget.email}-${userList[index].email!}") {
                      print("1st");
                      docId = "${widget.email}-${userList[index].email!}";
                      print("docId");
                      print(docId);
                    } else if (element.id ==
                        "${userList[index].email!}-${widget.email}") {
                      print("2nd");
                      docId = "${userList[index].email!}-${widget.email}";
                      print(docId);
                    }
                  });
                });
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen(
                            docId: docId,
                            email: userList[index].email!,
                            authEmail: widget.email)));
              },
              child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text(userList[index].email!))),
            );
          }),
    );
  }


  getDocData(){

  }

  getUserDataFromFirebase() async {
    FirebaseFirestore.instance.collection('User').get().then((value) {
      print(value.docs.length);
      var data = value.docs;
      data.forEach((element) {
        setState(() {
          userList.add(UserModel.fromJson(element.data()));
        });
      });
    });
  }
}
