import 'package:flutter/foundation.dart';
import '../models/poll_model.dart';
import '../services/polls_service.dart';

class PollsProvider with ChangeNotifier {
  final PollsService _pollsService;

  PollsProvider(this._pollsService);

  List<PollModel> _polls = [];
  Map<String, dynamic>? _meta;
  bool _isLoading = false;
  String? _error;

  List<PollModel> get polls => _polls;
  Map<String, dynamic>? get meta => _meta;
  bool get isLoading => _isLoading;
  String? get error => _error;

  static PollsProvider create(PollsService pollsService) {
    return PollsProvider(pollsService);
  }

  Future<void> fetchPolls({int page = 1, String search = ''}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    if (kDebugMode) {
      print('🔍 [PollsProvider] Fetching polls - page: $page, search: "$search"');
    }

    try {
      final result = await _pollsService.getPolls(page: page, search: search);
      _polls = result['polls'] as List<PollModel>;
      _meta = result['meta'] as Map<String, dynamic>?;
      
      if (kDebugMode) {
        print('✅ [PollsProvider] Received ${_polls.length} polls');
        print('📊 [PollsProvider] Meta: $_meta');
        print('📊 [PollsProvider] Current page: ${_meta?['current_page']}, Last page: ${_meta?['last_page']}');
      }
    } catch (e) {
      _error = 'فشل في تحميل الاستطلاعات: ${e.toString()}';
      if (kDebugMode) {
        print('❌ [PollsProvider] Error: $_error');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<PollModel?> fetchPoll(String id) async {
    try {
      return await _pollsService.getPoll(id);
    } catch (e) {
      if (kDebugMode) {
        print('[PollsProvider] Error fetching poll: $e');
      }
      return null;
    }
  }

  Future<bool> createPoll({
    required String title,
    String? description,
    required List<String> options,
    DateTime? startAt,
    DateTime? endAt,
    required String status,
  }) async {
    _error = null;
    try {
      final success = await _pollsService.createPoll(
        title: title,
        description: description,
        options: options,
        startAt: startAt,
        endAt: endAt,
        status: status,
      );

      if (success) {
        await fetchPolls();
      }
      return success;
    } catch (e) {
      _error = 'فشل في إنشاء الاستطلاع: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePoll({
    required String id,
    String? title,
    String? description,
    List<String>? options,
    DateTime? startAt,
    DateTime? endAt,
    String? status,
  }) async {
    _error = null;
    try {
      final success = await _pollsService.updatePoll(
        id: id,
        title: title,
        description: description,
        options: options,
        startAt: startAt,
        endAt: endAt,
        status: status,
      );

      if (success) {
        await fetchPolls();
      }
      return success;
    } catch (e) {
      _error = 'فشل في تحديث الاستطلاع: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deletePoll(String id) async {
    _error = null;
    try {
      final success = await _pollsService.deletePoll(id);
      if (success) {
        await fetchPolls();
      }
      return success;
    } catch (e) {
      _error = 'فشل في حذف الاستطلاع: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> votePoll(String id, String option) async {
    _error = null;
    try {
      final success = await _pollsService.votePoll(id, option);
      if (success) {
        // Refresh the poll to get updated vote counts
        await fetchPolls();
      }
      return success;
    } catch (e) {
      _error = 'فشل في التصويت: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
