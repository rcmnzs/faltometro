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

  int get limiteFaltas => (totalAulas! * 0.25).floor(); // limite de faltas = 25% do total de aulas (frequencia minima de 75%)
  bool get passouDoLimite => faltas > limiteFaltas; // true quando ja reprovou por falta
  int get faltasRestantes => passouDoLimite ? 0 : limiteFaltas - faltas; // nunca mostra valor negativo
  double get percentualFaltas => faltas / totalAulas! * 100; // calcula percentual de faltas

  // transforma a disciplina em Map para salvar como texto (igual ao exemplo 08 do professor)
  Map<String, dynamic> toJson() {
    return {
      "nome": nome,
      "totalAulas": totalAulas,
      "aulasPorDia": aulasPorDia,
      "faltas": faltas,
    };
  }

  // faz o caminho contrario: le o Map salvo e monta a disciplina
  factory Disciplina.fromJson(Map<String, dynamic> json) {
    return Disciplina(
      nome: json["nome"],
      totalAulas: json["totalAulas"],
      aulasPorDia: json["aulasPorDia"],
      faltas: json["faltas"] ?? 0,
    );
  }
}