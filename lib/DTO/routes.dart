class Routes {

  static const String baseURL = "https://localhost:44354/";
  static const String admins = baseURL + "admins/";
  static const String doctors = baseURL + "doctors/";
  static const String manufacturers = baseURL + 'manufacturers/';
  static const String diseases = baseURL + 'diseases/';
  static const String medicalprotocols = baseURL + 'medicalprotocols/';

  static const String doctorsLogin = doctors + "login";
  static const String doctorsRegister = doctors + "register";
  static const String adminsLogin = admins + "login";
  static const String adminsRegister = admins + "register";


  // CRUD
  static const String delete = "delete/";
  static const String edit = "edit/";
  static const String create = "create";

  // Manufacturers
  static const String manufacturersGetAll = manufacturers;
  static const String manufacturersGet = manufacturers;
  static const String manufacturersDelete = manufacturers + "delete/";
  static const String manufacturersEdit = manufacturers + "edit/";
  static const String manufacturersCreate = manufacturers + "create";

  // Diseases
  static const String diseasesGetAll = diseases;
  static const String diseasesGet = diseases;
  static const String diseasesDelete = diseases + "delete/";
  static const String diseasesEdit = diseases + "edit/";
  static const String diseasesCreate = diseases + "create";

}