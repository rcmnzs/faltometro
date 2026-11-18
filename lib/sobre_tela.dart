import 'package:flutter/material.dart';

// tela sem estado: so mostra texto fixo, nao tem nada que muda (por isso e Stateless)
class Sobre extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.event_busy, size: 64),
              const SizedBox(height: 10),
              const Text(
                "Faltômetro",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text("Versão 1.0.0"),
              const SizedBox(height: 20),
              const Text("Controle de faltas por disciplina: veja quantas aulas você ainda pode perder sem reprovar por frequência."),
              const SizedBox(height: 20),
              const Text("Regra usada: frequência mínima de 75% (máximo de 25% de faltas), com o limite arredondado para baixo."),
              const SizedBox(height: 20),
              const Text("Como usar: toque em uma disciplina para registrar falta. Segure para editar ou excluir."),
              const SizedBox(height: 20),
              const Text("Desenvolvido por SEU NOME AQUI"),
              const Text("IFF Campus Itaperuna"),
              const Text("Programação para Dispositivos Móveis • 2026"),
            ],
         ),
        ),      
      ),
    );
  }
}