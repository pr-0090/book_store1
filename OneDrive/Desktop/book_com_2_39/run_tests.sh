#!/bin/bash

# Book.com Flutter App - Test Runner Script
# This script provides easy commands to run different types of tests

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Flutter is installed
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed or not in PATH"
        exit 1
    fi
}

# Function to check if we're in the right directory
check_directory() {
    if [ ! -f "pubspec.yaml" ]; then
        print_error "pubspec.yaml not found. Please run this script from the Flutter project root."
        exit 1
    fi
}

# Function to generate mocks
generate_mocks() {
    print_status "Generating mock files..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
    print_success "Mock files generated successfully"
}

# Function to run all tests
run_all_tests() {
    print_status "Running all tests..."
    flutter test --coverage
    print_success "All tests completed"
}

# Function to run unit tests
run_unit_tests() {
    print_status "Running unit tests..."
    flutter test test/unit/ --coverage
    print_success "Unit tests completed"
}

# Function to run widget tests
run_widget_tests() {
    print_status "Running widget tests..."
    flutter test test/widget/ --coverage
    print_success "Widget tests completed"
}

# Function to run bloc tests
run_bloc_tests() {
    print_status "Running bloc tests..."
    flutter test test/bloc/ --coverage
    print_success "Bloc tests completed"
}

# Function to run integration tests
run_integration_tests() {
    print_status "Running integration tests..."
    flutter test test/integration/ --coverage
    print_success "Integration tests completed"
}

# Function to run specific test file
run_specific_test() {
    local test_file=$1
    if [ -z "$test_file" ]; then
        print_error "Please provide a test file path"
        exit 1
    fi
    
    if [ ! -f "$test_file" ]; then
        print_error "Test file not found: $test_file"
        exit 1
    fi
    
    print_status "Running specific test: $test_file"
    flutter test "$test_file" --coverage
    print_success "Test completed"
}

# Function to run tests with verbose output
run_verbose_tests() {
    print_status "Running tests with verbose output..."
    flutter test --verbose --coverage
    print_success "Verbose tests completed"
}

# Function to show test coverage
show_coverage() {
    print_status "Generating coverage report..."
    flutter test --coverage
    
    if command -v genhtml &> /dev/null; then
        print_status "Creating HTML coverage report..."
        genhtml coverage/lcov.info -o coverage/html
        print_success "Coverage report generated at coverage/html/index.html"
    else
        print_warning "genhtml not found. Install lcov to generate HTML coverage reports."
        print_status "Coverage data available in coverage/lcov.info"
    fi
}

# Function to clean test artifacts
clean_tests() {
    print_status "Cleaning test artifacts..."
    flutter clean
    flutter packages pub run build_runner clean
    print_success "Test artifacts cleaned"
}

# Function to show help
show_help() {
    echo "Book.com Flutter App - Test Runner"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  all              Run all tests"
    echo "  unit             Run unit tests only"
    echo "  widget           Run widget tests only"
    echo "  bloc             Run bloc tests only"
    echo "  integration      Run integration tests only"
    echo "  specific <file>  Run a specific test file"
    echo "  verbose          Run all tests with verbose output"
    echo "  coverage         Run tests and generate coverage report"
    echo "  mocks            Generate mock files"
    echo "  clean            Clean test artifacts"
    echo "  help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 all                    # Run all tests"
    echo "  $0 unit                   # Run unit tests"
    echo "  $0 specific test/unit/api_service_test.dart"
    echo "  $0 coverage               # Run tests with coverage report"
}

# Main script logic
main() {
    check_flutter
    check_directory
    
    case "${1:-help}" in
        "all")
            generate_mocks
            run_all_tests
            ;;
        "unit")
            generate_mocks
            run_unit_tests
            ;;
        "widget")
            generate_mocks
            run_widget_tests
            ;;
        "bloc")
            generate_mocks
            run_bloc_tests
            ;;
        "integration")
            generate_mocks
            run_integration_tests
            ;;
        "specific")
            generate_mocks
            run_specific_test "$2"
            ;;
        "verbose")
            generate_mocks
            run_verbose_tests
            ;;
        "coverage")
            generate_mocks
            show_coverage
            ;;
        "mocks")
            generate_mocks
            ;;
        "clean")
            clean_tests
            ;;
        "help"|*)
            show_help
            ;;
    esac
}

# Run the main function with all arguments
main "$@" 