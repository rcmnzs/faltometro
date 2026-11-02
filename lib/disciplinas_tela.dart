import 'package:flutter/material.dart';
import 'formulario_diciplina.dart';
import 'disciplina_controller.dart';

class DisciplinasTela extends StatefulWidget {
  const new({super.key});

  @override
  State<DisciplinasTela> createState() => _DisciplinasTelaState();
}

class _DisciplinasTelaState extends State<DisciplinasTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: _construirLista(),      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // abrir tela de cadastro de diciplina
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormularioDisciplina()),            
          ).then((_) { setState(() {}); });
        },
        tooltip: "Adicionar Disciplina",
        child: const Icon(Icons.add),),
    );
  }

  Widget _construirLista() {
    if (DisciplinaController.lista.isNotEmpty) {
      return ListView.builder(
        itemCount: DisciplinaController.lista.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (BuildContext context, index) {
          var d = DisciplinaController.lista[index];
          double progresso = d.limiteFaltas == 0 // evita valor invalido na barra de progresso
              ? 1.0
              : (d.faltas / d.limiteFaltas).clamp(0.0, 1.0).toDouble();

          Color cor = Colors.green;
          if (progresso >= 1.0) {
            cor = Colors.red;
          } else if (progresso >= 0.8) {
            cor = Colors.amber;
          }

          return Card(
            child: ListTile(
              title: Text(d.nome!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${d.faltas} de ${d.limiteFaltas} faltas permitidas"),
                  LinearProgressIndicator(value: progresso, color: cor), // componente nao visto em sala: barra de progressao
                ],
              ),
              trailing: Text("Restam ${d.faltasRestantes}"),
            ),
          );
        },
      );
    } else {
      return const Center(child: Text("Nenhuma disciplina cadastrada.")); // se a lista de Disciplinas estiver vazia, exibe isso
    }
  }
}