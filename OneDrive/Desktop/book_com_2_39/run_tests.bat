@echo off
setlocal enabledelayedexpansion

REM Book.com Flutter App - Test Runner Script (Windows)
REM This script provides easy commands to run different types of tests

set "SCRIPT_NAME=%~n0"

REM Function to print colored output
:print_status
echo [INFO] %~1
goto :eof

:print_success
echo [SUCCESS] %~1
goto :eof

:print_warning
echo [WARNING] %~1
goto :eof

:print_error
echo [ERROR] %~1
goto :eof

REM Function to check if Flutter is installed
:check_flutter
flutter --version >nul 2>&1
if errorlevel 1 (
    call :print_error "Flutter is not installed or not in PATH"
    exit /b 1
)
goto :eof

REM Function to check if we're in the right directory
:check_directory
if not exist "pubspec.yaml" (
    call :print_error "pubspec.yaml not found. Please run this script from the Flutter project root."
    exit /b 1
)
goto :eof

REM Function to generate mocks
:generate_mocks
call :print_status "Generating mock files..."
flutter packages pub run build_runner build --delete-conflicting-outputs
if errorlevel 1 (
    call :print_error "Failed to generate mock files"
    exit /b 1
)
call :print_success "Mock files generated successfully"
goto :eof

REM Function to run all tests
:run_all_tests
call :print_status "Running all tests..."
flutter test --coverage
if errorlevel 1 (
    call :print_error "Tests failed"
    exit /b 1
)
call :print_success "All tests completed"
goto :eof

REM Function to run unit tests
:run_unit_tests
call :print_status "Running unit tests..."
flutter test test/unit/ --coverage
if errorlevel 1 (
    call :print_error "Unit tests failed"
    exit /b 1
)
call :print_success "Unit tests completed"
goto :eof

REM Function to run widget tests
:run_widget_tests
call :print_status "Running widget tests..."
flutter test test/widget/ --coverage
if errorlevel 1 (
    call :print_error "Widget tests failed"
    exit /b 1
)
call :print_success "Widget tests completed"
goto :eof

REM Function to run bloc tests
:run_bloc_tests
call :print_status "Running bloc tests..."
flutter test test/bloc/ --coverage
if errorlevel 1 (
    call :print_error "Bloc tests failed"
    exit /b 1
)
call :print_success "Bloc tests completed"
goto :eof

REM Function to run integration tests
:run_integration_tests
call :print_status "Running integration tests..."
flutter test test/integration/ --coverage
if errorlevel 1 (
    call :print_error "Integration tests failed"
    exit /b 1
)
call :print_success "Integration tests completed"
goto :eof

REM Function to run specific test file
:run_specific_test
if "%~1"=="" (
    call :print_error "Please provide a test file path"
    exit /b 1
)

if not exist "%~1" (
    call :print_error "Test file not found: %~1"
    exit /b 1
)

call :print_status "Running specific test: %~1"
flutter test "%~1" --coverage
if errorlevel 1 (
    call :print_error "Test failed"
    exit /b 1
)
call :print_success "Test completed"
goto :eof

REM Function to run tests with verbose output
:run_verbose_tests
call :print_status "Running tests with verbose output..."
flutter test --verbose --coverage
if errorlevel 1 (
    call :print_error "Verbose tests failed"
    exit /b 1
)
call :print_success "Verbose tests completed"
goto :eof

REM Function to show test coverage
:show_coverage
call :print_status "Generating coverage report..."
flutter test --coverage
if errorlevel 1 (
    call :print_error "Coverage generation failed"
    exit /b 1
)

call :print_status "Coverage data available in coverage/lcov.info"
call :print_success "Coverage report generated"
goto :eof

REM Function to clean test artifacts
:clean_tests
call :print_status "Cleaning test artifacts..."
flutter clean
flutter packages pub run build_runner clean
call :print_success "Test artifacts cleaned"
goto :eof

REM Function to show help
:show_help
echo Book.com Flutter App - Test Runner
echo.
echo Usage: %SCRIPT_NAME% [COMMAND]
echo.
echo Commands:
echo   all              Run all tests
echo   unit             Run unit tests only
echo   widget           Run widget tests only
echo   bloc             Run bloc tests only
echo   integration      Run integration tests only
echo   specific ^<file^>  Run a specific test file
echo   verbose          Run all tests with verbose output
echo   coverage         Run tests and generate coverage report
echo   mocks            Generate mock files
echo   clean            Clean test artifacts
echo   help             Show this help message
echo.
echo Examples:
echo   %SCRIPT_NAME% all                    # Run all tests
echo   %SCRIPT_NAME% unit                   # Run unit tests
echo   %SCRIPT_NAME% specific test/unit/api_service_test.dart
echo   %SCRIPT_NAME% coverage               # Run tests with coverage report
goto :eof

REM Main script logic
:main
call :check_flutter
call :check_directory

if "%~1"=="" goto :show_help

if "%~1"=="all" (
    call :generate_mocks
    call :run_all_tests
    goto :end
)

if "%~1"=="unit" (
    call :generate_mocks
    call :run_unit_tests
    goto :end
)

if "%~1"=="widget" (
    call :generate_mocks
    call :run_widget_tests
    goto :end
)

if "%~1"=="bloc" (
    call :generate_mocks
    call :run_bloc_tests
    goto :end
)

if "%~1"=="integration" (
    call :generate_mocks
    call :run_integration_tests
    goto :end
)

if "%~1"=="specific" (
    call :generate_mocks
    call :run_specific_test "%~2"
    goto :end
)

if "%~1"=="verbose" (
    call :generate_mocks
    call :run_verbose_tests
    goto :end
)

if "%~1"=="coverage" (
    call :generate_mocks
    call :show_coverage
    goto :end
)

if "%~1"=="mocks" (
    call :generate_mocks
    goto :end
)

if "%~1"=="clean" (
    call :clean_tests
    goto :end
)

if "%~1"=="help" (
    call :show_help
    goto :end
)

call :show_help
goto :end

:end
exit /b 0 