import 'package:dio/dio.dart';
import 'package:frontend/app/app_url.dart';
import 'package:frontend/app/util.dart';
import 'package:frontend/widgets/components.dart';

class AuthController {
  final Dio _dio = Dio();
  Future<bool> login(
    String email,
    String password,
  ) async {
    try {
      Response res = await _dio
          .post(AppUrl.login, data: {"username": email, "password": password});
      if (res.statusCode == 201 || res.statusCode == 200) {
        Components.logMessage("Login Successfull");
        Components.logMessage(res.data.toString());
        Components.logMessage(res.data['id'].toString());

        storage.write("id", res.data['id']);
        return true;
      } else {
        Components.logErrMessage("Failed to Login", res.statusCode.toString());
        return false;
      }
    } catch (e) {
      Components.logErrMessage("Failed to Login", e.toString());
      return false;
    }
  }
}
