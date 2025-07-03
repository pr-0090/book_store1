import 'package:flutter/material.dart';

class FilterChipList extends StatelessWidget {
  const FilterChipList({super.key});

  Widget _buildChip(String label, {bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: selected ? Colors.blueAccent : Colors.grey.shade200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip("All", selected: true),
          _buildChip("Car"),
          _buildChip("Truck"),
          _buildChip("Micro"),
        ],
      ),
    );
  }
}
