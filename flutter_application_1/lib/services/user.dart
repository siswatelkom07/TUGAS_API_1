import 'dart:convert';

import 'package:flutter_application_1/models/login_model.dart';
import 'package:flutter_application_1/models/response_data_map.dart';
import 'package:flutter_application_1/services/url.dart' as url;
import 'package:http/http.dart' as http;


class UserService {
  Future registerUser(data) async {
    var uri = Uri.parse(url.BaseUrl + "register_admin");
    var register = await http.post(uri, body: data);


    if (register.statusCode == 200) {
      var data = json.decode(register.body);
      if (data["status"] == true) {
        ResponseDataMap response = ResponseDataMap(
            status: true, message: "Sukses menambah user", data: data);
        return response;
      } else {
        var message = '';
        for (String key in data["message"].keys) {
          message += data["message"][key][0].toString() + '\n';
        }
        ResponseDataMap response =
            ResponseDataMap(status: false, message: message);
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
          status: false,
          message:
              "gagal menambah user dengan code error ${register.statusCode}");
      return response;
      
    } 
  }
  Future loginUser(data) async {
    var uri = Uri.parse(url.BaseUrl + "login");
    print("Login URL: $uri"); // Debug print
    print("Login Data: $data"); // Debug print
    var register = await http.post(uri, body: data);

    print("Response Status Code: ${register.statusCode}"); // Debug print
    print("Response Body: ${register.body}"); // Debug print

    if (register.statusCode == 200) {
      var responseData = json.decode(register.body);
      if (responseData["status"] == true) {
        var userData = responseData["data"];
        UserLogin userLogin = UserLogin(
            status: responseData["status"],
            token: responseData["authorisation"]["token"],
            message: responseData["message"],
            id: userData["id"],
            nama_user: userData["name"],
            email: userData["email"],
            role: userData["role"]);
        await userLogin.prefs();
        ResponseDataMap response = ResponseDataMap(
            status: true, message: "Sukses login user", data: responseData);
        print("Login Success: ${response.message}"); // Debug print
        return response;
      } else {
        ResponseDataMap response =
            ResponseDataMap(status: false, message: 'Email dan password salah');
        print("Login Failed: ${response.message}"); // Debug print
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
          status: false,
          message:
              "gagal menambah user dengan code error ${register.statusCode}");
      print("Login Error: ${response.message}"); // Debug print
      return response;
    }
  }

}