import 'package:flutter/material.dart';

class Resumo extends StatefulWidget {
  const new({super.key});

  @override
  State<Resumo> createState() => _ResumoTelaState();
}

class _ResumoTelaState extends State<Resumo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Tela Resumo")
        ],
      ),)
    );
  }
}