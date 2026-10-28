import 'package:flutter/material.dart';

import '../../../c_models/blog_post_model.dart';

class BlogProvider extends ChangeNotifier {
  List<BlogPostModel> _posts = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';

  BlogProvider() {
    _posts = BlogPostModel.samplePosts;
  }

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  final List<String> categories = [
    'All',
    'Loans',
    'Investments',
    'Tax Saving',
  ];

  BlogPostModel get featuredPost => _posts.first;

  List<BlogPostModel> get filteredPosts {
    return _posts.where((post) {
      if (_selectedCategory != 'All' &&
          post.category.toLowerCase() != _selectedCategory.toLowerCase()) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = post.title.toLowerCase().contains(query);
        final matchExcerpt = post.excerpt.toLowerCase().contains(query);
        if (!matchTitle && !matchExcerpt) return false;
      }
      return true;
    }).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}