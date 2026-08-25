import 'package:flutter/foundation.dart';
import '../models/complaint_model.dart';
import '../services/complaints_service.dart';

class ComplaintsProvider with ChangeNotifier {
  final ComplaintsService _complaintsService;

  List<ComplaintModel> _complaints = [];
  Map<String, dynamic>? _meta;
  bool _isLoading = false;
  String? _error;

  ComplaintsProvider(this._complaintsService);

  List<ComplaintModel> get complaints => _complaints;
  Map<String, dynamic>? get meta => _meta;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchComplaints({int page = 1, String? search}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _complaintsService.getComplaints(page: page, search: search);
      _complaints = result['complaints'] as List<ComplaintModel>;
      _meta = result['meta'] as Map<String, dynamic>?;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateComplaintResult({
    required String id,
    required String result,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await _complaintsService.updateComplaintResult(
        id: id,
        result: result,
      );

      final index = _complaints.indexWhere((c) => c.id == id);
      if (index != -1) {
        _complaints[index] = updated;
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

  Future<bool> deleteComplaint(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _complaintsService.deleteComplaint(id);
      _complaints.removeWhere((c) => c.id == id);
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

  static Future<ComplaintsProvider> create(ComplaintsService complaintsService) async {
    return ComplaintsProvider(complaintsService);
  }
}
