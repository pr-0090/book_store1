import 'package:flutter_test/flutter_test.dart';
import 'package:book_com/features/home/presentation/view_model/home_view_model.dart';

void main() {
  group('HomeViewModel Tests', () {
    late HomeViewModel viewModel;

    setUp(() {
      viewModel = HomeViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Initial State', () {
      test('should have correct initial values', () {
        expect(viewModel.books, isEmpty);
        expect(viewModel.recommendedBooks, isEmpty);
        expect(viewModel.isLoading, isTrue);
        expect(viewModel.selectedCategory, equals('All'));
        expect(viewModel.userEmail, isNull);
        expect(viewModel.categories, equals(['All']));
      });

      test('should filter books correctly when category is All', () {
        expect(viewModel.filteredBooks, equals(viewModel.books));
      });

      test('should filter books correctly when category is specific', () {
        viewModel.setSelectedCategory('Fiction');
        expect(viewModel.selectedCategory, equals('Fiction'));
      });
    });

    group('Category Management', () {
      test('should update selected category', () {
        viewModel.setSelectedCategory('Science Fiction');
        expect(viewModel.selectedCategory, equals('Science Fiction'));
      });

      test('should notify listeners when category changes', () {
        bool notified = false;
        viewModel.addListener(() {
          notified = true;
        });

        viewModel.setSelectedCategory('Mystery');
        expect(notified, isTrue);
      });
    });

    group('Recommendations', () {
      test('should refresh recommendations', () {
        // Test that the method doesn't throw
        expect(() => viewModel.refreshRecommendations(), returnsNormally);
      });
    });

    group('Search Controller', () {
      test('should have search controller', () {
        expect(viewModel.searchController, isNotNull);
      });
    });

    group('Filtered Books', () {
      test('should return all books when category is All', () {
        expect(viewModel.filteredBooks, equals(viewModel.books));
      });

      test('should return filtered books when category is specific', () {
        viewModel.setSelectedCategory('Fiction');
        expect(viewModel.filteredBooks, equals(viewModel.books.where((book) => book['genre'] == 'Fiction').toList()));
      });
    });

    group('State Management', () {
      test('should notify listeners when state changes', () {
        bool notified = false;
        viewModel.addListener(() {
          notified = true;
        });

        viewModel.setSelectedCategory('Test Category');
        expect(notified, isTrue);
      });
    });
  });
} 