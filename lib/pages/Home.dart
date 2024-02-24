import 'package:flutter/material.dart';
import 'package:cookrecipe/pages/login.dart';
import 'package:image_picker/image_picker.dart';
import '../back.dart';
import 'Insert.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

import 'Recipe.dart';

class HomePage extends StatefulWidget {
  final TextEditingController email;
  final TextEditingController password;

  const HomePage({Key? key, required this.email, required this.password})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BackEnd be = BackEnd(baseUrl: "http://localhost:3000");

  TextEditingController nameController = TextEditingController();
  TextEditingController NickNameContrl = TextEditingController();
  String NickName = "NickName";
  int currentPageIndex = 1;
  int id = 0;

  bool isButton = false;

  void toggleButton() {
    setState(() {
      isButton = !isButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person_2),
            icon: Icon(Icons.person_2_outlined),
            label: 'Account',
          ),
        ],
      ),
      body: <Widget>[
        /// Search
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 55,
                    width: 330,
                    child: TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (text) {
                        updateList();
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        suffix:
                            IconButton(onPressed: null, icon: Icon(Icons.menu)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder<List<Recipes>>(
                  future: be.findName(Recipes(
                      RecipeID: 0,
                      UserID: 0,
                      Name: nameController.text,
                      Image: "",
                      Description: [],
                      Products: [],
                      Category: "",
                      Tag: "")),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Recipes>> snapshot) {
                    if (snapshot.hasData) {
                      List<Recipes>? items = snapshot.data;
                      if (items != null) {
                        return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                    'Название блюда: ${items[index].Name}'),
                                leading: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Recipe(
                                              id: items[index].RecipeID)),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        NetworkImage('${items[index].Image}'),
                                  ),
                                ),
                                subtitle: Text(''),
                              );
                            });
                      }
                    } else {
                      return Center(
                        child: Text("Empty"),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        ),

        /// Home page
        ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(150, 40, 0, 0),
              child: SizedBox(
                width: 200,
                height: 200,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Insert(
                              email: widget.email.text,
                              password: widget.password.text)),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(
                        'Добавить свой рецепт',
                        style: TextStyle(fontSize: 35),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 150, 100),
                        child: Icon(
                          Icons.arrow_right_alt_outlined,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: null,
              child: Card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    'https://hi-news.ru/wp-content/uploads/2023/05/food_photo_1-750x476.jpg',
                    height: 180,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Center(
              child: Text(
                "Рецепт дня",
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Column(
                children: [
                  Row(
                    children: [
                      tag("Холодные \n закуски",
                          'https://reveltime.storage.yandexcloud.net/d8/styles/blog_article_1200/s3/article/2022/screenshot_3_8.jpg?itok=G90J-nhA'),
                      const SizedBox(width: 20),
                      tag("Холодные \n закуски",
                          'https://reveltime.storage.yandexcloud.net/d8/styles/blog_article_1200/s3/article/2022/screenshot_3_8.jpg?itok=G90J-nhA'),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      tag("Холодные \n закуски",
                          'https://reveltime.storage.yandexcloud.net/d8/styles/blog_article_1200/s3/article/2022/screenshot_3_8.jpg?itok=G90J-nhA'),
                      const SizedBox(width: 10),
                      tag("Холодные \n закуски",
                          'https://reveltime.storage.yandexcloud.net/d8/styles/blog_article_1200/s3/article/2022/screenshot_3_8.jpg?itok=G90J-nhA'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        /// Messages page
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Align(
            alignment: Alignment.topCenter,
            child: FutureBuilder<Users>(
              future: be.login(Users(
                  UserID: 0,
                  Email: "${widget.email.text}",
                  Password: "${widget.password.text}")),
              builder: (BuildContext context, AsyncSnapshot<Users> snapshot) {
                if (snapshot.hasData) {
                  Users? items = snapshot.data;
                  if (items != null) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            final pickedFile = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              // Вызываем функцию для отправки файла на сервер
                              be.uploadFile(File(pickedFile.path), items.Email,
                                  'users', 'uploaduser');
                              be.updateImage(
                                  "http://localhost:3000/assets/images/${items.Email}.png",
                                  items.UserID);
                              setState(() {
                                // Обновляем данные в виджете, чтобы перестроить интерфейс с новым изображением
                                updateList();
                              });
                            }
                          },
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                                "${items?.Image}?${DateTime.now().millisecondsSinceEpoch}"),
                          ),
                        ),
                        Row(
                          children: [
                            if (isButton == false)
                              SizedBox(
                                width: 150,
                                child: Text(
                                  '${items?.NickName}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                  ),
                                ),
                              )
                            else
                              SizedBox(
                                width: 150,
                                child: TextField(
                                  controller: NickNameContrl,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: NickName,
                                  ),
                                ),
                              ),
                            IconButton(
                              icon: isButton == false
                                  ? Icon(Icons.update)
                                  : Icon(Icons.done),
                              onPressed: () async {
                                if (isButton == false) {
                                  toggleButton();
                                  print("хуй $isButton");
                                  print('${NickNameContrl.text}');
                                } else {
                                  be.updateNickname(
                                      "${NickNameContrl.text}", items.UserID);
                                  toggleButton();
                                }
                              },
                            )
                          ],
                        ),
                      ],
                    );
                  }
                } else {
                  return Center(
                    child: Text("Empty"),
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        )
      ][currentPageIndex],
    );
  }

  void updateList() {
    setState(() {
      // Обновите список, например, снова вызовите ваш запрос
      // be.findName(Recipes(RecipeID: 0, UserID: 0, Name: nameController.text, Description: "", Products: "", Tag: ""));
    });
  }

  tag(String tag, String url) {
    return Container(
      height: 160,
      width: 130,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.fill)),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          tag,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
