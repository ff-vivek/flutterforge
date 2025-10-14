class SpeakingTopic {
  final String title;
  final String description;
  final List<String> keyPoints;
  final String difficulty; // Beginner, Intermediate, Advanced
  final int estimatedDuration; // in minutes

  const SpeakingTopic({
    required this.title,
    required this.description,
    required this.keyPoints,
    required this.difficulty,
    required this.estimatedDuration,
  });

  factory SpeakingTopic.fromJson(Map<String, dynamic> json) {
    return SpeakingTopic(
      title: json['title'] as String,
      description: json['description'] as String,
      keyPoints: List<String>.from(json['keyPoints'] as List),
      difficulty: json['difficulty'] as String,
      estimatedDuration: json['estimatedDuration'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'keyPoints': keyPoints,
      'difficulty': difficulty,
      'estimatedDuration': estimatedDuration,
    };
  }

  SpeakingTopic copyWith({
    String? title,
    String? description,
    List<String>? keyPoints,
    String? difficulty,
    int? estimatedDuration,
  }) {
    return SpeakingTopic(
      title: title ?? this.title,
      description: description ?? this.description,
      keyPoints: keyPoints ?? this.keyPoints,
      difficulty: difficulty ?? this.difficulty,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
    );
  }
}

class ConferenceAppearance {
  final String name;
  final String year;
  final String location;
  final String? talkTitle;
  final String? url;

  const ConferenceAppearance({
    required this.name,
    required this.year,
    required this.location,
    this.talkTitle,
    this.url,
  });

  factory ConferenceAppearance.fromJson(Map<String, dynamic> json) {
    return ConferenceAppearance(
      name: json['name'] as String,
      year: json['year'] as String,
      location: json['location'] as String,
      talkTitle: json['talkTitle'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'year': year,
      'location': location,
      'talkTitle': talkTitle,
      'url': url,
    };
  }

  ConferenceAppearance copyWith({
    String? name,
    String? year,
    String? location,
    String? talkTitle,
    String? url,
  }) {
    return ConferenceAppearance(
      name: name ?? this.name,
      year: year ?? this.year,
      location: location ?? this.location,
      talkTitle: talkTitle ?? this.talkTitle,
      url: url ?? this.url,
    );
  }
}