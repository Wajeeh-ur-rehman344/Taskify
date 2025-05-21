import 'package:dio/dio.dart';
import '../URLs/config.dart';

class MiddlemanNotification {
  // Initialize Dio with proper configuration
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    validateStatus: (status) => status != null && status < 500,
  ));

  // ---------Method to show notifications for middleman against customer tasks----------
  Future<Map<String, dynamic>> ShowNotifyAgainstCustTask(String middId) async {
    try {
      final response = await _dio.post(
        middShowNotifyAgainstCustTasks,
        data: {"middId": middId},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("API Response status code: ${response.statusCode}");
      print("API Response data: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data is List) {
          return {"status": true, "data": response.data};
        } else {
          throw Exception('Invalid response format: expected List');
        }
      }

      return {"status": false, "message": "Failed to fetch notifications"};
    } catch (e) {
      print("Error in ShowNotifyAgainstCustTask: $e");
      return {"status": false, "message": e.toString()};
    }
  }
}
