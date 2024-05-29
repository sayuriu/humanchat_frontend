class UpdateUserDto {
  final String? email;
  final String? password;
  final String? oldPassword;
  final String? username;
  final String? displayName;
  final String? bio;

  UpdateUserDto({
    this.email,
    this.password,
    this.oldPassword,
    this.username,
    this.displayName,
    this.bio,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'oldPassword': oldPassword,
    'username': username,
    'displayName': displayName,
    'bio': bio,
  };
}