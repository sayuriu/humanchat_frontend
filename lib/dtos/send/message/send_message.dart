class SendMessageDto {
  final String content;
  final BigInt? replyTo;

  SendMessageDto({
    required this.content,
    this.replyTo,
  });

  Map<String, dynamic> toJson() {
    if (replyTo != null) {
      return {
        'content': content,
        'replyTo': replyTo.toString(),
      };
    }
    return {
      'content': content,
    };
  }
}