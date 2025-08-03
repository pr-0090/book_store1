import 'package:flutter/material.dart';
import '../../../../core/network/api_service.dart';
import '../../../../app/shared_prefs/shared_prefs_service.dart';
import '../../../../app/shared_prefs/analytics_service.dart';

class SearchViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  List<Map<String, dynamic>> _searchResults = [];
  List<String> _searchHistory = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _errorMessage;

  // Getters
  List<Map<String, dynamic>> get searchResults => _searchResults;
  List<String> get searchHistory => _searchHistory;
  bool get isLoading => _isLoading;
  bool get hasSearched => _hasSearched;
  String? get errorMessage => _errorMessage;
  bool get hasResults => _searchResults.isNotEmpty;
  int get resultCount => _searchResults.length;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void initialize() {
    _loadSearchHistory();
  }

  void _loadSearchHistory() {
    _searchHistory = SharedPrefsService.getSearchHistory();
    notifyListeners();
  }

  Future<void> performSearch() async {
    if (!formKey.currentState!.validate()) return;

    final searchTerm = searchController.text.trim();
    if (searchTerm.isEmpty) return;

    try {
      _isLoading = true;
      _hasSearched = true;
      _errorMessage = null;
      notifyListeners();

      // Add search term to history
      await SharedPrefsService.addToSearchHistory(searchTerm);
      _loadSearchHistory();

      // Track search analytics
      await AnalyticsService.trackSearchPerformed(searchTerm);

      // For now, we'll search through all products
      // In a real app, you'd have a dedicated search endpoint
      final response = await ApiService().getAllProducts();
      
      if (response.statusCode == 200) {
        final allProducts = response.data as List<dynamic>;
        
        final filteredProducts = allProducts.where((product) {
          // Handle different possible field names from API
          final title = (product['title'] ?? 
                        product['productName'] ?? 
                        product['name'] ?? 
                        '').toString().toLowerCase();
          final author = (product['author'] ?? 
                         product['authorName'] ?? 
                         product['author_name'] ?? 
                         '').toString().toLowerCase();
          final genre = (product['genre'] ?? 
                        product['category'] ?? 
                        '').toString().toLowerCase();
          
          return title.contains(searchTerm.toLowerCase()) || 
                 author.contains(searchTerm.toLowerCase()) || 
                 genre.contains(searchTerm.toLowerCase());
        }).toList();

        _searchResults = filteredProducts.cast<Map<String, dynamic>>();
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = 'Search failed: Status ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Search failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    searchController.clear();
    _searchResults.clear();
    _hasSearched = false;
    _errorMessage = null;
    notifyListeners();
  }

  void clearSearchHistory() async {
    await SharedPrefsService.clearSearchHistory();
    _loadSearchHistory();
  }

  void removeFromSearchHistory(String term) async {
    await SharedPrefsService.removeFromSearchHistory(term);
    _loadSearchHistory();
  }

  void selectSearchHistoryItem(String term) {
    searchController.text = term;
    performSearch();
  }

  List<Map<String, dynamic>> getFilteredResults(String filter) {
    if (filter.isEmpty) return _searchResults;
    
    return _searchResults.where((product) {
      final title = product['title']?.toString().toLowerCase() ?? '';
      final author = product['author']?.toString().toLowerCase() ?? '';
      final genre = product['genre']?.toString().toLowerCase() ?? '';
      
      return title.contains(filter.toLowerCase()) || 
             author.contains(filter.toLowerCase()) || 
             genre.contains(filter.toLowerCase());
    }).toList();
  }

  List<Map<String, dynamic>> getResultsByGenre(String genre) {
    return _searchResults.where((product) => 
      product['genre']?.toString().toLowerCase() == genre.toLowerCase()
    ).toList();
  }

  List<Map<String, dynamic>> getResultsByPriceRange(double minPrice, double maxPrice) {
    return _searchResults.where((product) {
      final price = product['price']?.toDouble() ?? 0.0;
      return price >= minPrice && price <= maxPrice;
    }).toList();
  }

  void sortResultsByPrice({bool ascending = true}) {
    _searchResults.sort((a, b) {
      final priceA = a['price']?.toDouble() ?? 0.0;
      final priceB = b['price']?.toDouble() ?? 0.0;
      return ascending ? priceA.compareTo(priceB) : priceB.compareTo(priceA);
    });
    notifyListeners();
  }

  void sortResultsByTitle({bool ascending = true}) {
    _searchResults.sort((a, b) {
      final titleA = a['title']?.toString() ?? '';
      final titleB = b['title']?.toString() ?? '';
      return ascending ? titleA.compareTo(titleB) : titleB.compareTo(titleA);
    });
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  bool get hasRecentSearches => _searchHistory.isNotEmpty;
} 