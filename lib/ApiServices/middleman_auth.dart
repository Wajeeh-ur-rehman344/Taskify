import 'package:dio/dio.dart';
import '../URLs/config.dart';

class middlemanAuth {
  // Initialize Dio with proper configuration
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    validateStatus: (status) => status != null && status < 500,
  ));

  //------------------------------------middleman register--------------------------------
  Future<dynamic> middlemanRegister(String email, String phone) async {
    try {
      Response response = await _dio.post(
        middlemanRegisters,
        data: {"email": email, "phone": phone},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print(response.data);

      if (response.statusCode == 200) {
        return {
          "status": true,
          "user": response.data['user']
        }; // Ensure correct structure
      } else {
        return {
          "status": false,
          "message": response.data['message'] ?? "Registration failed"
        };
      }
    } catch (e) {
      print("API Error: $e");
      return {
        "status": false,
        "message": "Network error. Please try again."
      }; // Return map, not string
    }
  }

  //------------------------------------middleman Email and Phone Verification--------------------------------
  Future<dynamic> middlemanEmailPhoneVerification(
      String middId, String emailOtp, String phoneOtp) async {
    try {
      Response response = await _dio.put(
        middlemanOtpVerify,
        data: {"id": middId, "emailOtp": emailOtp, "phoneOtp": phoneOtp},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print(response.data);

      if (response.statusCode == 200) {
        return {
          "status": true,
        };
      } else {
        return {
          "status": false,
          "message": response.data['message'] ?? "Verification failed"
        };
      }
    } catch (e) {
      print("API Error: $e");
      return {"status": false, "message": "Network error. Please try again."};
    }
  }

  //------------------------------------middleman details--------------------------------
  Future<dynamic> middlemanDetails({
    required String id,
    required String name,
    required String dob,
    required String cnic,
    required String address,
    required String password,
    required String cnicImagePath,
  }) async {
    try {
      // Create FormData to handle file upload
      FormData formData = FormData.fromMap({
        "middId": id,
        "name": name,
        "dob": dob,
        "cnic": cnic,
        "address": address,
        "password": password,
        "cnicImage": await MultipartFile.fromFile(cnicImagePath,
            filename: "cnic_image.jpg"),
      });

      Response response = await _dio.put(
        midRegisterDetails, // Backend endpoint
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        return {
          "status": true,
          "data": response.data['data'],
        };
      } else {
        return {
          "status": false,
          "message": response.data['message'] ?? "Details submission failed",
        };
      }
    } catch (e) {
      print("API Error: $e");
      return {
        "status": false,
        "message": "Network error. Please try again.",
      };
    }
  }

  //------------------------------------middleman login--------------------------------
  Future<dynamic> middlemanLogin(String email, String password) async {
    try {
      Response response = await _dio.post(
        middlemanlogin,
        data: {"email": email, "password": password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("middleman login: ${response.data}");

      if (response.statusCode == 200) {
        return {
          "status": true,
          "userId": response.data['user'], //user id
          "token": response.data['token'] //token
        };
      } else {
        return {
          "status": false,
          "message": response.data['message'] ?? "Login failed"
        };
      }
    } catch (e) {
      print("API Error: $e");
      return {"status": false, "message": "Network error. Please try again."};
    }
  }

  //------------------------------------middleman forget password --------------------------------
  Future<dynamic> middlemanForgetPassword(String email) async {
    try {
      Response response = await _dio.post(
        midForgetpassword,
        data: {"email": email},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("middleman forget password: ${response.data}");

      if (response.statusCode == 200) {
        return {
          "status": true,
          "userId": response.data['user'] //user id
        };
      } else {
        return {
          "status": false,
          "message": response.data['message'] ?? "Password reset failed"
        };
      }
    } catch (e) {
      print("API Error: $e");
      return {"status": false, "message": "Network error. Please try again."};
    }
  }

  //------------------------------------middleman verify otp--------------------------------
  Future<dynamic> middlemanVerifyOtp(String id, String otp) async {
    try {
      Response response = await _dio.put(
        midVerifyOtp,
        data: {
          "id": id,
          "emailOtp": otp,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("middleman verify otp: ${response.data}");

      if (response.statusCode == 200) {
        return {
          "status": true,
        };
      } else {
        return {
          "status": false,
          "message": response.data['message'] ?? "OTP verification failed"
        };
      }
    } catch (e) {
      print("API Error: $e");
      return {"status": false, "message": "Network error. Please try again."};
    }
  }

  //------------------------------------middleman resend otp--------------------------------
  Future<dynamic> middlemanResendOtp(String email) async {
    try {
      Response response = await _dio.put(
        midResendOtp,
        data: {"email": email},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("middleman resend otp: ${response.data}");

      if (response.statusCode == 200) {
        return {
          "status": true,
        };
      } else {
        return {
          "status": false,
          "message": response.data['message'] ?? "OTP resend failed"
        };
      }
    } catch (e) {
      print("API Error: $e");
      return {"status": false, "message": "Network error. Please try again."};
    }
  }

  //------------------------------------middleman update password--------------------------------
  Future<dynamic> middlemanUpdatePassword(String email, String password) async {
    try {
      Response response = await _dio.put(
        midUpdatePass,
        data: {"email": email, "password": password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("middleman update password: ${response.data}");

      if (response.statusCode == 200) {
        return {
          "status": true,
        };
      } else {
        return {
          "status": false,
          "message": response.data['message'] ?? "Password update failed"
        };
      }
    } catch (e) {
      print("API Error: $e");
      return {"status": false, "message": "Network error. Please try again."};
    }
  }

  //------------------------------------upload profile picture--------------------------------
  Future<dynamic> uploadProfilePicture({
    required String middId,
    required String profilePicPath,
  }) async {
    try {
      // Create FormData to handle file upload
      FormData formData = FormData.fromMap({
        "middId": middId,
        "profilePic": await MultipartFile.fromFile(
          profilePicPath,
          filename: "profile_picture.jpg",
        ),
      });

      // Send the request to the backend
      Response response = await _dio.put(
        midProfilePic, // Backend endpoint
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        return {
          "status": true,
          "data": response.data['data'],
        };
      } else {
        return {
          "status": false,
          "message":
              response.data['message'] ?? "Profile picture upload failed",
        };
      }
    } catch (e) {
      print("API Error: $e");
      return {
        "status": false,
        "message": "Network error. Please try again.",
      };
    }
  }
}
