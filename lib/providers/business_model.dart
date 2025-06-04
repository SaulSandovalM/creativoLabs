import 'package:creativolabs/api/business_service.dart';
import 'package:flutter/material.dart';

class BusinessModel with ChangeNotifier {
  String? _businessId;
  bool _isLoading = true;

  String? get businessId => _businessId;
  bool get isLoading => _isLoading;

  final BusinessService _businessService = BusinessService();

  // Método para obtener el businessId de Firebase
  Future<void> fetchBusinessId() async {
    final id = await _businessService.getBusinessIdByUser();
    if (id != null) {
      _businessId = id;
      debugPrint('Business ID fetched: $_businessId');
      notifyListeners();
    }
  }

  // Método para establecer el businessId manualmente
  void setBusinessId(String? id) {
    _businessId = id;
    _isLoading = false;
    notifyListeners();
  }
}
