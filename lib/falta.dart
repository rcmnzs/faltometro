class Falta {
  String? nomeDisciplina; // guarda so o nome (e nao o objeto) para ficar facil de salvar
  DateTime? data;
  int? aulas;

  Falta({this.nomeDisciplina, this.data, this.aulas});

  // a data nao vira JSON direto, entao salva como texto (ex: 2026-11-14T00:00:00.000)
  Map<String, dynamic> toJson() {
    return {
      "nomeDisciplina": nomeDisciplina,
      "data": data?.toIso8601String(),
      "aulas": aulas,
    };
  }

  // converte o texto de volta para DateTime
  factory Falta.fromJson(Map<String, dynamic> json) {
    return Falta(
      nomeDisciplina: json["nomeDisciplina"],
      data: json["data"] != null ? DateTime.parse(json["data"]) : null,
      aulas: json["aulas"],
    );
  }
}