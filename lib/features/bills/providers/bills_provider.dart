import 'package:flutter/material.dart';
import '../models/attach_bill_model.dart';
import '../models/bill_model.dart';
import '../services/bills_service.dart';

class BillsProvider with ChangeNotifier {
  final BillsService _billsService;

  BillsProvider(this._billsService);

  List<BillModel> _bills = [];
  List<AttachBillModel> _attachedBills = [];
  bool _isBillsLoading = false;
  bool _isAttachedLoading = false;
  String? _error;
  Map<String, dynamic>? _billsMeta;
  Map<String, dynamic>? _attachedMeta;
  int _billsPage = 1;
  int _attachedPage = 1;
  String _attachSearch = '';
  bool? _paidFilter;

  List<BillModel> get bills => _bills;
  List<AttachBillModel> get attachedBills => _attachedBills;
  bool get isBillsLoading => _isBillsLoading;
  bool get isAttachedLoading => _isAttachedLoading;
  String? get error => _error;
  Map<String, dynamic>? get billsMeta => _billsMeta;
  Map<String, dynamic>? get attachedMeta => _attachedMeta;
  int get billsPage => _billsPage;
  int get attachedPage => _attachedPage;
  String get attachSearch => _attachSearch;
  bool? get paidFilter => _paidFilter;

  Future<void> fetchBills({int page = 1, String? search}) async {
    _isBillsLoading = true;
    _error = null;
    _billsPage = page;
    notifyListeners();

    try {
      final result = await _billsService.getBills(page: page, search: search);
      _bills = result['bills'] as List<BillModel>;
      _billsMeta = result['meta'] as Map<String, dynamic>?;
      _isBillsLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isBillsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAttachedBills({int page = 1, String? search, bool? paid}) async {
    _isAttachedLoading = true;
    _error = null;
    _attachedPage = page;
    if (search != null) _attachSearch = search;
    _paidFilter = paid;
    notifyListeners();

    try {
      final result = await _billsService.getAttachBills(
        page: page,
        search: _attachSearch.isNotEmpty ? _attachSearch : null,
        paid: _paidFilter,
      );
      _attachedBills = result['attachBills'] as List<AttachBillModel>;
      _attachedMeta = result['meta'] as Map<String, dynamic>?;
      _isAttachedLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isAttachedLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBill({
    required String title,
    required double amount,
    required String paymentType,
    String? description,
  }) async {
    _isBillsLoading = true;
    _error = null;
    notifyListeners();

    try {
      final bill = await _billsService.createBill(
        title: title,
        amount: amount,
        paymentType: paymentType,
        description: description,
      );
      _bills.insert(0, bill);
      _isBillsLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isBillsLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBill({
    required String id,
    String? title,
    String? description,
    double? amount,
    String? paymentType,
  }) async {
    _isBillsLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await _billsService.updateBill(
        id: id,
        title: title,
        description: description,
        amount: amount,
        paymentType: paymentType,
      );
      final index = _bills.indexWhere((b) => b.id == id);
      if (index != -1) {
        _bills[index] = updated;
      }
      _isBillsLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isBillsLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteBill(String id) async {
    _isBillsLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _billsService.deleteBill(id);
      _bills.removeWhere((b) => b.id == id);
      _isBillsLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isBillsLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> attachBill({
    required String title,
    required double amount,
    required DateTime dueDate,
    String? description,
    String? note,
    List<String>? userIds,
    String? targetRole,
  }) async {
    _isAttachedLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _billsService.attachBillsBulk(
        title: title,
        amount: amount,
        dueDate: dueDate,
        description: description,
        note: note,
        userIds: userIds,
        targetRole: targetRole,
      );
      _attachedBills.insert(0, result);
      _isAttachedLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isAttachedLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> markPaid(String id) async {
    try {
      final updated = await _billsService.markPaid(id);
      final index = _attachedBills.indexWhere((b) => b.id == id);
      if (index != -1) _attachedBills[index] = updated;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> markUnpaid(String id) async {
    try {
      final updated = await _billsService.markUnpaid(id);
      final index = _attachedBills.indexWhere((b) => b.id == id);
      if (index != -1) _attachedBills[index] = updated;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAttached(String id) async {
    _isAttachedLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _billsService.deleteAttachedBill(id);
      _attachedBills.removeWhere((b) => b.id == id);
      _isAttachedLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isAttachedLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  static Future<BillsProvider> create(BillsService service) async {
    return BillsProvider(service);
  }
}
