import 'package:flutter/material.dart';
import 'principal.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Faltômetro",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        appBarTheme: AppBarTheme(backgroundColor: Colors.lightGreen[700],)
      ),
      home: Principal(),
    );
  }
}