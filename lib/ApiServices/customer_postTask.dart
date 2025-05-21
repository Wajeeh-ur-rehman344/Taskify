import 'dart:io';
import 'package:dio/dio.dart';
import '../URLs/config.dart';

class CustomerPostTask {
  // Initialize Dio with proper configuration
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    validateStatus: (status) => status != null && status < 500,
  ));

  //------------------------------------customer post task--------------------------------
  Future<Map<String, dynamic>> customerPostTask({
    required String custId,
    required String title,
    required String description,
    required String custlocation,
    required String custlocationwords,
    required String category,
    required String type,
    required String bidAmount,
    File? image, // Optional image file
  }) async {
    try {
      // Prepare FormData for the request
      FormData formData = FormData.fromMap({
        "custId": custId,
        "title": title,
        "description": description,
        "custlocation": custlocation,
        "custlocationwords": custlocationwords,
        "category": category,
        "type": type,
        "bidAmount": bidAmount,
        if (image != null)
          "image": await MultipartFile.fromFile(image.path,
              filename: image.path.split('/').last),
      });

      final response = await _dio.post(
        customerTaskPost, // Replace with the actual task-posting endpoint
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      // Return true if the task was posted successfully (status == true)
      if (response.statusCode == 201 && response.data['status'] == true) {
        return {"status": true, "taskId": response.data['data']};
      } else {
        return {"status": false, "message": "Failed to post task"};
      }
    } catch (e) {
      print("Error posting task: $e");
      return {"status": false, "message": "Error posting task"};
    }
  }

  //------------------------------------customer post task--------------------------------
  Future<Map<String, dynamic>> custShowMiddTask(String taskId) async {
    try {
      final response = await _dio.post(
        custShowStartTask,
        data: {"taskId": taskId},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("API Response: ${response.data}"); // Debug print

      if (response.statusCode == 200 && response.data['status'] == true) {
        return {
          "status": true,
          "data": response.data['data'][0] // Get first item from array
        };
      } else {
        return {"status": false, "message": "Failed to fetch task details"};
      }
    } catch (e) {
      print("Error fetching task details: $e");
      return {"status": false, "message": "Error fetching task details"};
    }
  }
}
