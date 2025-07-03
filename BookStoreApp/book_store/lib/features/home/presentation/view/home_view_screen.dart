import 'package:book_store/features/home/domain/entity/book.dart';
import 'package:book_store/features/home/widgets/book_cart.dart';
import 'package:book_store/features/home/widgets/filter_chip_list.dart';
import 'package:book_store/features/home/widgets/location_tile.dart';
import 'package:book_store/features/home/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Book> books = [
      Book(
        title: "Harry Potter",
        author: "J.K. Rowling",
        image: "- assets/images/harry.png",
        price: "300",
        publisher: "Scholastic Corporation",
        pages: "1300",
        genre: "Fantasy",
      ),
      Book(
        title: "The Art Of Fairy Tale",
        author: "Susan Redington Bobby",
        image: "- assets/images/fairy.png",
        price: "250",
        publisher: " Wayne State University Press",
        pages: "900",
        genre: "Fairy Tales",
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LocationTile(),
                const SizedBox(height: 16),
                const HomeSearchBar(),
                const SizedBox(height: 14),
                const Text(
                  "Vehicle Type",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                const FilterChipList(),
                const SizedBox(height: 14),
                ...books.map((v) => BookCard(book: v)).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
