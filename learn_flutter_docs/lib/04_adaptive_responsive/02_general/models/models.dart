class Attachment {
  final String url;
  const Attachment({required this.url});
}

class Email {
  final User sender;
  final List<User> recipients;
  final String subject;
  final String content;
  final List<Attachment> attachments;
  final double replies;

  const Email({
    required this.sender,
    required this.recipients,
    required this.subject,
    required this.content,
    this.replies = 0,
    this.attachments = const [],
  });
}

class Name {
  final String first;
  final String last;
  String get fullName => '$first $last';

  const Name({required this.first, required this.last});
}

class User {
  final Name name;
  final String avatarUrl;
  final DateTime lastActive;

  const User({
    required this.name,
    required this.avatarUrl,
    required this.lastActive,
  });
}
