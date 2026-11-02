import 'package:flutter/material.dart';
import 'disciplina_controller.dart';
import 'disciplina.dart';

class FormularioDisciplina extends StatefulWidget {
  const new({super.key});

  @override
  State<FormularioDisciplina> createState() => _FormularioDisciplinaState();
}

class _FormularioDisciplinaState extends State<FormularioDisciplina> {
  TextEditingController nomeCtrl = TextEditingController();
  TextEditingController totalAulasCtrl = TextEditingController();
  TextEditingController aulasPorDiaCtrl = TextEditingController(); 
  TextEditingController faltasCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Formulário"),),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: nomeCtrl,
              decoration: const InputDecoration(labelText: "Nome da disciplina"),
            ),
            TextField(
              controller: totalAulasCtrl,
              decoration: const InputDecoration(labelText: "Total de aulas"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: aulasPorDiaCtrl,
              decoration: const InputDecoration(labelText: "Aulas por dia"),
              keyboardType: TextInputType.number,
            ),                      
            TextField(
              controller: faltasCtrl,
              decoration: const InputDecoration(labelText: "Faltas"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                int? totalAulas = int.tryParse(totalAulasCtrl.text);
                int? aulasPorDia = int.tryParse(aulasPorDiaCtrl.text);
                int faltas = int.tryParse(faltasCtrl.text) ?? 0;

                // se faltar algum campo obrigatório, snackbar com mensagem de erro aparece e a tela nao fecha
                if (nomeCtrl.text.isEmpty || totalAulas == null || aulasPorDia == null) {
                  SnackBar snackBar = const SnackBar(
                    content: Text("Preencha nome, total de aulas e aulas por dia."),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }

                // incluir disciplina
                DisciplinaController.incluir(
                  Disciplina(
                    nome: nomeCtrl.text,
                    totalAulas: totalAulas,
                    aulasPorDia: aulasPorDia,
                    faltas: faltas,
                  ),                 
                );
                Navigator.pop(context);
              },
              child: Text("Gravar"))
          ],
        ),
      ),
    );
  }
}