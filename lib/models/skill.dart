enum SkillCategory {
  primary,
  backend,
  specialization,
  nonTechnical,
}

class Skill {
  final String name;
  final SkillCategory category;
  final int proficiencyLevel; // 1-5 scale
  final String? description;

  const Skill({
    required this.name,
    required this.category,
    required this.proficiencyLevel,
    this.description,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] as String,
      category: SkillCategory.values.byName(json['category'] as String),
      proficiencyLevel: json['proficiencyLevel'] as int,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category.name,
      'proficiencyLevel': proficiencyLevel,
      'description': description,
    };
  }

  Skill copyWith({
    String? name,
    SkillCategory? category,
    int? proficiencyLevel,
    String? description,
  }) {
    return Skill(
      name: name ?? this.name,
      category: category ?? this.category,
      proficiencyLevel: proficiencyLevel ?? this.proficiencyLevel,
      description: description ?? this.description,
    );
  }
}