import 'package:flutter/material.dart';

class LocationTile extends StatelessWidget {
  const LocationTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Icon(Icons.location_on, color: Colors.grey, size: 26),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your location",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  "Gangabu, Kathmandu",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
        const CircleAvatar(
          radius: 21,
          backgroundColor: Colors.orangeAccent,
          child: Icon(Icons.person, size: 24, color: Colors.black),
        ),
      ],
    );
  }
}
