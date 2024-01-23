import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatScreen extends StatefulWidget {
  final String email;
  final String authEmail;
  final String docId;

  const ChatScreen({super.key, required this.email, required this.authEmail, required this.docId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();


  bool isLongPress = false;
  String doc = '';

  @override
  void initState() {
    // TODO: implement initState
    // getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.email),
        actions: [
          isLongPress == false
              ? Container()
              : IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Delete'),
                              content: Text('Are you sure want to delete?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      deleteMessage(doc);
                                      setState(() {
                                        isLongPress = false;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Yes')),
                                TextButton(onPressed: () {}, child: Text('No'))
                              ],
                            ));
                  },
                  icon: Icon(Icons.delete)),
          isLongPress == false
              ? Container()
              : IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 100,
        child: StreamBuilder(
            stream: getMessages(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              return (snapshot.data == null)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onLongPress: () {
                              setState(() {
                                isLongPress = true;
                                doc = data[index].id;
                              });
                            },
                            child: Container(
                                width: double.infinity,
                                child: Align(
                                    alignment: (data[index]['sendBy']==widget.email)
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: Container(

                                        child: Text(data[index]['message'])))),
                          ),
                        );
                      });
            }),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 65,
              child: TextFormField(
                controller: messageController,
                decoration: InputDecoration(hintText: "Enter Message"),
              ),
            ),
            IconButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('Chat')
                      .doc(widget.docId)
                      .collection('chats')
                      .doc()
                      .set({
                    'message': messageController.text,
                    'sendBy': widget.authEmail,
                    'createdAt': DateTime.now().toString()
                  });
                  messageController.clear();
                },
                icon: Icon(Icons.send))
          ],
        ),
      ),
    );
  }

  getData() {

  }

  getMessages() {
    return FirebaseFirestore.instance
        .collection('Chat')
        .doc(widget.docId)
        .collection('chats')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  deleteMessage(String id) {
    FirebaseFirestore.instance
        .collection('Chat')
        .doc(widget.docId)
        .collection('chats')
        .doc(id)
        .delete();
  }
}
