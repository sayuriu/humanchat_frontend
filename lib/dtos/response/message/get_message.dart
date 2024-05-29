import 'dart:developer';

extension ToInt on String? {
  BigInt? toInt() {
    if (this == null) {
      return null;
    }
    return BigInt.parse(this!);
  }
}

class GetMessageDto {
  final BigInt channelId;
  final BigInt messageId;
  final BigInt authorId;
  final String content;
  final BigInt? replyTo;
  final BigInt? lastEdit;

  GetMessageDto(
    this.channelId,
    this.messageId,
    this.authorId,
    this.content,
    this.replyTo,
    this.lastEdit
  );

  factory GetMessageDto.fromJson(Map<String, dynamic> json) {
    return GetMessageDto(
      (json['channelId'] as String).toInt()!,
      (json['messageId'] as String).toInt()!,
      (json['userId'] as String).toInt()!,
      json['content'],
      (json['replyTo'] as String?)?.toInt(),
      (json['lastEdit'] as String?)?.toInt()
    );
  }

}