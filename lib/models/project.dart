class Project {
  final String title;
  final String description;
  final String impact;
  final List<String> technologies;
  final String? githubUrl;
  final String? liveUrl;
  final String? imageUrl;
  final bool isFeatured;

  const Project({
    required this.title,
    required this.description,
    required this.impact,
    required this.technologies,
    this.githubUrl,
    this.liveUrl,
    this.imageUrl,
    this.isFeatured = false,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'] as String,
      description: json['description'] as String,
      impact: json['impact'] as String,
      technologies: List<String>.from(json['technologies'] as List),
      githubUrl: json['githubUrl'] as String?,
      liveUrl: json['liveUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'impact': impact,
      'technologies': technologies,
      'githubUrl': githubUrl,
      'liveUrl': liveUrl,
      'imageUrl': imageUrl,
      'isFeatured': isFeatured,
    };
  }

  Project copyWith({
    String? title,
    String? description,
    String? impact,
    List<String>? technologies,
    String? githubUrl,
    String? liveUrl,
    String? imageUrl,
    bool? isFeatured,
  }) {
    return Project(
      title: title ?? this.title,
      description: description ?? this.description,
      impact: impact ?? this.impact,
      technologies: technologies ?? this.technologies,
      githubUrl: githubUrl ?? this.githubUrl,
      liveUrl: liveUrl ?? this.liveUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}