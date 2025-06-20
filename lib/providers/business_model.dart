import 'package:creativolabs/api/business_service.dart';
import 'package:flutter/material.dart';

class BusinessModel with ChangeNotifier {
  String? _businessId;
  bool _isLoading = false;

  String? get businessId => _businessId;
  bool get isLoading => _isLoading;

  final BusinessService _businessService = BusinessService();

  /// Obtiene el businessId desde el servicio y actualiza el estado
  Future<void> fetchBusinessId() async {
    _isLoading = true;
    notifyListeners(); // Notifica antes de cargar (útil para mostrar loaders)

    try {
      final id = await _businessService.getBusinessIdByUser();
      if (id != null) {
        _businessId = id;
        debugPrint('Business ID fetched: $_businessId');
      } else {
        debugPrint('No se encontró Business ID');
      }
    } catch (e) {
      debugPrint('Error al obtener el Business ID: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Notifica después de cargar
    }
  }

  /// Permite establecer el ID manualmente si fuese necesario
  void setBusinessId(String? id) {
    _businessId = id;
    _isLoading = false;
    notifyListeners();
  }
}
