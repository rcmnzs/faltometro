import 'package:flutter/material.dart';

// tela sem estado: so mostra texto fixo, nao tem nada que muda (por isso e Stateless)
class Sobre extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_busy,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 10),
              Text(
                "Faltômetro",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Text("Versão 1.0.0"),
              const SizedBox(height: 20),
              const Text(
                "Controle de faltas por disciplina. Cadastre suas disciplinas, "
                "registre as faltas e veja quantas aulas você ainda pode perder "
                "sem reprovar por frequência.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Regra usada: frequência mínima de 75%, ou seja, no máximo 25% "
                "de faltas sobre o total de aulas. O limite é arredondado para baixo.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Como usar: toque em uma disciplina para registrar falta. "
                "Segure para editar ou excluir.",
                textAlign: TextAlign.center,
              ),
              const Divider(height: 40),
              const Text("Desenvolvido por Rafael Chaves Menezes"),
              const Text("IFF Campus Itaperuna"),
              const Text("Programação para Dispositivos Móveis • 2026"),
            ],
          ),
        ),
      ),
    );
  }
}