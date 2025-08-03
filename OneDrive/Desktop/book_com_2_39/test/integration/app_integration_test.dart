import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:book_com/features/home/presentation/view_model/home_view_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    late HomeViewModel viewModel;

    setUp(() {
      viewModel = HomeViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    testWidgets('HomeViewModel basic functionality test', (WidgetTester tester) async {
      // Test that the ViewModel is properly initialized
      expect(viewModel.books, isEmpty);
      expect(viewModel.selectedCategory, equals('All'));
      expect(viewModel.isLoading, isTrue);
      expect(viewModel.userEmail, isNull);
      expect(viewModel.categories, equals(['All']));
    });

    testWidgets('Category management integration test', (WidgetTester tester) async {
      // Test category filtering functionality
      viewModel.setSelectedCategory('Fiction');
      expect(viewModel.selectedCategory, equals('Fiction'));
      
      viewModel.setSelectedCategory('Science');
      expect(viewModel.selectedCategory, equals('Science'));
      
      viewModel.setSelectedCategory('All');
      expect(viewModel.selectedCategory, equals('All'));
    });

    testWidgets('Search functionality integration test', (WidgetTester tester) async {
      // Test search functionality
      viewModel.searchController.text = 'test';
      expect(viewModel.searchController.text, equals('test'));
      
      viewModel.searchController.text = 'Harry Potter';
      expect(viewModel.searchController.text, equals('Harry Potter'));
      
      viewModel.searchController.clear();
      expect(viewModel.searchController.text, isEmpty);
    });

    testWidgets('Recommendations integration test', (WidgetTester tester) async {
      // Test recommendations functionality
      viewModel.refreshRecommendations();
      expect(viewModel.recommendedBooks, isA<List>());
    });

    testWidgets('Filtered books integration test', (WidgetTester tester) async {
      // Test filtered books functionality
      final filteredBooks = viewModel.filteredBooks;
      expect(filteredBooks, isA<List>());
      
      // Test filtering with different categories
      viewModel.setSelectedCategory('Fiction');
      final fictionBooks = viewModel.filteredBooks;
      expect(fictionBooks, isA<List>());
    });

    testWidgets('Loading state integration test', (WidgetTester tester) async {
      // Test loading state
      expect(viewModel.isLoading, isA<bool>());
      
      // Test that loading state can change
      viewModel.refreshRecommendations();
      expect(viewModel.isLoading, isA<bool>());
    });

    testWidgets('Categories list integration test', (WidgetTester tester) async {
      // Test categories list
      final categories = viewModel.categories;
      expect(categories, isA<List<String>>());
      expect(categories, contains('All'));
    });

    testWidgets('State notification integration test', (WidgetTester tester) async {
      // Test state change notifications
      bool notified = false;
      viewModel.addListener(() {
        notified = true;
      });
      
      viewModel.setSelectedCategory('Science');
      expect(notified, isTrue);
    });

    testWidgets('Multiple state changes integration test', (WidgetTester tester) async {
      // Test multiple state changes
      int notificationCount = 0;
      viewModel.addListener(() {
        notificationCount++;
      });
      
      viewModel.setSelectedCategory('Fiction');
      expect(notificationCount, equals(1));
      
      viewModel.setSelectedCategory('Science');
      expect(notificationCount, equals(2));
      
      viewModel.setSelectedCategory('All');
      expect(notificationCount, equals(3));
    });

    testWidgets('Search controller lifecycle integration test', (WidgetTester tester) async {
      // Test search controller lifecycle
      expect(viewModel.searchController.text, isEmpty);
      
      viewModel.searchController.text = 'Test Book';
      expect(viewModel.searchController.text, equals('Test Book'));
      
      viewModel.searchController.text = '';
      expect(viewModel.searchController.text, isEmpty);
    });

    testWidgets('Initial state consistency integration test', (WidgetTester tester) async {
      // Test that initial state is consistent
      final newViewModel = HomeViewModel();
      
      expect(newViewModel.books, isEmpty);
      expect(newViewModel.recommendedBooks, isEmpty);
      expect(newViewModel.selectedCategory, equals('All'));
      expect(newViewModel.categories, equals(['All']));
      
      newViewModel.dispose();
    });
  });
} 