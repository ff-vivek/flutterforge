import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble, ImageFilter;
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivek_yadav/services/portfolio_service.dart';
import 'package:vivek_yadav/widgets/hero_section.dart';
import 'package:vivek_yadav/widgets/about_section.dart';
import 'package:vivek_yadav/widgets/experience_section.dart';
import 'package:vivek_yadav/widgets/skills_section.dart';
import 'package:vivek_yadav/widgets/speaking_section.dart';
import 'package:vivek_yadav/widgets/projects_section.dart';
import 'package:vivek_yadav/widgets/contact_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Section keys
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _speakingKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  // Tracks how far the user has scrolled from the top to blend the navbar color
  double _navBlendT = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset =
        _scrollController.hasClients ? _scrollController.offset : 0.0;
    const threshold = 240.0; // how quickly the bar becomes solid
    final t = (offset / threshold).clamp(0.0, 1.0);
    if ((t - _navBlendT).abs() > 0.01) {
      setState(() => _navBlendT = t);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) return;

    // Close drawer if open (for mobile)
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(this.context).pop();
    }

    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }

  Future<void> _openResume() async {
    final linkedin = PortfolioService.socialLinks['linkedin'];
    final linkedinUri = linkedin != null ? Uri.parse(linkedin) : null;

    // 2) Navigate user to LinkedIn (prefer in the same tab on web)
    if (linkedinUri != null && await canLaunchUrl(linkedinUri)) {
      await launchUrl(linkedinUri, mode: LaunchMode.platformDefault);
    }
  }

  Future<void> _openContactForm() async {
    final formUri = Uri.parse('https://forms.gle/wnAwr5pwEr6SWAdQ6');
    if (await canLaunchUrl(formUri)) {
      await launchUrl(formUri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    // Navbar color logic: match hero at top, morph to glassy black on scroll
    final heroTopColor = Color.lerp(
        theme.colorScheme.surface, theme.colorScheme.primaryContainer, 0.22)!;
    final glassBase = Color.lerp(
        theme.colorScheme.surface, theme.colorScheme.primaryContainer, 0.12)!;
    final targetGlassy = glassBase.withValues(alpha: 0.20);
    final navBgColor = Color.lerp(heroTopColor, targetGlassy, _navBlendT)!;
    final dividerAlpha = lerpDouble(0.00, 0.14, _navBlendT)!;

    return Scaffold(
      key: _scaffoldKey,
      drawer: !isDesktop ? _buildMobileDrawer(theme) : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: isDesktop ? Colors.transparent : navBgColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: !isDesktop
                ? IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  )
                : null,
            automaticallyImplyLeading: false,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: lerpDouble(0, 16, _navBlendT)!,
                  sigmaY: lerpDouble(0, 16, _navBlendT)!,
                ),
                child: Container(color: navBgColor),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                color:
                    theme.colorScheme.onSurface.withValues(alpha: dividerAlpha),
              ),
            ),
            title: isDesktop
                ? Row(
                    children: [
                      Image.asset(
                        'assets/icons/dreamflow_icon.jpg',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Vivek Yadav',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      _buildNavButton('About', () => _scrollTo(_aboutKey)),
                      const SizedBox(width: 20),
                      _buildNavButton(
                          'Experience', () => _scrollTo(_experienceKey)),
                      const SizedBox(width: 20),
                      _buildNavButton('Skills', () => _scrollTo(_skillsKey)),
                      const SizedBox(width: 20),
                      _buildNavButton(
                          'Speaking', () => _scrollTo(_speakingKey)),
                      const SizedBox(width: 20),
                      _buildNavButton(
                          'Projects', () => _scrollTo(_projectsKey)),
                      const SizedBox(width: 20),
                      _buildNavButton('Contact', () => _scrollTo(_contactKey)),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/dreamflow_icon.jpg',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Vivek Yadav',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
          ),
          SliverToBoxAdapter(
            child: HeroSection(
              onContactTap: _openContactForm,
              onDownloadResume: _openResume,
            ),
          ),
          SliverToBoxAdapter(child: AboutSection(key: _aboutKey)),
          SliverToBoxAdapter(child: ExperienceSection(key: _experienceKey)),
          SliverToBoxAdapter(child: SkillsSection(key: _skillsKey)),
          SliverToBoxAdapter(
            child: SpeakingSection(
              key: _speakingKey,
              onInviteToSpeak: () => _scrollTo(_contactKey),
            ),
          ),
          SliverToBoxAdapter(child: ProjectsSection(key: _projectsKey)),
          SliverToBoxAdapter(child: ContactSection(key: _contactKey)),
        ],
      ),
    );
  }

  Widget _buildNavButton(String label, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        overlayColor:
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      ),
      child: Text(label),
    );
  }

  Widget _buildMobileDrawer(ThemeData theme) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Drawer Header
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Image.asset('assets/icons/dreamflow_icon.jpg',
                        width: 60, height: 60),
                    const SizedBox(height: 12),
                    Text(
                      'Vivek Yadav',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Flutter Architect & GDE',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: theme.colorScheme.outline.withValues(alpha: 0.2)),

              // Navigation Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    _buildDrawerItem(Icons.person_outline, 'About',
                        () => _scrollTo(_aboutKey)),
                    _buildDrawerItem(Icons.work_outline, 'Experience',
                        () => _scrollTo(_experienceKey)),
                    _buildDrawerItem(
                        Icons.code, 'Skills', () => _scrollTo(_skillsKey)),
                    _buildDrawerItem(Icons.mic_outlined, 'Speaking',
                        () => _scrollTo(_speakingKey)),
                    _buildDrawerItem(Icons.folder_outlined, 'Projects',
                        () => _scrollTo(_projectsKey)),
                    _buildDrawerItem(Icons.contact_mail_outlined, 'Contact',
                        () => _scrollTo(_contactKey)),
                  ],
                ),
              ),

              // Footer Actions
              Divider(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _openContactForm();
                        },
                        icon: const Icon(Icons.mail_outline),
                        label: const Text('Get In Touch'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _openResume();
                        },
                        icon: const Icon(Icons.download_outlined),
                        label: const Text('Download Resume'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      onTap: onTap,
      horizontalTitleGap: 12,
    );
  }
}
