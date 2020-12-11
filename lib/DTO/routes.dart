class Routes {

  static const String baseURL = "https://localhost:44354/";
  static const String admins = baseURL + "admins/";
  static const String doctors = baseURL + "doctors/";
  static const String manufacturers = baseURL + 'manufacturers/';

  static const String doctorsLogin = doctors + "login";
  static const String doctorsRegister = doctors + "register";
  static const String adminsLogin = admins + "login";
  static const String adminsRegister = admins + "register";

  // Manufacturers
  static const String manufacturersGetAll = manufacturers;
  static const String manufacturersGet = manufacturers;
  static const String manufacturersDelete = manufacturers + "delete/";
  static const String manufacturersEdit = manufacturers + "edit/";
  static const String manufacturersCreate = manufacturers + "create";

}