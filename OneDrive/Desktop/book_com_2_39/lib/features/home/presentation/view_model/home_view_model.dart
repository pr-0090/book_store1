import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/hive_service.dart';
import '../../../../app/shared_prefs/shared_prefs_service.dart';

class HomeViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  
  List<Map<String, dynamic>> _books = [];
  List<Map<String, dynamic>> _recommendedBooks = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  String? _userEmail;
  
  // Shake detection properties
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;
  List<double> _accelerometerReadings = [];
  static const int _shakeWindowSize = 10;
  static const double _shakeThreshold = 2.0;
  
  List<String> _categories = ['All'];

  // Getters
  List<Map<String, dynamic>> get books => _books;
  List<Map<String, dynamic>> get recommendedBooks => _recommendedBooks;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String? get userEmail => _userEmail;
  List<String> get categories => _categories;

  List<Map<String, dynamic>> get filteredBooks {
    if (_selectedCategory == 'All') {
      return _books;
    }
    return _books.where((book) => book['genre'] == _selectedCategory).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  Future<void> initialize() async {
    await _loadBooks();
    _setupShakeDetection();
    await _loadUserEmail();
    await _trackScreenVisit();
  }

  Future<void> _loadUserEmail() async {
    try {
      final user = HiveService.getCurrentUser();
      if (user != null && user.email != null && user.email!.isNotEmpty) {
        _userEmail = user.email;
        print('Home: Loaded user email: $_userEmail');
        notifyListeners();
      } else {
        print('Home: No user or user email is null/empty');
        // Try to fetch from API as fallback
        try {
          final response = await ApiService().getCurrentUser();
          if (response.statusCode == 200) {
            final userData = response.data['user'];
            if (userData != null && userData['email'] != null) {
              _userEmail = userData['email'];
              print('Home: Loaded user email from API: $_userEmail');
              notifyListeners();
            }
          }
        } catch (apiError) {
          print('Home: API fallback failed: $apiError');
        }
      }
    } catch (e) {
      print('Home: Error loading user email: $e');
    }
  }

  Future<void> _trackScreenVisit() async {
    await SharedPrefsService.setLastVisitedScreen('home');
  }

  Future<void> _loadBooks() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await ApiService().getAllProducts();
      if (response.statusCode == 200) {
        final List<dynamic> booksData = response.data;
        _books = booksData.map((book) => Map<String, dynamic>.from(book)).toList();
        
        // Select random books for recommended section
        final List<Map<String, dynamic>> shuffledBooks = List.from(_books);
        shuffledBooks.shuffle();
        _recommendedBooks = shuffledBooks.take(5).toList();
        
        // Extract unique genres from books
        final Set<String> uniqueGenres = {};
        for (final book in _books) {
          final String? genre = book['genre'];
          if (genre != null && genre.isNotEmpty) {
            uniqueGenres.add(genre);
          }
        }
        
        // Update categories list with unique genres
        _categories = ['All', ...uniqueGenres.toList()..sort()];
        
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to load books: ${e.toString()}');
    }
  }

  void _setupShakeDetection() {
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      // Calculate the magnitude of acceleration
      double magnitude = (event.x * event.x + event.y * event.y + event.z * event.z);
      
      // Add reading to the window
      _accelerometerReadings.add(magnitude);
      
      // Keep only the last N readings
      if (_accelerometerReadings.length > _shakeWindowSize) {
        _accelerometerReadings.removeAt(0);
      }
      
      // Only process if we have enough readings
      if (_accelerometerReadings.length == _shakeWindowSize) {
        // Calculate the variance (measure of how much the readings vary)
        double mean = _accelerometerReadings.reduce((a, b) => a + b) / _accelerometerReadings.length;
        double variance = _accelerometerReadings.map((reading) => (reading - mean) * (reading - mean)).reduce((a, b) => a + b) / _accelerometerReadings.length;
        
        // Check if variance indicates a shake (sudden changes in acceleration)
        if (variance > _shakeThreshold) {
          // Debounce to prevent multiple rapid triggers
          final now = DateTime.now();
          if (_lastShakeTime == null || now.difference(_lastShakeTime!).inMilliseconds > 2000) {
            print('Shake detected! Variance: $variance');
            _lastShakeTime = now;
            _refreshRecommendations();
          }
        }
      }
    });
  }

  void _refreshRecommendations() {
    if (_books.isNotEmpty) {
      final List<Map<String, dynamic>> shuffledBooks = List.from(_books);
      shuffledBooks.shuffle();
      _recommendedBooks = shuffledBooks.take(5).toList();
      notifyListeners();
    }
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void refreshRecommendations() {
    _refreshRecommendations();
  }

  Future<void> refreshBooks() async {
    await _loadBooks();
  }
} 