import 'package:flutter/material.dart';
import 'visualitzar_productes.dart';
import 'package:provider/provider.dart';
import 'data_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: VisualitzarProductes(),
    );
  }
}
