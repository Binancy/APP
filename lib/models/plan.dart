class Plan {
  String idPlan = "";
  String planTitle = "";
  dynamic planAmount = 0;
  bool planMonthly = false;

  Plan();

  Plan.fromJson(Map<String, dynamic> json)
      : idPlan = json['idPlan'],
        planTitle = json['planTitle'],
        planAmount = json['planAmount'],
        planMonthly = json['planMonthly'] == 1 ? true : false;

  Map<String, dynamic> toJson() => {
        'idPlan': idPlan,
        'planTitle': planTitle,
        'planAmount': planAmount,
        'planMonthly': planMonthly ? 1 : 0
      };
}
