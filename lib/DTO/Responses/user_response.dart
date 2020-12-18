class UserResponse {
  final String id;
  final String name;
  final String surname;
  final String role;
  final String login;
  final String password;

  UserResponse(this.id, this.name, this.surname, this.role, this.login, this.password);

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return new UserResponse(json['id'], json['name'], json['surname'], json['role'], "", "");
  }
}