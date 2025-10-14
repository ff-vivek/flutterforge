class Experience {
  final String company;
  final String position;
  final String duration;
  final String location;
  final String description;
  final List<String> achievements;
  final bool isCurrent;

  const Experience({
    required this.company,
    required this.position,
    required this.duration,
    required this.location,
    required this.description,
    required this.achievements,
    this.isCurrent = false,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      company: json['company'] as String,
      position: json['position'] as String,
      duration: json['duration'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      achievements: List<String>.from(json['achievements'] as List),
      isCurrent: json['isCurrent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'position': position,
      'duration': duration,
      'location': location,
      'description': description,
      'achievements': achievements,
      'isCurrent': isCurrent,
    };
  }

  Experience copyWith({
    String? company,
    String? position,
    String? duration,
    String? location,
    String? description,
    List<String>? achievements,
    bool? isCurrent,
  }) {
    return Experience(
      company: company ?? this.company,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      location: location ?? this.location,
      description: description ?? this.description,
      achievements: achievements ?? this.achievements,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }
}