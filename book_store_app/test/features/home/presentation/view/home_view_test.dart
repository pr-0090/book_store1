import 'package:bloc_test/bloc_test.dart';
import 'package:book_store/features/home/domain/entity/book.dart';
import 'package:book_store/features/home/presentation/view/home_view.dart';
import 'package:book_store/features/home/presentation/view_model/book_state.dart';
import 'package:book_store/features/home/presentation/view_model/book_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookBloc extends Mock implements BookBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockBookBloc mockBookBloc;

  final testBooks = [
    const BookEntity(
      id: '1',
      title: 'The Great Gatsby',
      author: 'F. Scott Fitzgerald',
      genre: 'Fiction',
      publisher: 'Scribner',
      publicationYear: 1925,
      price: 899.99,
      coverImage: 'gatsby.jpg',
      description: 'A novel set in the Roaring Twenties.',
      pageCount: 218,
      weightGrams: 300.0,
    ),
    const BookEntity(
      id: '2',
      title: 'Clean Code',
      author: 'Robert C. Martin',
      genre: 'Programming',
      publisher: 'Prentice Hall',
      publicationYear: 2008,
      price: 1599.50,
      coverImage: 'cleancode.jpg',
      description: 'A handbook of agile software craftsmanship.',
      pageCount: 464,
      weightGrams: 600.0,
    ),
  ];

  group('HomeView Widget Tests', () {
    testWidgets('displays book cards with book names and Buy Now button', (
      tester,
    ) async {
      mockBookBloc = MockBookBloc();

      when(() => mockBookBloc.state).thenReturn(BookLoaded(testBooks));
      whenListen(
        mockBookBloc,
        Stream<BookState>.fromIterable([BookLoaded(testBooks)]),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BookBloc>.value(
            value: mockBookBloc,
            child: const HomeView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('The Great Gatsby'), findsOneWidget);
      expect(find.text('Clean Code'), findsOneWidget);
      expect(find.text('Buy Now'), findsNWidgets(testBooks.length));
    });

    testWidgets('shows loading indicator when state is BookLoading', (
      tester,
    ) async {
      mockBookBloc = MockBookBloc();
      when(() => mockBookBloc.state).thenReturn(BookLoading());
      whenListen(mockBookBloc, Stream<BookState>.fromIterable([BookLoading()]));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BookBloc>.value(
            value: mockBookBloc,
            child: const HomeView(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message on BookError state', (tester) async {
      const errorMessage = 'Failed to load books';

      mockBookBloc = MockBookBloc();
      when(() => mockBookBloc.state).thenReturn(BookError(errorMessage));
      whenListen(
        mockBookBloc,
        Stream<BookState>.fromIterable([BookError(errorMessage)]),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BookBloc>.value(
            value: mockBookBloc,
            child: const HomeView(),
          ),
        ),
      );

      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
