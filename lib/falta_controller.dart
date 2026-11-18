import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'falta.dart';

class FaltaController {
  static List<Falta> lista = [];

  static Future<void> incluir(Falta f) async {
    lista.add(f);
    await salvar();
  }

  static Future<void> excluir(Falta f) async {
    lista.remove(f);
    await salvar();
  }

  // quando uma disciplina e excluida, o historico dela some junto
  static Future<void> excluirDaDisciplina(String nome) async {
    List<Falta> restantes = [];
    for (Falta f in lista) {
      if (f.nomeDisciplina != nome) {
        restantes.add(f);
      }
    }
    lista = restantes;
    await salvar();
  }

  // quando o nome da disciplina muda, o historico acompanha o nome novo
  static Future<void> renomear(String nomeAntigo, String nomeNovo) async {
    for (Falta f in lista) {
      if (f.nomeDisciplina == nomeAntigo) {
        f.nomeDisciplina = nomeNovo;
      }
    }
    await salvar();
  }

  static List<Falta> listar() {
    return lista;
  }

  static Future<void> salvar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> dados = lista.map((f) => jsonEncode(f.toJson())).toList();

    await prefs.setStringList("faltas", dados);
  }

  static Future<void> carregar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? dados = prefs.getStringList("faltas");

    if (dados != null) {
      lista = dados.map((item) {
        return Falta.fromJson(jsonDecode(item));
      }).toList();
    }
  }
}
