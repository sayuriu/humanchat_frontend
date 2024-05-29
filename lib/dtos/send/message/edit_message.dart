class EditMessageDto {
  final String content;

  EditMessageDto({
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }
}