import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../back.dart';
import 'Login.dart';



class RegisterPage extends StatefulWidget {
  VoidCallback setHome;
  RegisterPage({Key? key, required this.setHome}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  BackEnd be = BackEnd(baseUrl: "http://localhost:3000");
  void setInsert() {
    setState(() {

    });
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>LoginPage()),
                  );
                  },
                child: Text("Login...",
                  style: TextStyle(
                    color: Colors.deepOrangeAccent,
                    fontSize: 20,
                  ),),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0,200,0,0),
              child: Column(
                children: [
                  SizedBox(
                      width: 250,
                      child: TextField(
                        controller: email,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      )
                  ),
                  SizedBox(
                    height:20,
                  ),
                  SizedBox(
                      width: 250,
                      child: TextField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      )
                  ),
                  SizedBox(
                    height:20,
                  ),
                  SizedBox(
                      width: 250,
                      child: TextField(
                        controller:  password1,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'RepeatPassword',
                        ),
                      )
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if(await be.isEmailUnique(email.text) == true) {
                        if (password.text == password1.text) {
                          insert();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Данные введены успешно'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                        else
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Пароль не совпадает'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                      }
                      else ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Аккаунт с таким email уже создан'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    },
                    child: Text("Register"),
                  ),
                ],),
            ),
          ),
        ],
      ),
    );
  }



  void insert() async {
    Users o = Users(
        UserID: 0,
        Image: "http://localhost:3000/assets/images/avatar.png",
        Email: email.text,
        Password: password.text,
        NickName: "NickName",
        BornDate: null);
    await be.post(o);
    widget.setHome();
    Navigator.of(context).pop();
  }


}
