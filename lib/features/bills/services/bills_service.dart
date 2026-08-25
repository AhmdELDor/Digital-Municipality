import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/services/storage_service.dart';
import '../models/attach_bill_model.dart';
import '../models/bill_model.dart';

class BillsService {
  final StorageService _storageService;

  BillsService(this._storageService);

  String get _baseUrl => ApiConstants.baseUrl;

  Future<Map<String, String>> _getHeaders() async {
    final token = _storageService.getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _extractMeta(Map<String, dynamic> data) {
    if (data['meta'] is Map<String, dynamic>) return data['meta'] as Map<String, dynamic>;
    if (data['pagination'] is Map<String, dynamic>) return data['pagination'] as Map<String, dynamic>;
    if (data['data'] is Map<String, dynamic> && (data['data'] as Map<String, dynamic>)['meta'] != null) {
      final nestedMeta = (data['data'] as Map<String, dynamic>)['meta'];
      if (nestedMeta is Map<String, dynamic>) return nestedMeta;
    }
    return {};
  }

  List<BillModel> _mapBills(dynamic data) {
    if (data is List) {
      return data.map((e) => BillModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  List<AttachBillModel> _mapAttachBills(dynamic data) {
    if (data is List) {
      return data.map((e) => AttachBillModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  List<BillModel> _extractBillList(Map<String, dynamic> data) {
    if (data['data'] is List) return _mapBills(data['data']);
    if (data['bills'] is List) return _mapBills(data['bills']);
    if (data['data'] is Map<String, dynamic> && (data['data'] as Map<String, dynamic>)['data'] is List) {
      return _mapBills((data['data'] as Map<String, dynamic>)['data']);
    }
    return [];
  }

  List<AttachBillModel> _extractAttachList(Map<String, dynamic> data) {
    if (data['data'] is List) return _mapAttachBills(data['data']);
    if (data['attach_bills'] is List) return _mapAttachBills(data['attach_bills']);
    if (data['data'] is Map<String, dynamic> && (data['data'] as Map<String, dynamic>)['data'] is List) {
      return _mapAttachBills((data['data'] as Map<String, dynamic>)['data']);
    }
    return [];
  }

  Future<Map<String, dynamic>> getBills({int page = 1, String? search}) async {
    try {
      final headers = await _getHeaders();
      var url = '$_baseUrl${ApiConstants.bills}?page=$page';
      if (search != null && search.isNotEmpty) {
        url += '&search=$search';
      }

      final response = await http.get(Uri.parse(url), headers: headers);
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return {
          'bills': _extractBillList(data),
          'meta': _extractMeta(data),
        };
      }

      throw Exception(data['message'] ?? 'Failed to load bills');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getAttachBills({int page = 1, String? search, bool? paid}) async {
    try {
      final headers = await _getHeaders();
      var url = '$_baseUrl${ApiConstants.attachBills}?page=$page';
      if (search != null && search.isNotEmpty) url += '&search=$search';
      if (paid != null) url += '&paid=${paid ? 1 : 0}';

      final response = await http.get(Uri.parse(url), headers: headers);
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return {
          'attachBills': _extractAttachList(data),
          'meta': _extractMeta(data),
        };
      }

      throw Exception(data['message'] ?? 'Failed to load attached bills');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<BillModel> createBill({
    required String title,
    required double amount,
    required String paymentType,
    String? description,
  }) async {
    const enforcedPaymentType = 'cash';
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl${ApiConstants.bills}'),
        headers: headers,
        body: json.encode({
          'title': title,
          'description': description,
          'amount': amount,
          'payment_type': enforcedPaymentType,
        }),
      );

      final data = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201 || response.statusCode == 200) {
        final payload = data['data'] ?? data['bill'] ?? data;
        return BillModel.fromJson(payload as Map<String, dynamic>);
      }

      throw Exception(data['message'] ?? 'Failed to create bill');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<BillModel> updateBill({
    required String id,
    String? title,
    String? description,
    double? amount,
    String? paymentType,
  }) async {
    const enforcedPaymentType = 'cash';
    try {
      final headers = await _getHeaders();
      final body = <String, dynamic>{};
      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (amount != null) body['amount'] = amount;
      body['payment_type'] = enforcedPaymentType;

      final response = await http.put(
        Uri.parse('$_baseUrl${ApiConstants.bills}/$id'),
        headers: headers,
        body: json.encode(body),
      );

      final data = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final payload = data['data'] ?? data['bill'] ?? data;
        return BillModel.fromJson(payload as Map<String, dynamic>);
      }

      throw Exception(data['message'] ?? 'Failed to update bill');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteBill(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(Uri.parse('$_baseUrl${ApiConstants.bills}/$id'), headers: headers);
      if (response.statusCode != 200 && response.statusCode != 204) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(data['message'] ?? 'Failed to delete bill');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<AttachBillModel> attachBillsBulk({
    required String title,
    required double amount,
    required DateTime dueDate,
    String? description,
    String? note,
    List<String>? userIds,
    String? targetRole,
  }) async {
    if ((userIds == null || userIds.isEmpty) && (targetRole == null || targetRole.isEmpty)) {
      throw Exception('يجب اختيار مستخدمين أو دور مستهدف');
    }

    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl${ApiConstants.attachBills}/bulk'),
        headers: headers,
        body: json.encode({
          'title': title,
          'desc': description,
          'amount': amount,
          'due_date': dueDate.toIso8601String().split('T').first,
          if (note != null && note.isNotEmpty) 'note': note,
          if (userIds != null && userIds.isNotEmpty) 'user_ids': userIds,
          if (targetRole != null && targetRole.isNotEmpty) 'target_role': targetRole,
        }),
      );

      final data = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201 || response.statusCode == 200) {
        final payload = data['data'];
        if (payload is List && payload.isNotEmpty) {
          return AttachBillModel.fromJson(payload.first as Map<String, dynamic>);
        }
        if (payload is Map<String, dynamic>) {
          return AttachBillModel.fromJson(payload);
        }
        return AttachBillModel.fromJson(data);
      }

      throw Exception(data['message'] ?? 'Failed to attach bill');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteAttachedBill(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(Uri.parse('$_baseUrl${ApiConstants.attachBills}/$id'), headers: headers);
      if (response.statusCode != 200 && response.statusCode != 204) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(data['message'] ?? 'Failed to delete attached bill');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<AttachBillModel> markPaid(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl${ApiConstants.attachBills}/$id/pay'),
        headers: headers,
      );

      final data = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final payload = data['data'] ?? data;
        return AttachBillModel.fromJson(payload as Map<String, dynamic>);
      }
      throw Exception(data['message'] ?? 'فشل تحديث حالة الدفع');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<AttachBillModel> markUnpaid(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl${ApiConstants.attachBills}/$id/unpay'),
        headers: headers,
      );

      final data = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final payload = data['data'] ?? data;
        return AttachBillModel.fromJson(payload as Map<String, dynamic>);
      }
      throw Exception(data['message'] ?? 'فشل تحديث حالة الدفع');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
