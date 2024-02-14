
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../back.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'Register.dart';

class Insert extends StatefulWidget {


  final String email;
  final String password;

  const Insert({Key? key, required this.email, required this.password}) : super(key: key);
  @override
  State<Insert> createState() => _InsertState();
}


BackEnd be = BackEnd(baseUrl: "http://localhost:3000");
TextEditingController name = TextEditingController();
TextEditingController description = TextEditingController();

TextEditingController nameController = TextEditingController();
TextEditingController weightController = TextEditingController();
TextEditingController stepController = TextEditingController();

int iduser=0;
int currentStepNumber = 0;
int currentProductID = 0;
const List<String> category = <String>['Завтрак', 'Обед', 'Ужин', 'Перекус'];
const List<String> tag = <String>['Холодные закуски', 'Горячие закуски', 'Салаты', 'Супы', 'Мясо', 'Гарниры', 'Напитки'];
String image='http://localhost:3000/assets/recipes/image.png';
List<Product> products = [];
List<Steps> steps = [];
List<String> product = [];
List<String> weight = [];
List<String> step=[];

class _InsertState extends State<Insert> {

  String dropdownCategory = category.first;
  String dropdownTag = tag.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Вернуться назад при нажатии кнопки "назад"
          },
        ),
        title: Text("Login"),
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle_outline,
                color: Colors.green), // Иконка вашей кнопки
            onPressed: () async{
              Users users = Users(UserID: 0, Email: "${widget.email}", Password: "${widget.password}");
              Users loggedInUser = await be.login(users);
              iduser = loggedInUser.UserID;
              uploadAndAdd();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Рецепт загружен'),
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
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(height: 15),
             Field(name,TextInputType.text ,'Введите название блюда', 300),
              if (image == 'http://localhost:3000/assets/recipes/image.png')
                Image.network(image)
              else
                SizedBox(
                    width: 300,
                    height: 300,
                    child: Image.file(File(image))
                ),
             TextButton(
                 onPressed: () async{
                   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                   if (pickedFile != null) {
                     setState(() {
                       image = pickedFile.path;
                     });
                   }
                 },
                 child: Text('Загрузите фотографию')),
             for (var i = 0; i < product.length && i < weight.length; i++)
               ListTile(
                 title: Text('${i + 1}. ${product[i]} ${weight[i]}гр.'),
               ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Field(nameController,TextInputType.text,'Введите навзание продукта',218),
                  Field(weightController, TextInputType.numberWithOptions(decimal: true), "Вес гр.", 80)
                ],
              ),
              TextButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && weightController.text.isNotEmpty) {
                      currentProductID++;
                      addProduct();
                      setState(() {
                        product.add(nameController.text);
                        nameController.clear();
                        weight.add(weightController.text);
                        weightController.clear();
                      });
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Заполните описание шага'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  child: Text('Добавить продукт')
              ),
              for (var item in step)
                ListTile(
                  title: Text('${step.indexOf(item) + 1}. $item'),
                ),
              Field(stepController,TextInputType.text,'Опишите шаг',300),
              TextButton(
                  onPressed: () {
                    if (stepController.text.isNotEmpty) {
                      currentStepNumber++;
                      addStep();
                      setState(() {
                        step.add(stepController.text);
                        stepController.clear();
                      });

                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Заполните описание шага'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    }

                  },
                  child: Text('Добавить шаг')
              ),
              Row(
                children: [
                  DropdownMenu<String>(
                    initialSelection: category.first,
                      onSelected: (String? value) {
                        setState(() {
                          dropdownCategory = value!;
                        });
                      },
                    dropdownMenuEntries: category.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(value: value, label: value);
                    }).toList(),),
                  DropdownMenu<String>(
                    initialSelection: tag.first,
                    onSelected: (String? value) {
                      setState(() {
                        dropdownTag = value!;
                      });
                    },
                    dropdownMenuEntries: tag.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(value: value, label: value);
                    }).toList(),),
                ],
              ),
          ]
          ),
        ],
      ),
    );
  }

  Future<void> uploadAndAdd() async {
    try {
      await be.uploadFile(File(image), '${name.text}.$iduser','recipes', 'uploadrecipe');
      await Future.delayed(Duration(seconds: 2));
      add();
    } catch (error) {
      print('Error: $error');
    }
  }

  void addProduct() async {
    String name = nameController.text;
    int weight = int.parse(weightController.text);
    products.add(Product(ProductID: currentProductID, Name: name, Weight: weight));
  }
  void addStep() async {
    String step = stepController.text;
    steps.add(Steps(StepNumber: currentStepNumber, Step: step));
  }

  void add() async{
    Recipes o =Recipes(
        RecipeID: 0,
        UserID: iduser,
        Name: name.text,
        Image:'http://localhost:3000/assets/recipes/${name.text}.$iduser.png',
        Description: steps,
        Products: products,
        Category: dropdownCategory,
        Tag: dropdownTag);
     await be.add(o);
  }
}


   Field(TextEditingController control,keyboardType,String string,double width){
    return Column(
      children: [
        SizedBox(
          width: width,
          child: TextField(
            controller: control,
            keyboardType:keyboardType,
            decoration:  InputDecoration(
              border: OutlineInputBorder(),
              labelText:string,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
