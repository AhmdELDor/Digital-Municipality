import 'dart:io';
import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../services/projects_service.dart';

class ProjectsProvider with ChangeNotifier {
  final ProjectsService _projectsService;

  ProjectsProvider(this._projectsService);

  List<ProjectModel> _projects = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _meta;
  int _currentPage = 1;
  String _searchQuery = '';

  List<ProjectModel> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get meta => _meta;
  int get currentPage => _currentPage;
  String get searchQuery => _searchQuery;

  Future<void> fetchProjects({int page = 1, String? search}) async {
    _isLoading = true;
    _error = null;
    _currentPage = page;
    if (search != null) _searchQuery = search;
    notifyListeners();

    try {
      final result = await _projectsService.getProjects(
        page: page,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      _projects = result['projects'] as List<ProjectModel>;
      _meta = result['meta'] as Map<String, dynamic>?;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchProjects(String query) async {
    _searchQuery = query;
    await fetchProjects(page: 1, search: query);
  }

  Future<bool> createProject({
    required String title,
    required String description,
    String? category,
    String? location,
    String? startDate,
    String? endDate,
    String? status,
    List<File>? images,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final project = await _projectsService.createProject(
        title: title,
        description: description,
        category: category,
        location: location,
        startDate: startDate,
        endDate: endDate,
        status: status,
        images: images,
      );
      _projects.insert(0, project);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProject({
    required String id,
    String? title,
    String? description,
    String? category,
    String? location,
    String? startDate,
    String? endDate,
    String? status,
    List<File>? images,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await _projectsService.updateProject(
        id: id,
        title: title,
        description: description,
        category: category,
        location: location,
        startDate: startDate,
        endDate: endDate,
        status: status,
        images: images,
      );

      final index = _projects.indexWhere((p) => p.id == id);
      if (index != -1) {
        _projects[index] = updated;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProject(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _projectsService.deleteProject(id);
      _projects.removeWhere((p) => p.id == id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  static Future<ProjectsProvider> create(ProjectsService service) async {
    return ProjectsProvider(service);
  }
}
