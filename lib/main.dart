import 'package:flutter/material.dart';
import 'principal.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {    
    return MaterialApp(
      title: "Faltômetro",      
      debugShowCheckedModeBanner: false,
      // definindo tema
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Color.fromARGB(255, 46, 53, 54),
        useMaterial3: true,       
        ),     
      home: Principal(),
    );
  }
}