class ChannelInfoDto {
  final BigInt id;
  final String name;
  final List<BigInt> members;

  ChannelInfoDto(this.id, this.name, this.members);

  factory ChannelInfoDto.fromJson(Map<String, dynamic> json) {
    return ChannelInfoDto(BigInt.parse(json['id']), json['name'], json['members'] as List<BigInt>);
  }
}