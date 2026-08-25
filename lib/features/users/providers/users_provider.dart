import 'package:flutter/material.dart';
import '../services/users_service.dart';
import '../models/user_model.dart';

class UsersProvider with ChangeNotifier {
  final UsersService _usersService;

  UsersProvider(this._usersService);

  List<User> _users = [];
  User? _selectedUser;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _meta;
  int _currentPage = 1;
  String _searchQuery = '';

  List<User> get users => _users;
  User? get selectedUser => _selectedUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get meta => _meta;
  int get currentPage => _currentPage;
  String get searchQuery => _searchQuery;

  // Fetch users
  Future<void> fetchUsers({int page = 1, String? search}) async {
    _isLoading = true;
    _error = null;
    _currentPage = page;
    if (search != null) {
      _searchQuery = search;
    }
    notifyListeners();

    try {
      final result = await _usersService.getUsers(
        page: page,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      _users = result['users'] as List<User>;
      _meta = result['meta'] as Map<String, dynamic>?;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search users
  Future<void> searchUsers(String query) async {
    _searchQuery = query;
    await fetchUsers(page: 1, search: query);
  }

  // Fetch single user
  Future<void> fetchUser(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedUser = await _usersService.getUser(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create user
  Future<bool> createUser({
    required String fullName,
    required String phonenumber,
    required String role,
    required String address,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newUser = await _usersService.createUser(
        fullName: fullName,
        phonenumber: phonenumber,
        role: role,
        address: address,
        password: password,
      );
      _users.insert(0, newUser);
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

  // Update user
  Future<bool> updateUser({
    required String id,
    String? fullName,
    String? phonenumber,
    String? role,
    String? address,
    String? password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedUser = await _usersService.updateUser(
        id: id,
        fullName: fullName,
        phonenumber: phonenumber,
        role: role,
        address: address,
        password: password,
      );
      
      final index = _users.indexWhere((u) => u.id == id);
      if (index != -1) {
        _users[index] = updatedUser;
      }
      if (_selectedUser?.id == id) {
        _selectedUser = updatedUser;
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

  // Delete user
  Future<bool> deleteUser(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _usersService.deleteUser(id);
      _users.removeWhere((u) => u.id == id);
      if (_selectedUser?.id == id) {
        _selectedUser = null;
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

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear selected user
  void clearSelectedUser() {
    _selectedUser = null;
    notifyListeners();
  }

  static Future<UsersProvider> create(UsersService usersService) async {
    return UsersProvider(usersService);
  }
}
