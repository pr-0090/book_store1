import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../view_model/onboarding_view_model.dart';

class OnboardingSlide extends StatelessWidget {
  final OnboardingSlideData data;

  const OnboardingSlide({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 250.w,
            height: 200.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Background Image
                  Positioned.fill(
                    child: Image.asset(
                      data.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.white.withOpacity(0.1),
                          child: Icon(
                            data.icon,
                            size: 80,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        );
                      },
                    ),
                  ),
                  // Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 40.h),
          
          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Subtitle
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
} 