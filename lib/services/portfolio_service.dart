import 'package:vivek_yadav/models/experience.dart';
import 'package:vivek_yadav/models/skill.dart';
import 'package:vivek_yadav/models/project.dart';
import 'package:vivek_yadav/models/speaking_topic.dart';

class PortfolioService {
  static const String name = 'Vivek Yadav';
  static const String title = 'Flutter Architect & Google Developer Expert for Flutter and Dart';
  static const String currentPosition = 'Enterprise Solutions Architect at FlutterFlow';
  static const String location = 'Mumbai, Maharashtra, India';
  static const String email = 'viveky259259@gmail.com';
  static const String phone = '+91 7021 730 766';

  static const Map<String, String> socialLinks = {
    'linkedin': 'https://www.linkedin.com/in/viveky259/',
    'twitter': 'https://twitter.com/viveky259259',
    'github': 'https://github.com/viveky259259',
    'medium': 'https://medium.com/@viveky259259',
    'sessionize': 'https://sessionize.com/viveky259/',
    'youtube': 'https://www.youtube.com/c/PROCoaches',
  };

  static const String summary = 
      'Google Developer Expert for Flutter and Dart with over 8 years of experience in mobile development. '
      'Led teams of 20+ people, built apps with 20M+ downloads, and mentored 50+ startups. '
      'Passionate about EdTech, community leadership, and delivering high-impact mobile solutions for enterprises and startups.';

  static const Map<String, String> keyStats = {
    'Total Experience': '8+ years',
    'Flutter Expertise': '7+ years',
    'Combined Downloads': '20M+',
    'Team Leadership': '20+ people',
    'Startups Mentored': '50+',
    'ZestMoney App': '6M+ downloads',
  };

  static List<Experience> getExperiences() {
    return [
      const Experience(
        company: 'FlutterFlow',
        position: 'Enterprise Solutions Architect',
        duration: 'Sept 2024 - Current',
        location: 'Remote',
        description: 'Working as an Enterprise Solutions Architect, leveraging deep Flutter and mobile expertise to deliver enterprise solutions.',
        achievements: [
          'Facilitating FlutterFlow development programs at major enterprises',
          'Building enterprise-grade solutions for complex business requirements',
          'Leading technical strategy for large-scale implementations',
        ],
        isCurrent: true,
      ),
      const Experience(
        company: 'Tata Digital (Tata Neu)',
        position: 'Dev Lead / Mobile Dev Lead',
        duration: 'May 2023 - Sept 2024',
        location: 'Mumbai',
        description: 'Leading App Core team for India\'s major super-app with millions of users.',
        achievements: [
          'Improved app loading time and reduced build size drastically',
          'Added core features to power other app features',
          'Working on consumer websites with millions of users',
          'Optimizing Flutter Web for thousands of products and hundreds of brands',
        ],
      ),
      const Experience(
        company: 'ZestMoney',
        position: 'Mobile Team Lead (SDE III)',
        duration: 'April 2021 - May 2023',
        location: 'Bengaluru',
        description: 'Led Mobile app development team of 20 people across 5 pods, achieving 6M+ downloads.',
        achievements: [
          'Built and released iOS application in Flutter (1M+ downloads)',
          'Migrated Android app from native to Flutter (5M+ downloads)',
          'Led migration with team of 13 developers in just 4 months',
          'Built 10+ packages and plugins used internally',
          'Built the 100ms Flutter plugin used by many businesses',
        ],
      ),
      const Experience(
        company: 'HighLevel',
        position: 'Senior Flutter Developer',
        duration: 'September 2020 - April 2021',
        location: 'USA (Remote)',
        description: 'Improved app performance dramatically and scaled for 250K+ users.',
        achievements: [
          'Improved app\'s performance by 70% and App Rating by 30%',
          'Scaled app for 250K+ users',
          'Newly developed app played key role in company\'s growth',
          'Refactored app with new state management and architecture',
        ],
      ),
      const Experience(
        company: 'RIREV',
        position: 'Full Stack Developer',
        duration: 'December 2019 - September 2020',
        location: 'Mumbai',
        description: 'Delivered multiple client Flutter apps with significant performance improvements.',
        achievements: [
          'Worked and released 3 client Flutter apps',
          'Improved client app performance by 150% and reduced app size by 30%',
          'Scaled app from 0 to 20K+ users',
          'Led scrum meetings and release planning',
        ],
      ),
      const Experience(
        company: 'ICICI Lombard',
        position: 'Flutter Developer (Contract)',
        duration: 'May 2019 - December 2019',
        location: 'Mumbai',
        description: 'Single-handedly converted existing application to Flutter in record time.',
        achievements: [
          'Converted existing application to Flutter in 3 months single-handedly',
          'Participated in active development of Android app',
          'Delivered high-quality enterprise solution',
        ],
      ),
      const Experience(
        company: 'Fitphilia',
        position: 'Full Stack Developer',
        duration: 'November 2017 - May 2019',
        location: 'Mumbai',
        description: 'Early career focused on Android development and R&D leadership.',
        achievements: [
          'Worked on 40+ Android (Kotlin + Java) applications for mobile and tablet',
          'Developed and released 15 Android applications single-handedly',
          'Led the Research and Development team',
        ],
      ),
    ];
  }

  static List<Skill> getSkills() {
    return [
      const Skill(name: 'Flutter', category: SkillCategory.primary, proficiencyLevel: 5, description: '5+ years expertise'),
      const Skill(name: 'Dart', category: SkillCategory.primary, proficiencyLevel: 5),
      const Skill(name: 'Android (Kotlin + Java)', category: SkillCategory.primary, proficiencyLevel: 5, description: '7+ years'),
      const Skill(name: 'iOS', category: SkillCategory.primary, proficiencyLevel: 4),
      const Skill(name: 'Node.js', category: SkillCategory.backend, proficiencyLevel: 4),
      const Skill(name: 'Firebase', category: SkillCategory.backend, proficiencyLevel: 4),
      const Skill(name: 'Hasura', category: SkillCategory.backend, proficiencyLevel: 3),
      const Skill(name: 'Cross-platform development', category: SkillCategory.specialization, proficiencyLevel: 5),
      const Skill(name: 'App architecture and scalability', category: SkillCategory.specialization, proficiencyLevel: 5),
      const Skill(name: 'Performance optimization', category: SkillCategory.specialization, proficiencyLevel: 5),
      const Skill(name: 'State management (BLoC, Provider)', category: SkillCategory.specialization, proficiencyLevel: 5),
      const Skill(name: 'Package and plugin development', category: SkillCategory.specialization, proficiencyLevel: 5),
      const Skill(name: 'Flutter Web optimization', category: SkillCategory.specialization, proficiencyLevel: 4),
      const Skill(name: 'Leadership', category: SkillCategory.nonTechnical, proficiencyLevel: 5),
      const Skill(name: 'Team Management', category: SkillCategory.nonTechnical, proficiencyLevel: 5),
      const Skill(name: 'Public Speaking', category: SkillCategory.nonTechnical, proficiencyLevel: 5),
      const Skill(name: 'Technical Writing', category: SkillCategory.nonTechnical, proficiencyLevel: 4),
      const Skill(name: 'Mentorship', category: SkillCategory.nonTechnical, proficiencyLevel: 5),
      const Skill(name: 'Community Building', category: SkillCategory.nonTechnical, proficiencyLevel: 5),
    ];
  }

  static List<Project> getProjects() {
    return [
      const Project(
        title: 'ZestMoney Mobile App',
        description: 'Led migration of 6M+ download financial app from native to Flutter',
        impact: '6M+ downloads, 4-month migration with 13 developers',
        technologies: ['Flutter', 'Dart', 'Native Android', 'iOS'],
        isFeatured: true,
      ),
      const Project(
        title: 'Tata Neu Core Features',
        description: 'Leading core app development for India\'s major super-app',
        impact: 'Millions of users, optimized performance and build size',
        technologies: ['Flutter', 'Flutter Web', 'Performance Optimization'],
        isFeatured: true,
      ),
      const Project(
        title: '100ms Flutter Plugin',
        description: 'Built Flutter plugin for video solutions used by businesses',
        impact: 'Used by multiple businesses for video conferencing',
        technologies: ['Flutter', 'Plugin Development', 'Native Integration'],
        githubUrl: 'https://github.com/100mslive/100ms-flutter',
        isFeatured: true,
      ),
      const Project(
        title: 'HighLevel Mobile App',
        description: 'Improved app performance by 70% and rating by 30%',
        impact: '250K+ users, key role in company growth',
        technologies: ['Flutter', 'Performance Optimization', 'State Management'],
        isFeatured: true,
      ),
      const Project(
        title: 'Enterprise Flutter Packages',
        description: 'Built 10+ internal packages and plugins for enterprise use',
        impact: 'Improved development efficiency across multiple teams',
        technologies: ['Flutter', 'Package Development', 'Architecture'],
      ),
      const Project(
        title: '20M+ Download Apps',
        description: 'Published apps achieving over 20 million downloads combined',
        impact: '20M+ downloads across AppStore and PlayStore',
        technologies: ['Flutter', 'Native Android', 'iOS'],
        isFeatured: true,
      ),
    ];
  }

  static List<SpeakingTopic> getSpeakingTopics() {
    return [
      const SpeakingTopic(
        title: 'Understanding Mobile Lifecycle',
        description: 'Deep dive into application lifecycle across different operating systems and best practices for lifecycle-aware applications.',
        keyPoints: ['Application lifecycle patterns', 'OS-specific implementations', 'Performance optimization', 'Best practices'],
        difficulty: 'Intermediate',
        estimatedDuration: 45,
      ),
      const SpeakingTopic(
        title: 'How to Scale Flutter Web',
        description: 'Optimization strategies for consumer websites with millions of users, security, and deployment.',
        keyPoints: ['Performance optimization', 'Security strategies', 'Deployment best practices', 'Real-world examples'],
        difficulty: 'Advanced',
        estimatedDuration: 60,
      ),
      const SpeakingTopic(
        title: 'State Management in Flutter',
        description: 'Comprehensive guide to BLoC pattern and alternatives for different use cases.',
        keyPoints: ['BLoC pattern deep dive', 'Provider alternatives', 'When to use different solutions', 'Performance considerations'],
        difficulty: 'Intermediate',
        estimatedDuration: 45,
      ),
      const SpeakingTopic(
        title: 'Building Packages and Plugins',
        description: 'Scalable plugin development with best practices and real-world production examples.',
        keyPoints: ['Plugin architecture', 'Best practices', 'Testing strategies', 'Publishing and maintenance'],
        difficulty: 'Advanced',
        estimatedDuration: 60,
      ),
      const SpeakingTopic(
        title: 'Migrating Native Apps to Flutter',
        description: 'Real experiences from migrating 6M+ download apps with practical insights.',
        keyPoints: ['Migration strategies', 'Time and resource estimation', 'Team management', 'Risk mitigation'],
        difficulty: 'Advanced',
        estimatedDuration: 50,
      ),
      const SpeakingTopic(
        title: 'Flutter App Performance Optimization',
        description: 'Using Flutter DevTools and real-world optimization strategies.',
        keyPoints: ['DevTools usage', 'Performance monitoring', 'Optimization techniques', 'Case studies'],
        difficulty: 'Intermediate',
        estimatedDuration: 45,
      ),
      const SpeakingTopic(
        title: 'Platform Views in Flutter',
        description: 'Converting platform views to Flutter widgets with live coding demonstrations.',
        keyPoints: ['Platform view concepts', 'Integration techniques', 'Performance considerations', 'Live coding'],
        difficulty: 'Advanced',
        estimatedDuration: 60,
      ),
    ];
  }

  static List<ConferenceAppearance> getConferenceAppearances() {
    return [
      const ConferenceAppearance(name: 'DevFest Mumbai', year: '2022', location: 'Mumbai, India'),
      const ConferenceAppearance(name: 'DevFest Indore', year: '2022', location: 'Indore, India'),
      const ConferenceAppearance(name: 'DevFest Chennai', year: '2022', location: 'Chennai, India'),
      const ConferenceAppearance(name: 'DevFest Lucknow', year: '2022', location: 'Lucknow, India'),
      const ConferenceAppearance(name: 'DevFest New Delhi', year: '2022', location: 'New Delhi, India'),
      const ConferenceAppearance(name: 'Great North DevFest', year: '2022', location: 'UK'),
      const ConferenceAppearance(name: 'Flutter Conference India', year: '2021-2023', location: 'India'),
      const ConferenceAppearance(name: 'Flutter Forward Extended Mumbai', year: '2023', location: 'Mumbai, India'),
      const ConferenceAppearance(name: 'GDG San Jose Flutter Festival', year: '2022', location: 'San Jose, USA'),
      const ConferenceAppearance(name: 'Flutter Global Summit', year: '2021-2022', location: 'Virtual'),
    ];
  }

  static List<String> getAwards() {
    return [
      'Google Developer Expert in Flutter and Dart (2021 - Current)',
      'ICICI Lombard Hack 2020 - Winner',
      'International Flutter Hack 2019 - Winner',
    ];
  }

  static Map<String, String> getCommunityRoles() {
    return {
      'Flutter India': 'Organizer (May 2020 - 2024)',
      'Flutter Mumbai': 'Organizer (December 2019 - Present)',
      'Google For Startups': 'Mentor (2021 - Current)',
      'ASA Program': 'Mentor (2021 - Current)',
      'Google Accelerator': 'Mentor (2021 - Current)',
    };
  }
}