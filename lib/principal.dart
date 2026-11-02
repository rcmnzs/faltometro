import 'package:flutter/material.dart';
import 'disciplinas_tela.dart';
import 'faltas_tela.dart';
import 'resumo_tela.dart';
import 'sobre_tela.dart';

class Principal extends StatefulWidget {
  const new({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  var paginaAtual = 0;
  var paginas = const [DisciplinasTela(), Faltas(), Resumo(), Sobre()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Faltômetro'),),
      body: paginas.elementAt(paginaAtual),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.lightGreen[100],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: "Disciplinas"),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_busy), 
            label: "Faltas"),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: "Resumo"),
            BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: "Sobre"),
        ],
        currentIndex: paginaAtual,
        fixedColor: Colors.green[900],
        unselectedItemColor: Colors.grey[700],
        onTap: (int i) {
          setState(() {
            paginaAtual = i;
          });
        },
      ),
    );
  }
}
