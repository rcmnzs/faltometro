class Disciplina {
  String? nome;
  int? totalAulas;
  int? aulasPorDia;
  int faltas;

  Disciplina({
    this.nome,
    this.totalAulas,
    this.aulasPorDia,
    this.faltas = 0,
  });

  int get limiteFaltas => (totalAulas! * 0.25).floor();
  int get faltasRestantes => limiteFaltas - faltas;
  double get percentualFaltas => faltas / totalAulas! * 100;
}