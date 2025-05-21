import 'package:dio/dio.dart';
import '../URLs/config.dart';

class custAuth {
  // Initialize Dio with proper configuration
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    validateStatus: (status) => status != null && status < 500,
  ));

  //------------------------------------customer register--------------------------------
  Future<dynamic> customerregister(
      String name, String email, String password, String phone) async {
    try {
      Response response = await _dio.post(
        customerRegister,
        data: {
          "name": name,
          "email": email,
          "password": password,
          "phone": phone
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Return status code and data for consistent response handling
      return response.statusCode == 200 ? response.data['user']['_id'] : "";
    } catch (e) {
      return e.toString();
    }
  }

  //------------------------------------customer otp verify--------------------------------
  Future<Map<String, dynamic>> customerOtpVerify(String otp, String id) async {
    try {
      Response response = await _dio.post(
        customerVerifyOtp,
        data: {
          "id": id,
          "otp": otp,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      return response.statusCode == 200
          ? {
              "status": true,
              'token': response.data['token'],
              'user': response.data['customer']['_id']
            }
          : {
              "status": false,
              'message': response.data['message'] ?? 'Verification failed'
            };
    } catch (e) {
      return {'message': e.toString()};
    }
  }

  //------------------------------------customer resend otp--------------------------------
  Future<Map<String, dynamic>> customerResendOtp(String email) async {
    try {
      Response response = await _dio.put(
        customerResendOtps,
        data: {'email': email},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return {"status": true};
      } else {
        return {
          "status": false,
          'message': response.data?['message'] ?? 'Failed to resend OTP'
        };
      }
    } catch (e) {
      return {"status": false, 'message': e.toString()};
    }
  }

  //------------------------------------customer login--------------------------------
  Future<Map<String, dynamic>> customerLogin(String email, String password) async {
    try {
      Response response = await _dio.post(
        customerlogins,
        data: {
          "email": email,
          "password": password
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      return response.statusCode == 200
          ? {
              "status": true,
              'token': response.data['token'],
              'userId': response.data['user']  
            }
          : {
              "status": false,
              'message': response.data['message'] ?? 'Login failed'
            };
    } catch (e) { 
      return {'message': e.toString()};
    }
  }

  //------------------------------------customer forget password--------------------------------
  Future<Map<String, dynamic>> customerForgetPassword(String email) async {
    try {
      Response response = await _dio.post(
        customerForgetPass,
        data: {'email': email},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      return response.statusCode == 200
          ? {
              "status": true,
              'message': response.data['message'] ?? 'Password reset email sent'
            }
          : {
              "status": false,
              'message': response.data['message'] ?? 'Failed to reset password'
            };
    } catch (e) {
      return {'message': e.toString()};
    }
  }

  //------------------------------------customer update password--------------------------------
  Future<Map<String, dynamic>> customerUpdatePassword(String email) async {
    try {
      Response response = await _dio.put(
        customerForgetPass,
        data: {
          "email": email,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      return response.statusCode == 200
          ? {
              "status": true,
              'userId': response.data['user'] //_id of customer
            }     
          : {
              "status": false,
              'message': response.data['message'] ?? 'Failed to update password'
            };
    } catch (e) {
      return {'message': e.toString()};
    }
  }

  //------------------------------------customer forget and update password--------------------------------
  Future<Map<String, dynamic>> customerForgetAndUpdatePassword(String email, String password) async {
    try {
      Response response = await _dio.put(
        customerUpdatePass,
        data: {
          "email": email,
          "password": password
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          ),
        );

      return response.statusCode == 200
          ? {
              "status": true,
            } 
          : {"message": "Failed to update password"};
    } catch (e) {
      return {'message': e.toString()};
    }
  }

}
