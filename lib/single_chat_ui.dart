import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleChatWidget extends StatefulWidget {
  final String message;
  final int index;

  const SingleChatWidget(
      {super.key, required this.message, required this.index});

  @override
  State<SingleChatWidget> createState() => _SingleChatWidgetState();
}

class _SingleChatWidgetState extends State<SingleChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){

        },
        child: Container(
            width: double.infinity,
            child: Align(
                alignment: (widget.index % 2 == 0)
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(child: Text(widget.message)))),
      ),
    );
  }
}
