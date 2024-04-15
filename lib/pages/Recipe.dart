import 'package:cookrecipe/pages/Insert.dart';
import 'package:flutter/material.dart';
import '../back.dart';

class Recipe extends StatefulWidget {
  final int id;

  const Recipe({Key? key, required this.id}) : super(key: key);

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  BackEnd be = BackEnd(baseUrl: "http://localhost:3000");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Рецепт'),
      ),
      body: FutureBuilder<Recipes>(
        future: be.getRecipeById(widget.id),
        builder: (BuildContext context, AsyncSnapshot<Recipes> snapshot) {
          if (snapshot.hasData) {
            Recipes? items = snapshot.data;
            if (items != null) {
              return Column(
                children: [
                  CircleAvatar(
                    radius: 90,
                    backgroundImage: NetworkImage('${items!.Image}'),
                  ),
                  Text('${items.Name}'),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.Description.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              'Шаг ${items.Description[index].StepNumber}: ${items.Description[index].Step}'),
                        );
                      },
                    ),
                  ),
                  Text('Список продуктов:'),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.Products.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              '${items.Products[index].ProductID}: ${items.Products[index].Name} ${items.Products[index].Weight}гр.'),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
