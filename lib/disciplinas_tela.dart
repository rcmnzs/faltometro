import 'package:flutter/material.dart';
import 'formulario_disciplinas.dart';
import 'disciplina.dart';
import 'disciplina_controller.dart';
import 'falta_controller.dart';
import 'faltas_tela.dart';

class DisciplinasTela extends StatefulWidget {
  const new({super.key});

  @override
  State<DisciplinasTela> createState() => _DisciplinasTelaState();
}

class _DisciplinasTelaState extends State<DisciplinasTela> {
  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  // le as disciplinas e as faltas salvas no celular (igual ao exemplo 08 do professor)
  Future<void> carregarDados() async {
    await DisciplinaController.carregar();
    await FaltaController.carregar();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _construirLista(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // abrir tela de cadastro de disciplina (sem passar nada = modo cadastro)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormularioDisciplinas()),
          ).then((_) { setState(() {}); });
        },
        tooltip: "Adicionar Disciplina",
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _construirLista() {
    if (DisciplinaController.lista.isNotEmpty) {
      return ListView.builder(
        itemCount: DisciplinaController.lista.length,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 80), // espaco embaixo para o botao + nao cobrir o ultimo card
        itemBuilder: (BuildContext context, index) {
          var d = DisciplinaController.lista[index];

          // progresso da barra = faltas / limite (nunca passa de 1.0)
          double progresso = 1.0; // se o limite for 0, a barra ja aparece cheia
          if (d.limiteFaltas > 0) {
            progresso = d.faltas / d.limiteFaltas;
            if (progresso > 1.0) {
              progresso = 1.0;
            }
          }

          // cor da barra muda dependendo da quantidade de faltas
          Color cor = Colors.green;
          if (progresso >= 1.0) {
            cor = Colors.red;
          } else if (progresso >= 0.8) {
            cor = Colors.amber;
          }

          // texto da direita: quantas faltas restam ou aviso de limite estourado
          String textoRestantes = "Restam ${d.faltasRestantes}";
          if (d.passouDoLimite) {
            textoRestantes = "Limite excedido";
          }

          return Card(
            child: ListTile(
              // toque simples: abre a tela de registrar falta ja com essa disciplina
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Faltas(disciplina: d)),
                ).then((_) { setState(() {}); });
              },
              // toque longo: abre as opcoes de editar e excluir
              onLongPress: () {
                _mostrarOpcoes(index);
              },
              title: Text(d.nome!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${d.faltas} de ${d.limiteFaltas} faltas permitidas"),
                  LinearProgressIndicator(value: progresso, color: cor), // componente nao visto em sala: barra de progressao
                ],
              ),
              trailing: Text(textoRestantes),
            ),
          );
        },
      );
    } else {
      return const Center(child: Text("Nenhuma disciplina cadastrada.")); // se a lista de Disciplinas estiver vazia, exibe isso
    }
  }

  // SimpleDialog com as opcoes (mesmo padrao do 4_simple_dialog do professor)
  Future<void> _mostrarOpcoes(int index) async {
    Disciplina d = DisciplinaController.lista[index];

    var opcao = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(d.nome!),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, "editar");
              },
              child: const Text("Editar"),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, "excluir");
              },
              child: const Text("Excluir"),
            ),
          ],
        );
      },
    );

    if (opcao == "editar") {
      _editar(index);
    } else if (opcao == "excluir") {
      _confirmarExclusao(d);
    }
  }

  // abre o formulario passando a disciplina e a posicao dela (modo edicao)
  void _editar(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioDisciplinas(
          disciplina: DisciplinaController.lista[index],
          index: index,
        ),
      ),
    ).then((_) { setState(() {}); });
  }

  // AlertDialog pergunta antes de excluir (mesmo padrao do 3_alert_dialog do professor)
  Future<void> _confirmarExclusao(Disciplina d) async {
    AlertDialog alertDialog = AlertDialog(
      title: const Text("Excluir disciplina"),
      content: Text("Excluir ${d.nome}? As faltas registradas dela tambem serao apagadas."),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text("Excluir"),
        ),
      ],
    );

    var confirmou = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );

    if (confirmou == true) {
      await DisciplinaController.excluir(d);
      await FaltaController.excluirDaDisciplina(d.nome!); // apaga o historico dessa disciplina
      setState(() {});

      SnackBar snackBar = SnackBar(
        content: Text("${d.nome} excluída"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
