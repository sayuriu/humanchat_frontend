/// Data associated with `channelJoined` event,
/// when the user joins a channel.
class ChannelJoinedEventDto {
  final BigInt channelId;
  ChannelJoinedEventDto(this.channelId);
}

/// Data associated with `channelLeft` event,
/// when a member other than the user joins a channel.
class ChannelUserJoinedEventDto {
  final BigInt channelId;
  final BigInt userId;
  ChannelUserJoinedEventDto(this.channelId, this.userId);
}

/// Data associated with `channelMetadata` event,
/// when the channel's metadata is updated.
class ChannelMetadataEventDto {
  final BigInt channelId;
  final String name;
  final List<BigInt> members;
  ChannelMetadataEventDto(this.channelId, this.name, this.members);
}

/// Data associated with `channelLeave` event.
class ChannelUserLeftEventDto {
  final BigInt channelId;
  final BigInt userId;
  ChannelUserLeftEventDto(this.channelId, this.userId);
}

/// Data associated with `incomingFriendRequest` event.
class IncomingFriendRequestEventDto {
  final BigInt userId;
  IncomingFriendRequestEventDto(this.userId);
}

/// Data associated with `friendRequestAccepted` event.
class AcceptedFriendRequestEventDto {
  final BigInt userId;
  AcceptedFriendRequestEventDto(this.userId);
}

/// Data associated with `friendRequestRejected` event.
class RejectedFriendRequestEventDto {
  final BigInt userId;
  RejectedFriendRequestEventDto(this.userId);
}

/// Data associated with `friendRemoved` event.
class FriendRemovedEventDto {
  final BigInt userId;
  FriendRemovedEventDto(this.userId);
}

/// Data associated with `blocked` event.
class BlockedEventDto {
  final BigInt userId;
  BlockedEventDto(this.userId);
}

/// Data associated with `message` event.
class MessageEventDto {
  final BigInt channelId;
  final BigInt messageId;
  final BigInt authorId;
  final String content;
  final BigInt? replyTo;
  MessageEventDto(this.channelId, this.messageId, this.authorId, this.content, this.replyTo);
}

/// Data associated with `messageEdited` event.
class MessageEditedEventDto {
  final BigInt messageId;
  final String content;
  final BigInt? when;
  MessageEditedEventDto(this.messageId, this.content, this.when);
}

/// Data associated with `messageDeleted` event.
class MessageDeletedEventDto {
  final BigInt messageId;
  MessageDeletedEventDto(this.messageId);
}

/// Data associated with `typing` event.
class TypingEventDto {
  final BigInt userId;
  TypingEventDto(this.userId);
}

/// Data associated with `typingStopped` event.
class TypingStoppedEventDto {
  final BigInt userId;
  TypingStoppedEventDto(this.userId);
}