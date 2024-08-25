import 'package:flutter/material.dart';
import 'package:notes/noteScreen.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pandalan_Hukuk',
      theme: ThemeData(
          primarySwatch: Colors.yellow
      ),
      home:BookDatabaseHome(),
    );
  }
}

