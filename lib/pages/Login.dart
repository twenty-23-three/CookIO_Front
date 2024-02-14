import 'package:cookrecipe/pages/Home.dart';
import 'package:flutter/material.dart';
import '../back.dart';
import 'Register.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  BackEnd be = BackEnd(baseUrl: "http://localhost:3000");

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void setHome() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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
                  MaterialPageRoute(builder: (context)=>RegisterPage(setHome: setHome)),
                  );
                },
                child: const Text("Registration...",
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      )
                  ),
                  const SizedBox(
                    height:20,
                  ),
                  SizedBox(
                      width: 250,
                      child: TextField(
                        controller: password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      )
                  ),
                  ElevatedButton(
                    onPressed: () async{
                      if (email.text.isNotEmpty && password.text.isNotEmpty){
                        Users loggedInUser = await login();
                        if (loggedInUser.UserID != 0) {
                          Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) =>
                                HomePage(email: email, password: password)),
                          );
                        }
                          else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Неправильный логин или пароль'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }

                        } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Поля должны быть заполнены'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    child: const Text("Login"),
                  ),
                  const SizedBox(
                    height: 30,
                    child: TextButton(
                        onPressed: null,
                        child: Text("Forgot Password")),
                  ),
                  const SizedBox(
                    height: 30,
                    child: TextButton(
                        onPressed: null,
                        child: Text("Login as Guest")),
                  ),
                ],),
            ),
          ),
        ],
      ),
    );
  }

  Future<Users> login() async{
    Users o = Users(
      UserID: 0,
      Email: email.text,
      Password: password.text,);
     return await be.login(o);
  }
}




