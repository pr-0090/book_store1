import 'package:flutter/material.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreen();
}

class _NewScreen extends State<NewScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('News'));
  }
}
