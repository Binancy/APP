class APIEndpoints {
  // ACCOUNT
  static const String DELETE_ACCOUNT = "/api/account/deleteAccount";
  static const String DELETE_USER_DATA = "/api/account/deleteData";
  static const String CHANGE_PASSWORD = "/api/account/changePassword";

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
  static const String CREATE_SUBSCRIPTION = "/api/subscriptions/create";
  static const String READ_SUBSCRIPTIONS = "/api/subscriptions/read";
  static const String UPDATE_SUBSCRIPTION = "/api/subscriptions/update";
  static const String DELETE_SUBSCRIPTION = "/api/subscriptions/delete";

  // SAVINGS PLANS
  static const String CREATE_SAVINGS_PLAN = "/api/savingsPlans/create";
  static const String READ_SAVINGS_PLAN = "/api/savingsPlans/read";
  static const String UPDATE_SAVINGS_PLAN = "/api/savingsPlans/update";
  static const String DELETE_SAVINGS_PLAN = "/api/savingsPlans/delete";

  // MICROEXPENSES
  static const String CREATE_MICROEXPEND = "/api/microExpends/create";
  static const String READ_MICROEXPENSES = "/api/microExpends/read";
  static const String UPDATE_MICROEXPEND = "/api/microExpends/update";
  static const String DELETE_MICROEXPEND = "/api/microExpends/delete";

  // PLANS, OFFERTS AND ANNOUNCES
  static const String READ_PLANS = '/api/plans/read';
}
