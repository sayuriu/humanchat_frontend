class EditChannelDto {
  final String name;
  final List<BigInt> members;
  EditChannelDto({
    required this.name,
    required this.members
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "members": members
  };
}