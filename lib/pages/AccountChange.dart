import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../back.dart';

class Account extends StatefulWidget {
  final int iduser;
  final String image;
  final String nickname;
  const Account({Key? key, required this.image, required this.nickname, required this.iduser});

  @override
  State<Account> createState() => _AccountState();
}


BackEnd be = BackEnd(baseUrl: "http://localhost:3000");
String str = "";
TextEditingController name = TextEditingController();


class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            be.update(name.text, str,widget.iduser );
            Navigator.of(context).pop();
          },
        ),
        title: Text(""),
        actions: [
          IconButton(
            icon: Icon(Icons.check,
                size: 30,
                color: Colors.black),
            onPressed: () async{
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Данные обновлены'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Align(
          alignment: Alignment.topCenter,
          child:Column(

          ),
        ),
      ),

    );
  }
}
