import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tadreeby/core/utils/secure_storage_service.dart';

import '../../../../core/theme/app_colors.dart';

// ============================================================
// DATA MODELS
// ============================================================

class OnboardingPage {
  final String title;
  final String titleHighlight;
  final bool highlightAtEnd;
  final String description;
  final Widget illustration;

  const OnboardingPage({
    required this.title,
    required this.titleHighlight,
    required this.description,
    required this.illustration,
    this.highlightAtEnd = true,
  });
}

enum _FeaturePosition {
  topLeft,
  topRight,
  middleLeft,
  middleRight,
  bottomLeft,
  bottomCenter,
}

class _FeatureItem {
  final String assetPath;
  final String label;
  final _FeaturePosition position;

  const _FeatureItem({
    required this.assetPath,
    required this.label,
    required this.position,
  });
}

// ============================================================
// MAIN ONBOARDING SCREEN
// ============================================================

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;


  late final List<OnboardingPage> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      // ==========================================================
      //  1: page Welcome
      // ==========================================================
      OnboardingPage(
        title: 'Welcome to',
        titleHighlight: 'Tadreeby',
        description: 'Discover internship opportunities, track your progress, and communicate with supervisors in one place.',
        illustration: const _WelcomeIllustration(),
        highlightAtEnd: true,
      ),

      // ==========================================================
      //  2: page Internship Lifecycle Management 
      // ==========================================================
      OnboardingPage(
        title: 'Internship Lifecycle Management',
        titleHighlight: '',
        description: 'Manage your internship journey from application to final report submission, including progress tracking and assigned tasks.',
        illustration: _FeatureIllustration(
          centerLabel: 'Tadreeby\nfor Companies',
          phoneImagePath: 'assets/images/phone.png',
          features: const [
            _FeatureItem(
              assetPath: 'assets/icons/TrackAttendance.png',
              label: 'Track\nAttendance\n',
              position: _FeaturePosition.topLeft,
            ),
            _FeatureItem(
              assetPath: 'assets/icons/ManageTasks1.png',
              label: 'Manage\nTasks\n',
              position: _FeaturePosition.topRight,
            ),
            _FeatureItem(
              assetPath: 'assets/icons/SubmitReports.png',
              label: 'Submit\nReports\n',
              position: _FeaturePosition.middleLeft,
            ),
            _FeatureItem(
              assetPath: 'assets/icons/FindOpportunities.png',
              label: 'Find\nOpportunities\n',
              position: _FeaturePosition.middleRight,
            ),
            _FeatureItem(
              assetPath: 'assets/icons/SmartAI.png',
              label: 'Smart\nAI\n',
              position: _FeaturePosition.bottomCenter,
            ),
          ],
        ),
        highlightAtEnd: true,
      ),

      // ==========================================================
      //  3: page Internship Hosting & Evaluation 
      // ==========================================================
      OnboardingPage(
        title: 'Internship Hosting & Evaluation',
        titleHighlight: '',
        description: 'Manage internship opportunities, assign tasks, track student performance, and evaluate reports.',
        illustration: _FeatureIllustration(
          centerLabel: 'Tadreeby\nfor Companies',
          phoneImagePath: 'assets/images/phone.png',
          features: const [
            _FeatureItem(
              assetPath: 'assets/icons/CreatenOpportunities.png',
              label: 'Create\nOpportunities\n',
              position: _FeaturePosition.topLeft,
            ),
            _FeatureItem(
              assetPath: 'assets/icons/StudentnEvaluation.png',
              label: 'Student\nEvaluation\n',
              position: _FeaturePosition.topRight,
            ),
            _FeatureItem(
              assetPath: 'assets/icons/Mentoring.png',
              label: 'Mentoring',
              position: _FeaturePosition.bottomLeft,
            ),
            _FeatureItem(
              assetPath: 'assets/icons/ActivityFeednChat.png',
              label: 'Activity Feed\n& Chat\n',
              position: _FeaturePosition.middleRight,
            ),
            _FeatureItem(
              assetPath: 'assets/icons/PerformancenAnalytics.png',
              label: 'Performance\nAnalytics\n',
              position: _FeaturePosition.middleLeft,
            ),
            _FeatureItem(
              assetPath: 'assets/icons/SmartAI.png',
              label: 'Smart\nAI\n',
              position: _FeaturePosition.bottomCenter,
            ),
          ],
        ),
        highlightAtEnd: true,
      ),

      // ==========================================================
      //  4: page Internship Academic Supervision 
      // ==========================================================
      OnboardingPage(
        title: 'Internship Academic Supervision',
        titleHighlight: '',
        description: 'Monitor student internships, assign academic supervisors, track progress, and evaluate final reports in coordination with companies.',
        illustration: _FeatureIllustration(
          centerLabel: 'Tadreeby\nfor Universities',
          phoneImagePath: 'assets/images/phone.png',
          features: const [
            _FeatureItem(
              assetPath: 'assets/icons/ManagenStudents.png',
              label: 'Manage\nStudents\n',
              position: _FeaturePosition.topLeft,
            ),
            _FeatureItem(
              assetPath: 'assets/icons/CompanynCollaboration.png',
              label: 'Company\nCollaboration\n',
              position: _FeaturePosition.topRight,
            ),
            _FeatureItem(
              assetPath: 'assets/icons/PlacementManagement.png',
              label: 'Placement\nManagement\n',
              position: _FeaturePosition.bottomLeft,
            ),
            _FeatureItem(
              assetPath: 'assets/icons/AnnouncementsCommunication.png',
              label: 'Announcements\n& Communication',
              position: _FeaturePosition.middleRight,
            ),
            _FeatureItem(
              assetPath: 'assets/icons/PerformancenAnalytics.png',
              label: 'Performance\nInsights\n',
              position: _FeaturePosition.middleLeft,
            ),
            _FeatureItem(
              assetPath: 'assets/icons/SmartAI.png',
              label: 'Smart\nAI\n',
              position: _FeaturePosition.bottomCenter,
            ),
          ],
        ),
        highlightAtEnd: true,
      ),

      // ==========================================================
      //  5: page Important Information
      // ==========================================================
      OnboardingPage(
        title: 'Important ',
        titleHighlight: 'Information',
        description: '',
        illustration: const _ImportantInfoIllustration(),
        highlightAtEnd: true,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

   void _finishOnboarding() async {
    try {
      final storage = SecureStorageService();
      await storage.setHasSeenOnboarding();
      print(' Onboarding marked as seen');
    } catch (e) {
      print(' Error saving onboarding status: $e');
    }
    
    if (mounted) {
      context.go('/login');
    }
  }

  void _skip() {
    _finishOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    GestureDetector(
                      onTap: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.chevron_left, color: AppColors.textDark, size: 20),
                          Text('Back', style: TextStyle(color: AppColors.textDark, fontSize: 15, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  else
                    const SizedBox(width: 60),
                  GestureDetector(
                    onTap: _skip,
                    child: const Text('Skip', style: TextStyle(color: AppColors.textDark, fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index], index);
                },
              ),
            ),

            // Dots Indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _currentPage ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _currentPage ? AppColors.blue : const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: Text(
                    isLastPage ? 'Continue to Login' : 'Next',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, int index) {
    if (index == 0) return _buildWelcomePage(page);
    if (index == _pages.length - 1) return _buildImportantInfoPage(page);
    return _buildFeaturePage(page);
  }

  Widget _buildWelcomePage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const _TadreebyLogo(),
          const SizedBox(height: 24),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
              children: [
                TextSpan(text: 'Welcome to '),
                TextSpan(text: 'Tadreeby', style: TextStyle(color: AppColors.blue)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppColors.textGrey, height: 1.6),
          ),
          const SizedBox(height: 24),
          Expanded(child: page.illustration),
        ],
      ),
    );
  }

  Widget _buildFeaturePage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Expanded(flex: 2, child: page.illustration),
          const SizedBox(height: 4),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textGrey,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildImportantInfoPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
                children: [
                  TextSpan(text: 'Important '),
                  TextSpan(text: 'Information', style: TextStyle(color: AppColors.blue)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 4,
            child: Image.asset(
              'assets/images/onboarding_important_info.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 20, offset: const Offset(0, 4))],
            ),
            child: const Column(
              children: [
                _InfoRow(icon: Icons.person_outline, text: 'Tadreeby connects students, universities, and companies in one integrated platform to simplify internship management, communication, and performance tracking.'),
                Divider(height: 24, color: Color(0xFFE5E7EB)),
                _InfoRow(icon: Icons.business_outlined, text: 'Universities and companies seeking collaboration must register through the Tadreeby administration.'),
              ],
            ),
          ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }
}

// ============================================================
// FEATURE CARD
// ============================================================

class _FeatureCard extends StatefulWidget {
  final String assetPath;
  final String label;

  const _FeatureCard({required this.assetPath, required this.label});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIcon() {
    final path = widget.assetPath;
    if (path.endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: 60,
        height: 60,
        colorFilter: const ColorFilter.mode(
          Color(0xFF2563EB),
          BlendMode.srcIn,
        ),
        placeholderBuilder: (_) => const SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        errorBuilder: (_, __, ___) => const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 40,
        ),
      );
    } else {
      return Image.asset(
        path,
        width: 60,
        height: 60,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.image_outlined,
          color: Color(0xFF2563EB),
          size: 49,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          width: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildIcon(),
              ),
              const SizedBox(height: 1),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// FEATURE ILLUSTRATION
// ============================================================

class _FeatureIllustration extends StatelessWidget {
  final String centerLabel;
  final List<_FeatureItem> features;
  final String? phoneImagePath;

  const _FeatureIllustration({
    required this.centerLabel,
    required this.features,
    this.phoneImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final cx = w / 2;
        final cy = h / 2;

        final imageWidth = w * 1;
        final imageHeight = h * 1;
        final double horizontalMargin = imageWidth * 0.35;
        final double verticalMargin = imageHeight * 0.38;

        Map<_FeaturePosition, Offset> positions = {
          _FeaturePosition.topLeft: Offset(
            cx - horizontalMargin - -5,
            cy - verticalMargin - -99,
          ),
          _FeaturePosition.topRight: Offset(
            cx + horizontalMargin - 90,
            cy - verticalMargin - -99
          ),
          _FeaturePosition.middleLeft: Offset(
            cx - horizontalMargin - -10,
            cy - imageHeight * -0.05
          ),
          _FeaturePosition.middleRight: Offset(
            cx + horizontalMargin - 80,
            cy - imageHeight * -0.05
          ),
          _FeaturePosition.bottomLeft: Offset(
            cx - horizontalMargin - -104,
            cy + verticalMargin - 450
          ),
          _FeaturePosition.bottomCenter: Offset(
            cx - imageWidth * 0.09,
            cy + verticalMargin + -90
          ),
        };
        
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: phoneImagePath != null
                    ? Image.asset(
                        phoneImagePath!,
                        width: imageWidth,
                        height: imageHeight,
                        fit: BoxFit.contain,
                      )
                    : Container(
                        width: imageWidth,
                        height: imageHeight,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                       
                      ),
              ),

              Positioned(
                right: w * -0.09,
                bottom: h * 0.14,
                child: Image.asset(
                  'assets/images/leaf.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),


              for (final feature in features)
                if (positions.containsKey(feature.position))
                  Positioned(
                    left: positions[feature.position]!.dx,
                    top: positions[feature.position]!.dy,
                    child: _FeatureCard(
                      assetPath: feature.assetPath,
                      label: feature.label,
                    ),
                  ),
                  
            
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// OTHER WIDGETS
// ============================================================

class _ImportantInfoIllustration extends StatelessWidget {
  const _ImportantInfoIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/onboarding_important_info.png',  
        fit: BoxFit.contain,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF2563EB), size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF374151),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _TadreebyLogo extends StatelessWidget {
  const _TadreebyLogo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/Asset1.png',
      height: 45,
      fit: BoxFit.contain,
    );
  }
}

class _WelcomeIllustration extends StatelessWidget {
  const _WelcomeIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/onboarding_welcome.png',
        fit: BoxFit.contain,
      ),
    );
  }
}