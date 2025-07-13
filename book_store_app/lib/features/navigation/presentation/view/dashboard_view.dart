import 'package:book_store/features/booking/presentation/view/booking_view.dart';
import 'package:book_store/features/home/presentation/view/home_view.dart';
import 'package:book_store/features/notification/presentation/view/notification_view.dart';
import 'package:book_store/features/profile/presentation/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeView(), // Now shows books
    const BookingView(), // Maybe used for book orders or reservations
    const NotificationsView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.house),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.calendar),
              label: 'Booking',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.bell),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.user),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
