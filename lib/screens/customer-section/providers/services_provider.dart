import 'package:flutter/foundation.dart';
import '../../../c_models/financial_service_model.dart';

class ServicesProvider extends ChangeNotifier {
  List<FinancialServiceModel> _allServices = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';

  ServicesProvider() {
    _allServices = FinancialServiceModel.sampleServices;
  }

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  final List<String> categories = [
    'All',
    'Consulting',
    'Planning',
    'Guidance',
    'Investment',
  ];

  List<FinancialServiceModel> get filteredServices {
    return _allServices.where((service) {
      // 1. Search Query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = service.title.toLowerCase().contains(query);
        final matchesDesc = service.subtitle.toLowerCase().contains(query);
        if (!matchesTitle && !matchesDesc) return false;
      }

      // 2. Category Tab
      if (_selectedCategory != 'All') {
        if (service.category.toLowerCase() != _selectedCategory.toLowerCase()) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}