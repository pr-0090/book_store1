import 'package:book_store/botton_navigation/home.dart';
import 'package:book_store/botton_navigation/new.dart';
import 'package:book_store/botton_navigation/profile.dart';
import 'package:book_store/botton_navigation/sale.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Home(),
    const Sale(),
    const New(),
    const Profile(),
  ];

  final Duration _animationDuration = const Duration(milliseconds: 300);

  final List<Map<String, dynamic>> _navItems = [
    {
      'icon': FontAwesomeIcons.house,
      'iconSolid': FontAwesomeIcons.house,
      'label': 'Home',
    },
    {
      'icon': FontAwesomeIcons.calendar,
      'iconSolid': FontAwesomeIcons.solidCalendar,
      'label': 'New',
    },
    {
      'icon': FontAwesomeIcons.bell,
      'iconSolid': FontAwesomeIcons.solidBell,
      'label': 'Sale',
    },
    {
      'icon': FontAwesomeIcons.user,
      'iconSolid': FontAwesomeIcons.solidUser,
      'label': 'Profile',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Colors.blue.shade700;
    final Color unselectedColor = Colors.grey.shade500;

    return Scaffold(
      extendBody: true, // For curved nav to blend nicely
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildCurvedNavigationBar(
        selectedColor,
        unselectedColor,
      ),
    );
  }

  Widget _buildCurvedNavigationBar(Color selectedColor, Color unselectedColor) {
    return ClipPath(
      clipper: CurvedNavBarClipper(),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_navItems.length, (index) {
            bool isSelected = index == _selectedIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              behavior: HitTestBehavior.translucent,
              child: AnimatedContainer(
                duration: _animationDuration,
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 20 : 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedColor.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    AnimatedScale(
                      scale: isSelected ? 1.3 : 1.0,
                      duration: _animationDuration,
                      child: FaIcon(
                        isSelected
                            ? _navItems[index]['iconSolid']
                            : _navItems[index]['icon'],
                        color: isSelected ? selectedColor : unselectedColor,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: isSelected ? 8 : 0),
                    AnimatedSize(
                      duration: _animationDuration,
                      curve: Curves.easeInOut,
                      child: isSelected
                          ? Text(
                              _navItems[index]['label'],
                              style: TextStyle(
                                color: selectedColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class CurvedNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, height - 20);

    // Curve middle bump for selected effect
    path.quadraticBezierTo(width * 0.25, height, width * 0.5, height - 20);
    path.quadraticBezierTo(width * 0.75, height - 60, width, height - 20);

    path.lineTo(width, height - 20);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
