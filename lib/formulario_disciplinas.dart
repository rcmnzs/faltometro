import 'package:flutter/material.dart';
import 'disciplina_controller.dart';
import 'disciplina.dart';
import 'falta_controller.dart';

class FormularioDisciplinas extends StatefulWidget {
  final Disciplina? disciplina; // se vier preenchida, o formulario abre em modo edicao
  final int? index; // posicao da disciplina na lista (usado para editar)

  const FormularioDisciplinas({super.key, this.disciplina, this.index});

  @override
  State<FormularioDisciplinas> createState() => _FormularioDisciplinasState();
}

class _FormularioDisciplinasState extends State<FormularioDisciplinas> {
  late TextEditingController nomeCtrl;
  late TextEditingController totalAulasCtrl;
  late TextEditingController aulasPorDiaCtrl;
  late TextEditingController faltasCtrl;

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

    return Scaffold(
      appBar: AppBar(title: Text(editando ? "Editar disciplina" : "Nova disciplina")),
      // SingleChildScrollView evita erro de tela quando o teclado abre
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: nomeCtrl,
              decoration: const InputDecoration(labelText: "Nome da disciplina"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: totalAulasCtrl,
              decoration: const InputDecoration(labelText: "Total de aulas"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: aulasPorDiaCtrl,
              decoration: const InputDecoration(labelText: "Aulas por dia"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: faltasCtrl,
              decoration: const InputDecoration(labelText: "Faltas já registradas (opcional)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _gravar,
                child: const Text("Gravar"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // mostra uma mensagem rapida (SnackBar) na tela
  void _mostrarMensagem(String texto) {
    SnackBar snackBar = SnackBar(content: Text(texto));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _gravar() async {
    String nome = nomeCtrl.text.trim();
    int? totalAulas = int.tryParse(totalAulasCtrl.text);
    int? aulasPorDia = int.tryParse(aulasPorDiaCtrl.text);
    int faltas = int.tryParse(faltasCtrl.text) ?? 0;

    // se faltar algum campo obrigatório, snackbar com mensagem de erro aparece e a tela nao fecha
    if (nome.isEmpty || totalAulas == null || aulasPorDia == null) {
      _mostrarMensagem("Preencha nome, total de aulas e aulas por dia.");
      return;
    }

    // os numeros precisam fazer sentido
    if (totalAulas <= 0 || aulasPorDia <= 0) {
      _mostrarMensagem("Total de aulas e aulas por dia devem ser maiores que zero.");
      return;
    }
    if (faltas < 0) {
      _mostrarMensagem("As faltas não podem ser negativas.");
      return;
    }

    // nao pode ter duas disciplinas com o mesmo nome (o historico de faltas usa o nome)
    bool nomeRepetido = DisciplinaController.lista.any((d) {
      return d.nome!.toLowerCase() == nome.toLowerCase() && d != widget.disciplina;
    });
    if (nomeRepetido) {
      _mostrarMensagem("Já existe uma disciplina com esse nome.");
      return;
    }

    Disciplina nova = Disciplina(
      nome: nome,
      totalAulas: totalAulas,
      aulasPorDia: aulasPorDia,
      faltas: faltas,
    );

    if (widget.disciplina != null) {
      // editar disciplina
      String nomeAntigo = widget.disciplina!.nome!;
      await DisciplinaController.editar(widget.index!, nova);
      // se o nome mudou, o historico de faltas passa a usar o nome novo
      if (nomeAntigo != nome) {
        await FaltaController.renomear(nomeAntigo, nome);
      }
    } else {
      // incluir disciplina
      await DisciplinaController.incluir(nova);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }
}