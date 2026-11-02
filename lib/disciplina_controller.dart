import 'disciplina.dart';

class DisciplinaController {
  static List<Disciplina> lista = [];

  static void incluir(Disciplina d) {
    lista.add(d);
  }

  static void editar(int index, Disciplina d) {
    lista[index] = d;
  }

  static void excluir(Disciplina d) {
    lista.remove(d);
  }

  static List<Disciplina> listar() {
    return lista;
  }
}

