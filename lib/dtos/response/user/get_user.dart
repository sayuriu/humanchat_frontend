class GetUserResponseDto {
  final String username;
  final String displayName;
  final String bio;

  GetUserResponseDto({
    required this.username,
    required this.displayName,
    required this.bio,
  });

  factory GetUserResponseDto.fromJson(Map<String, dynamic> json) {
    return GetUserResponseDto(
      username: json['username'],
      displayName: json['name'],
      bio: json['bio'],
    );
  }
}