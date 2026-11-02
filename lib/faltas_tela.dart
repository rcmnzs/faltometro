import 'package:flutter/material.dart';

class Faltas extends StatefulWidget {
  const new({super.key});

  @override
  State<Faltas> createState() => _FaltasState();
}

class _FaltasState extends State<Faltas> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Tela Faltas")
        ],
      ),)
    );
  }
}