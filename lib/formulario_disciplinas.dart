import 'package:flutter/material.dart';
import 'disciplina_controller.dart';
import 'disciplina.dart';
import 'falta_controller.dart';

class FormularioDisciplinas extends StatefulWidget {
  final Disciplina? disciplina; // se vier preenchida, o formulario abre em modo edicao
  final int? index; // posicao da disciplina na lista (usado para editar)

  const FormularioDisciplinas({Key? key, this.disciplina, this.index}) : super(key: key);

  @override
  State<FormularioDisciplinas> createState() => _FormularioDisciplinasState();
}

class _FormularioDisciplinasState extends State<FormularioDisciplinas> {
  TextEditingController nomeCtrl = TextEditingController();
  TextEditingController totalAulasCtrl = TextEditingController();
  TextEditingController aulasPorDiaCtrl = TextEditingController();
  TextEditingController faltasCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // no modo edicao, os campos ja comecam preenchidos com os dados da disciplina
    nomeCtrl = TextEditingController(text: widget.disciplina?.nome ?? '');
    totalAulasCtrl = TextEditingController(text: widget.disciplina?.totalAulas?.toString() ?? '');
    aulasPorDiaCtrl = TextEditingController(text: widget.disciplina?.aulasPorDia?.toString() ?? '');
    faltasCtrl = TextEditingController(text: widget.disciplina?.faltas.toString() ?? '');
  }

  @override
  void dispose() {
    nomeCtrl.dispose();
    totalAulasCtrl.dispose();
    aulasPorDiaCtrl.dispose();
    faltasCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool editando = widget.disciplina != null;

    // mostra uma mensagem rapida (SnackBar) na tela
    mostrarMensagem(String texto) {
      SnackBar snackBar = SnackBar(content: Text(texto));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

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
              decoration: const InputDecoration(labelText: "Faltas já registradas (opcional)"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () async {
                String nome = nomeCtrl.text.trim();
                int? totalAulas = int.tryParse(totalAulasCtrl.text);
                int? aulasPorDia = int.tryParse(aulasPorDiaCtrl.text);
                int faltas = int.tryParse(faltasCtrl.text) ?? 0;

                // se faltar algum campo obrigatório, snackbar com mensagem de erro aparece e a tela nao fecha
                if (nome.isEmpty || totalAulas == null || aulasPorDia == null) {
                  mostrarMensagem("Preencha nome, total de aulas e aulas por dia.");
                  return;
                }

                // os numeros precisam fazer sentido
                if (totalAulas <= 0 || aulasPorDia <= 0) {
                  mostrarMensagem("Total de aulas e aulas por dia devem ser maiores que zero.");
                  return;
                }
                if (faltas < 0) {
                  mostrarMensagem("As faltas não podem ser negativas.");
                  return;
                }

                // nao pode ter duas disciplinas com o mesmo nome (o historico de faltas usa o nome)
                bool nomeRepetido = false;
                for (Disciplina d in DisciplinaController.lista) {
                  if (d.nome!.toLowerCase() == nome.toLowerCase() && d != widget.disciplina) {
                    nomeRepetido = true;
                  }
                }
                if (nomeRepetido) {
                  mostrarMensagem("Já existe uma disciplina com esse nome.");
                  return;
                }

                Disciplina disciplina = Disciplina(
                  nome: nome,
                  totalAulas: totalAulas,
                  aulasPorDia: aulasPorDia,
                  faltas: faltas,
                );

                if (editando) {
                  // editar disciplina
                  String nomeAntigo = widget.disciplina!.nome!;
                  await DisciplinaController.editar(widget.index!, disciplina);
                  // se o nome mudou, o historico de faltas passa a usar o nome novo
                  if (nomeAntigo != nome) {
                    await FaltaController.renomear(nomeAntigo, nome);
                  }
                } else {
                  // incluir disciplina
                  await DisciplinaController.incluir(disciplina);
                }

                Navigator.pop(context);
              },
              child: Text("Gravar"),
            ),
          ],
        ),
      ),
    );
  }
}
