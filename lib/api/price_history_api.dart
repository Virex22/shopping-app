import 'package:dio/dio.dart';
import 'package:shopping_app/api/abstract_api.dart';
import 'package:shopping_app/model/price_history.dart';

class PriceHistoryApi extends AbstractAPI {
  Future<List<PriceHistory>> getAllPriceHistories() async {
    final response = await get('/price_histories');
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> priceHistoryList = data['hydra:member'];
    return priceHistoryList
        .map((priceHistoryJson) => PriceHistory.fromJson(priceHistoryJson))
        .toList();
  }

  Future<PriceHistory> getPriceHistory(int id) async {
    final response = await get('/price_histories/$id');
    final data = response.data as Map<String, dynamic>;
    return PriceHistory.fromJson(data);
  }

  Future<List<PriceHistory>> getPriceHistoriesByProductId(int productId) async {
    final response = await get('/price_histories?product=$productId');
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> priceHistoryList = data['hydra:member'];
    return priceHistoryList
        .map((priceHistoryJson) => PriceHistory.fromJson(priceHistoryJson))
        .toList();
  }

  Future<PriceHistory> addPriceHistory(
      Map<String, dynamic> priceHistoryData) async {
    final response = await post('/price_histories', priceHistoryData);
    final data = response.data as Map<String, dynamic>;
    return PriceHistory.fromJson(data);
  }

  Future<bool> deletePriceHistory(int id) async {
    final Response<dynamic> response = await delete('/price_histories/$id');
    return response.statusCode == 204;
  }

  Future<PriceHistory> updatePriceHistory(
      int id, Map<String, dynamic> updatedData) async {
    final response = await put('/price_histories/$id', updatedData);
    final data = response.data as Map<String, dynamic>;
    return PriceHistory.fromJson(data);
  }
}
