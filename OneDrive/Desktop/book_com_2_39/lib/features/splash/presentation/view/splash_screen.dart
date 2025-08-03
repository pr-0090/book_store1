import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/common/internet_checker/internet_checker.dart';
import '../../../../core/network/hive_service.dart';
import '../../../../app/shared_prefs/shared_prefs_service.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../onboarding/presentation/view/onboarding_screen.dart';
import '../../../home/presentation/view/home_screen.dart';
import '../../../auth/presentation/view/login_screen.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;
  bool _backendConnected = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    // Fade animation for content
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    // Loading animation (subtle rotation)
    _loadingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.linear,
    ));
    
    _animationController.forward();
    _loadingController.repeat();
    
    // Test backend connection
    _testBackendConnection();
    
    // Check login status and navigate accordingly after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _checkLoginStatusAndNavigate();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  Future<void> _testBackendConnection() async {
    try {
      final hasInternet = await InternetChecker().hasInternetConnection();
      if (hasInternet) {
        final backendConnected = await InternetChecker().testBackendConnection();
        if (mounted) {
          setState(() {
            _backendConnected = backendConnected;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _backendConnected = false;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _backendConnected = false;
          _isLoading = false;
        });
      }
    }
  }

  void _checkLoginStatusAndNavigate() async {
    // Check if onboarding is completed
    final onboardingCompleted = SharedPrefsService.isOnboardingCompleted();
    
    // Check if user is already logged in
    if (HiveService.isUserLoggedIn()) {
      // User is logged in, go to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else if (!onboardingCompleted) {
      // First time user, show onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    } else {
      // User has seen onboarding but not logged in, go to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea), // Cool blue
              Color(0xFF764ba2), // Purple
              Color(0xFFf093fb), // Soft pink
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.book,
                          size: 60,
                          color: Color(0xFF667eea),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                // App Name
                Text(
                  'Book.com',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                // Tagline
                Text(
                  'Your Digital Bookstore',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.h),
                // Loading Animation (subtle rotation)
                AnimatedBuilder(
                  animation: _loadingAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _loadingAnimation.value * 2 * 3.14159,
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 20.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),
                // Loading text
                Text(
                  _isLoading ? 'Connecting to backend...' : 
                  _backendConnected ? 'Backend connected!' : 'Connection failed',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: _isLoading ? Colors.white.withOpacity(0.8) :
                           _backendConnected ? Colors.green[100] : Colors.red[100],
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 