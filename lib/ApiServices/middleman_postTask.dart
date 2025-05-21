import 'dart:io';
import 'package:dio/dio.dart';
import '../URLs/config.dart';

class MiddlemanPostTask {
  // Initialize Dio with proper configuration
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    validateStatus: (status) => status != null && status < 500,
  ));

  //------------------------------------Middleman Place Bid--------------------------------
  Future<bool> middlemanPlaceBid(String taskId, String middId,
      String middbidAmount, String estimateTime) async {
    try {
      // Prepare the request data
      final data = {
        "taskId": taskId,
        "middId": middId, // Corrected key to match the backend
        "middbidAmount":
            double.parse(middbidAmount), // Ensure proper type conversion
        "estimateTime": estimateTime,
      };

      // Make the POST request
      final response = await _dio.post(
        middBids, // Replace with the actual task-posting endpoint
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json'}, // Updated content type
        ),
      );

      // Check if the response is successful
      if (response.statusCode == 201) {
        return true;
      } else {
        print("Failed to place bid: ${response.data}");
        return false;
      }
    } catch (e) {
      // Handle errors
      if (e is DioError) {
        print("DioError: ${e.response?.data ?? e.message}");
      } else {
        print("Error posting task: $e");
      }
      return false;
    }
  }

  // ---------Method to provide the information for starting task---------------
  Future<Map<String, dynamic>> showStartTaskmiddleman(String taskId) async {
    print("Fetching task details for taskId: $taskId");
    try {
      final response = await _dio.post(
        showStartTaskmiddlemans,
        data: {"taskId": taskId},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("API Response: ${response.data}");

      if (response.statusCode == 200 && response.data['success'] == true) {
        return {"status": true, "data": response.data['data']};
      } else {
        return {"status": false, "message": "Failed to fetch task details"};
      }
    } catch (e) {
      print("Error fetching task details: $e");
      return {"status": false, "message": e.toString()};
    }
  }

  // --------------Method to update the task status pending to complete--------------------
  Future<Map<String, dynamic>> updateTaskStatus(String taskId) async {
    try {
      final response = await _dio.post(
        middUpdateStatusToComplete,
        data: {"taskId": taskId},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return {"status": true, "message": "Task status updated successfully"};
      } else {
        return {"status": false, "message": "Failed to update task status"};
      }
    } catch (e) {
      print("Error updating task status: $e");
      return {"status": false, "message": e.toString()};
    }
  }
}
