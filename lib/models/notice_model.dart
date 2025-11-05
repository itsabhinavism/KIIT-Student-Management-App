class Notice {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String type; // 'notice' or 'event'
  final String scope; // 'global' or 'section'
  final String? sectionId;
  final String? registrationLink;
  final DateTime createdAt;

  Notice({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.type,
    required this.scope,
    this.sectionId,
    this.registrationLink,
    required this.createdAt,
  });

  bool get isEvent => type == 'event';
  bool get isGlobal => scope == 'global';

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      type: json['type'] ?? 'notice',
      scope: json['scope'] ?? 'global',
      sectionId: json['section_id'],
      registrationLink: json['registration_link'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'type': type,
      'scope': scope,
      'section_id': sectionId,
      'registration_link': registrationLink,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
