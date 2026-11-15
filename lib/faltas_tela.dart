import 'package:flutter/material.dart';
import 'disciplina.dart';
import 'disciplina_controller.dart';
import 'falta.dart';
import 'falta_controller.dart';

class Faltas extends StatefulWidget {
  final Disciplina? disciplina; // quando vem da tela Disciplinas, ja abre com ela escolhida

  const Faltas({super.key, this.disciplina});

  @override
  State<Faltas> createState() => _FaltasState();
}

class _FaltasState extends State<Faltas> {
  Disciplina? disciplinaEscolhida;
  DateTime data = DateTime.now();
  int? _opcao = 1; // 1 = dia todo, 2 = só 1 aula

  @override
  void initState() {
    super.initState();
    disciplinaEscolhida = widget.disciplina;
  }

  @override
  Widget build(BuildContext context) {
    // sem disciplina cadastrada não tem o que registrar
    if (DisciplinaController.lista.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Cadastre uma disciplina primeiro.")),
      );
    }

    return Scaffold(
      // como aba nao tem AppBar (a Principal ja tem); aberta pela lista, tem
      appBar: widget.disciplina != null
          ? AppBar(title: const Text("Registrar falta"))
          : null,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // componente nao visto em sala: DropdownButton
            DropdownButton<Disciplina>(
              isExpanded: true,
              value: disciplinaEscolhida,
              hint: const Text("Escolha a disciplina"),
              items: DisciplinaController.lista.map((d) {
                return DropdownMenuItem<Disciplina>(
                  value: d,
                  child: Text(d.nome!),
                );
              }).toList(),
              onChanged: (d) {
                setState(() {
                  disciplinaEscolhida = d;
                });
              },
            ),
            if (disciplinaEscolhida != null) Text(_resumoDisciplina()),
            const SizedBox(height: 10),
            Row(
              children: [
                Text("Data: ${_formatarData(data)}"),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _escolherData,
                  child: const Text("Alterar data"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text("Quantas aulas faltou?"),
            RadioGroup<int>(
              groupValue: _opcao,
              onChanged: (value) {
                setState(() {
                  _opcao = value;
                });
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      const Radio<int>(value: 1),
                      Text(_textoDiaTodo()),
                    ],
                  ),
                  const Row(
                    children: [
                      Radio<int>(value: 2),
                      Text("Só 1 aula"),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _registrar,
                child: const Text("Registrar falta"),
              ),
            ),
            const Divider(),
            const Text("Histórico"),
            Expanded(child: _construirHistorico()),
          ],
        ),
      ),
    );
  }

  Widget _construirHistorico() {
    // mais recentes primeiro
    List<Falta> historico = FaltaController.lista.reversed.toList();

    if (historico.isEmpty) {
      return const Center(child: Text("Nenhuma falta registrada."));
    }

    return ListView.builder(
      itemCount: historico.length,
      itemBuilder: (context, index) {
        Falta f = historico[index];
        return Card(
          child: ListTile(
            title: Text(f.nomeDisciplina!),
            subtitle: Text(_formatarData(f.data!)),
            trailing: Text(_textoAulas(f.aulas!)),
          ),
        );
      },
    );
  }

  // componente nao visto em sala: showDatePicker
  Future<void> _escolherData() async {
    DateTime? escolhida = await showDatePicker(
      context: context,
      initialDate: data,
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
    );

    if (escolhida != null) {
      setState(() {
        data = escolhida;
      });
    }
  }

  Future<void> _registrar() async {
    // precisa escolher a disciplina antes
    if (disciplinaEscolhida == null) {
      SnackBar snackBar = const SnackBar(
        content: Text("Escolha uma disciplina."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);      
      return;
    }

    Disciplina d = disciplinaEscolhida!;

    // cada falta vale 1 aula: dia todo soma as aulas do dia, senao soma 1
    int aulas = _opcao == 1 ? d.aulasPorDia! : 1;

    d.faltas += aulas;
    Falta f = Falta(nomeDisciplina: d.nome, data: data, aulas: aulas);
    setState(() {});

    // salva a falta no historico e o novo total de faltas da disciplina
    await FaltaController.incluir(f);
    await DisciplinaController.salvar();
    // se trocou de aba enquanto salvava, nao tem mais tela para mostrar mensagem
    if (!mounted) return;

    SnackBar snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      persist: false, // sem isso, SnackBar com acao nao some sozinho
      content: Text("Falta registrada: ${_textoAulas(aulas)} em ${d.nome}"),
      action: SnackBarAction(
        label: "Desfazer",
        onPressed: () {
          _desfazer(d, f);
        },
      ),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    _avisarLimite(d);
  }

  Future<void> _desfazer(Disciplina d, Falta f) async {
    d.faltas -= f.aulas!;
    await FaltaController.excluir(f);
    await DisciplinaController.salvar();
    // se o usuario trocou de aba antes de desfazer, a tela nao existe mais
    if (mounted) {
      setState(() {});
    }
  }

  // AlertDialog aparece quando chega perto do limite, no limite ou passa dele
  void _avisarLimite(Disciplina d) {
    String titulo = "";
    String mensagem = "";

    if (d.faltas > d.limiteFaltas) {
      titulo = "Reprovado por falta";
      mensagem = "${d.nome} passou do limite de ${d.limiteFaltas} faltas.";
    } else if (d.faltas == d.limiteFaltas) {
      titulo = "Limite atingido";
      mensagem =
          "Você usou todas as faltas de ${d.nome}. Mais uma e reprova.";
    } else if (d.faltas >= d.limiteFaltas * 0.8) {
      titulo = "Cuidado!";
      mensagem = "Faltas restantes em ${d.nome}: ${d.faltasRestantes}.";
    } else {
      return;
    }

    AlertDialog alertDialog = AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Ok, ciente"),
        ),
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  String _resumoDisciplina() {
    Disciplina d = disciplinaEscolhida!;
    int restantes = d.faltasRestantes < 0 ? 0 : d.faltasRestantes;
    return "Faltas: ${d.faltas} de ${d.limiteFaltas} permitidas (restam $restantes)";
  }

  String _textoDiaTodo() {
    if (disciplinaEscolhida == null) {
      return "Dia todo";
    }
    return "Dia todo (${_textoAulas(disciplinaEscolhida!.aulasPorDia!)})";
  }

  String _textoAulas(int n) {
    return n == 1 ? "1 aula" : "$n aulas";
  }

  String _formatarData(DateTime d) {
    String dia = d.day.toString().padLeft(2, '0');
    String mes = d.month.toString().padLeft(2, '0');
    return "$dia/$mes/${d.year}";
  }
}