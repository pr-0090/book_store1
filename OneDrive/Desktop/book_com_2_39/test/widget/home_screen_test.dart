import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:book_com/features/home/presentation/view_model/home_view_model.dart';

void main() {
  group('HomeViewModel Widget Tests', () {
    late HomeViewModel viewModel;

    setUp(() {
      viewModel = HomeViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Basic ViewModel Tests', () {
      test('should have correct initial values', () {
        expect(viewModel.books, isEmpty);
        expect(viewModel.recommendedBooks, isEmpty);
        expect(viewModel.isLoading, isTrue);
        expect(viewModel.selectedCategory, equals('All'));
        expect(viewModel.userEmail, isNull);
        expect(viewModel.categories, equals(['All']));
      });

      test('should have search controller', () {
        expect(viewModel.searchController, isNotNull);
      });

      test('should update selected category', () {
        viewModel.setSelectedCategory('Fiction');
        expect(viewModel.selectedCategory, equals('Fiction'));
      });

      test('should notify listeners when category changes', () {
        bool notified = false;
        viewModel.addListener(() {
          notified = true;
        });

        viewModel.setSelectedCategory('Mystery');
        expect(notified, isTrue);
      });

      test('should filter books correctly when category is All', () {
        expect(viewModel.filteredBooks, equals(viewModel.books));
      });

      test('should filter books correctly when category is specific', () {
        viewModel.setSelectedCategory('Fiction');
        expect(viewModel.filteredBooks, equals(viewModel.books.where((book) => book['genre'] == 'Fiction').toList()));
      });
    });

    group('Provider Integration Tests', () {
      testWidgets('should work with ChangeNotifierProvider', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider<HomeViewModel>.value(
              value: viewModel,
              child: Consumer<HomeViewModel>(
                builder: (context, vm, child) {
                  return Scaffold(
                    body: Text('Category: ${vm.selectedCategory}'),
                  );
                },
              ),
            ),
          ),
        );

        expect(find.text('Category: All'), findsOneWidget);
      });

      testWidgets('should update UI when category changes', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider<HomeViewModel>.value(
              value: viewModel,
              child: Consumer<HomeViewModel>(
                builder: (context, vm, child) {
                  return Scaffold(
                    body: Text('Category: ${vm.selectedCategory}'),
                  );
                },
              ),
            ),
          ),
        );

        expect(find.text('Category: All'), findsOneWidget);

        // Change category
        viewModel.setSelectedCategory('Fiction');
        await tester.pump();

        expect(find.text('Category: Fiction'), findsOneWidget);
      });
    });
  });
} 