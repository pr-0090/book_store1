# Book.com Flutter App - Testing Guide

This document provides comprehensive information about running tests for the Book.com Flutter application.

## Test Structure

```
test/
├── unit/                    # Unit tests for business logic
│   ├── api_service_test.dart
│   └── home_view_model_test.dart
├── widget/                  # Widget tests for UI components
│   └── home_screen_test.dart
├── bloc/                    # Bloc tests for state management
│   └── auth_bloc_test.dart
├── integration/             # Integration tests for complete flows
│   └── app_integration_test.dart
├── helpers/                 # Test utilities and helpers
│   └── test_helpers.dart
└── README.md               # This file
```

## Prerequisites

Before running tests, ensure you have the following dependencies in your `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.4
  mockito: ^5.4.2
  integration_test:
    sdk: flutter
```

## Running Tests

### 1. Generate Mock Files

First, generate the mock files for testing:

```bash
# Navigate to your project directory
cd book_com

# Generate mocks for all test files
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 2. Run All Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run tests with verbose output
flutter test --verbose
```

### 3. Run Specific Test Categories

```bash
# Run only unit tests
flutter test test/unit/

# Run only widget tests
flutter test test/widget/

# Run only bloc tests
flutter test test/bloc/

# Run only integration tests
flutter test test/integration/
```

### 4. Run Individual Test Files

```bash
# Run specific test file
flutter test test/unit/api_service_test.dart

# Run with specific test name
flutter test --name "should validate email format"
```

### 5. Run Integration Tests

```bash
# Run integration tests on connected device/emulator
flutter test integration_test/app_integration_test.dart

# Run integration tests with specific device
flutter test integration_test/app_integration_test.dart -d <device-id>
```

## Test Categories

### 1. Unit Tests (`test/unit/`)

Unit tests focus on testing individual functions and classes in isolation.

#### API Service Tests (`api_service_test.dart`)
- Tests all API endpoints (auth, products, cart, orders, etc.)
- Validates request/response handling
- Tests error scenarios
- Tests token management

**Run with:**
```bash
flutter test test/unit/api_service_test.dart
```

#### Home View Model Tests (`home_view_model_test.dart`)
- Tests state management logic
- Tests data filtering and processing
- Tests user interaction handling
- Tests shake detection functionality

**Run with:**
```bash
flutter test test/unit/home_view_model_test.dart
```

### 2. Widget Tests (`test/widget/`)

Widget tests verify that UI components render correctly and respond to user interactions.

#### Home Screen Tests (`home_screen_test.dart`)
- Tests UI rendering
- Tests user interactions (taps, text input)
- Tests navigation flows
- Tests loading states
- Tests error states

**Run with:**
```bash
flutter test test/widget/home_screen_test.dart
```

### 3. Bloc Tests (`test/bloc/`)

Bloc tests verify state management and business logic flows.

#### Auth Bloc Tests (`auth_bloc_test.dart`)
- Tests authentication flows (login, register, logout)
- Tests state transitions
- Tests error handling
- Tests input validation

**Run with:**
```bash
flutter test test/bloc/auth_bloc_test.dart
```

### 4. Integration Tests (`test/integration/`)

Integration tests verify complete user flows from start to finish.

#### App Integration Tests (`app_integration_test.dart`)
- Tests complete app startup flow
- Tests authentication flows
- Tests shopping cart functionality
- Tests search functionality
- Tests profile and settings
- Tests error handling
- Tests performance
- Tests accessibility

**Run with:**
```bash
flutter test test/integration/app_integration_test.dart
```

## Test Helpers

### Test Helpers (`test/helpers/test_helpers.dart`)

Contains utility functions and classes for testing:

- `TestHelpers`: Creates mock data (users, books, cart items, etc.)
- `TestApp`: Widget wrapper for common test setup
- `TestUtils`: Common test operations (tap, enter text, scroll, etc.)
- `TestData`: Constants for test data
- `TestEnvironment`: Test environment setup and teardown

## Test Coverage

To generate and view test coverage:

```bash
# Generate coverage report
flutter test --coverage

# View coverage in HTML (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Configuration

### Mock Generation

The tests use Mockito for mocking. To generate mocks:

```bash
# Generate mocks for all files
flutter packages pub run build_runner build

# Watch for changes and auto-generate
flutter packages pub run build_runner watch
```

### Test Environment Setup

```dart
// In your test files
import 'package:book_com/test/helpers/test_helpers.dart';

void main() {
  setUp(() {
    TestEnvironment.setupTestEnvironment();
  });

  tearDown(() {
    TestEnvironment.tearDownTestEnvironment();
  });
}
```

## Common Test Patterns

### 1. Unit Test Pattern

```dart
group('Feature Tests', () {
  late MockDependency mockDependency;
  late TestClass testClass;

  setUp(() {
    mockDependency = MockDependency();
    testClass = TestClass(mockDependency);
  });

  test('should do something when condition is met', () {
    // Arrange
    when(mockDependency.method()).thenReturn(result);

    // Act
    final result = testClass.method();

    // Assert
    expect(result, expectedValue);
  });
});
```

### 2. Widget Test Pattern

```dart
testWidgets('should render widget correctly', (WidgetTester tester) async {
  // Arrange
  await tester.pumpWidget(TestApp(child: YourWidget()));

  // Assert
  expect(find.text('Expected Text'), findsOneWidget);
  expect(find.byType(ExpectedWidget), findsOneWidget);
});
```

### 3. Bloc Test Pattern

```dart
blocTest<TestBloc, TestState>(
  'emits [State1, State2] when event is added',
  build: () => TestBloc(),
  act: (bloc) => bloc.add(TestEvent()),
  expect: () => [State1(), State2()],
);
```

## Troubleshooting

### Common Issues

1. **Mock files not generated**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

2. **Tests failing due to missing dependencies**
   ```bash
   flutter pub get
   flutter test --reporter=expanded
   ```

3. **Integration tests not running**
   ```bash
   # Ensure device is connected
   flutter devices
   
   # Run with specific device
   flutter test integration_test/app_integration_test.dart -d <device-id>
   ```

4. **Widget tests failing due to missing keys**
   - Add keys to your widgets for easier testing
   - Use `find.byKey()` in tests

### Debugging Tests

```bash
# Run tests with debug output
flutter test --verbose

# Run specific test with debug
flutter test --name "test name" --verbose

# Run tests and pause on failures
flutter test --reporter=expanded
```

## Best Practices

1. **Test Naming**: Use descriptive test names that explain the scenario
2. **Arrange-Act-Assert**: Follow the AAA pattern in your tests
3. **Mock Dependencies**: Mock external dependencies to isolate the code under test
4. **Test Data**: Use the provided test helpers for consistent test data
5. **Coverage**: Aim for at least 80% test coverage
6. **Performance**: Keep tests fast and focused
7. **Maintenance**: Update tests when code changes

## Continuous Integration

Add this to your CI pipeline:

```yaml
# Example GitHub Actions workflow
- name: Run tests
  run: |
    flutter pub get
    flutter packages pub run build_runner build
    flutter test --coverage
```

## Additional Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Bloc Testing Documentation](https://bloclibrary.dev/#/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Integration Testing Guide](https://docs.flutter.dev/testing/integration-tests) 