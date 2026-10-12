import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../data/mock_data.dart';

class ServiceProvider with ChangeNotifier {
  List<ServiceCategory> _categories = [];
  List<ServiceItem> _services = [];
  
  String _selectedCategoryId = 'cat_all';
  String _searchQuery = '';
  ServiceItem? _selectedServiceForDetails;

  ServiceProvider() {
    _loadInitialData();
  }

  void _loadInitialData() {
    _categories = MockData.categories;
    _services = MockData.services;
    notifyListeners();
  }

  List<ServiceCategory> get categories => _categories;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  ServiceItem? get selectedServiceForDetails => _selectedServiceForDetails;

  List<ServiceItem> get filteredServices {
    return _services.where((service) {
      final matchesCategory = _selectedCategoryId == 'cat_all' ||
          service.categoryId == _selectedCategoryId;
      
      final matchesSearch = _searchQuery.isEmpty ||
          service.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          service.subtitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          service.description.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<ServiceItem> get popularServices {
    return _services.where((s) => s.isPopular).toList();
  }

  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void setSelectedServiceForDetails(ServiceItem? service) {
    _selectedServiceForDetails = service;
    notifyListeners();
  }
}
