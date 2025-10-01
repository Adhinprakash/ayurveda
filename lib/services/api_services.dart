import 'dart:convert';

import 'package:ayurveda/const/api_url.dart';
import 'package:ayurveda/model/login_response_model.dart';
import 'package:http/http.dart'as http;

class ApiServices {



static Future<LoginResponse>login(String username,String password)async{


Uri url=buildBaseUrl("Login");

try {
  final response= await http.post(url,body: jsonEncode({
    "username":username,
    "password":password
  }));
  if(response.statusCode==200){
    final data = json.decode(response.body);
    return LoginResponse( message: data);
  } else{
   return LoginResponse(message: "Login failed with status: ${response.statusCode}");

  }
} catch (e) {
        throw Exception('Failed to login: $e');

}

}



}