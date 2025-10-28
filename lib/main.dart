import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабораторная работа 2 - Вариант 7',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Лабораторная работа 2 - Козлова Дарья'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // Контейнер 1 с изображением
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
                image: DecorationImage(
                  image: AssetImage('assets/image1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // Контейнер 2 с изображением
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
                image: DecorationImage(
                  image: AssetImage('assets/image2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // Контейнер 3 с изображением
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
                image: DecorationImage(
                  image: AssetImage('assets/image3.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // Контейнер 4 с изображением
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
                image: DecorationImage(
                  image: AssetImage('assets/image4.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // Контейнер 5 с изображением
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
                image: DecorationImage(
                  image: AssetImage('assets/image5.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}