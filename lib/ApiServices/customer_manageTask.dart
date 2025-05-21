import 'dart:io';
import 'package:dio/dio.dart';
import '../URLs/config.dart';

class CustomerManageTask {
  // Initialize Dio with proper configuration
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    validateStatus: (status) => status != null && status < 500,
  ));

  //---------------------- Fetch tasks for a customer by userId ----------------------
  Future<Map<String, dynamic>> custManageTask(String userId) async {
    print("Fetching tasks for userId: $userId");
    try {
      final response = await _dio.post(
        custShowManageTask, // Adjust if your route is different
        data: {"userId": userId},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      print("Response from server: ${response.statusCode}");
      if (response.statusCode == 200) {
        return {
          "status": true,
          "data": response.data['response'] ?? response.data
        };
      } else {
        return {
          "status": false,
          "message": "Failed to fetch tasks",
        };
      }
    } catch (e) {
      print("Error fetching managed tasks: $e");
      return {
        "status": false,
        "data": [],
      };
    }
  }

  //---------------------- Accept customer Task to Middleman ----------------------
  Future<Map<String, dynamic>> custAcceptMidd(String middId, String taskId) async {
    try {
      print("Accepting task with middId: $middId and taskId: $taskId");
      final response = await _dio.post(
        custAcceptMidds, // Adjust if your route is different
        data: {"middId": middId, "taskId": taskId},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      print("object: ${response.statusCode}");
      if (response.statusCode == 200) {
        return {
          "status": true,
        };
      } else {
        return {
          "status": false,
          "message": response.data['message'] ?? "Failed to accept task",
        };
      }
    } catch (e) {
      print("Error fetching managed tasks: $e");
      return {
        "status": false,
        "message": "Internal server error",
      };
    }
  }
}
