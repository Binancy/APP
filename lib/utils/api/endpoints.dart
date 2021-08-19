class APIEndpoints {
  // LOGIN & REGISTER
  static const String LOGIN = "/api/login";
  static const String REGISTER = "/api/register";
  static const String LOGIN_WITH_TOKEN = "/api/login/token";

  // INCOMES
  static const String CREATE_INCOME = "/api/incomes/create";
  static const String READ_INCOMES = "/api/incomes/read";
  static const String UPDATE_INCOME = "/api/incomes/update";
  static const String DELETE_INCOME = "/api/incomes/delete";

  // EXPENSES
  static const String CREATE_EXPEND = "/api/expenses/create";
  static const String READ_EXPENSES = "/api/expenses/read";
  static const String UPDATE_EXPEND = "/api/expenses/update";
  static const String DELETE_EXPEND = "/api/expenses/delete";

  // CATEGORIES
  static const String READ_CATEGORIES = "/api/categories/read";

  // SUBSCRIPTIONS
  static const String READ_SUBSCRIPTIONS = "/api/subscriptions/read";
}
