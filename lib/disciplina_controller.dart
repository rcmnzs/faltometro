import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'disciplina.dart';

class DisciplinaController {
  static List<Disciplina> lista = [];

  // todo metodo que muda a lista chama salvar() para nao perder os dados ao fechar o app
  static Future<void> incluir(Disciplina d) async {
    lista.add(d);
    await salvar();
  }

  static Future<void> editar(int index, Disciplina d) async {
    lista[index] = d;
    await salvar();
  }

  static Future<void> excluir(Disciplina d) async {
    lista.remove(d);
    await salvar();
  }

  static List<Disciplina> listar() {
    return lista;
  }

  // transforma cada disciplina em texto JSON e guarda a lista no celular
  static Future<void> salvar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> dados = lista.map((d) => jsonEncode(d.toJson())).toList();

    await prefs.setStringList("disciplinas", dados);
  }

  // le a lista salva no celular e transforma o texto JSON de volta em Disciplina
  static Future<void> carregar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? dados = prefs.getStringList("disciplinas");

    if (dados != null) {
      lista = dados.map((item) {
        return Disciplina.fromJson(jsonDecode(item));
      }).toList();
    }
  }
}
