import 'dart:convert';

import 'package:ayurveda/const/api_url.dart';
import 'package:ayurveda/model/login_response_model.dart';
import 'package:ayurveda/model/patient_model.dart';
import 'package:http/http.dart'as http;

class ApiServices {

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };


static Future<LoginResponse>login(String username,String password)async{


Uri url=buildBaseUrl("Login");
print(url);

try {

  
  final response= await http.post(url,
   headers: {
     'Content-Type': 'application/json',
     'Accept': 'application/json',
  },
  body: jsonEncode({
    "username":username,
    "password":password
  }),);
  if(response.statusCode==200){
    final data = json.decode(response.body);
    return LoginResponse.fromJson(data);
  } else{
   return LoginResponse(message: "Login failed with status: ${response.statusCode}");

  }
} catch (e) {
        throw Exception('Failed to login: $e');

}

}

static Future<PatientListResponse>getPatientList(String token)async{
Uri url=buildBaseUrl("PatientList");
try {
  final response= await http.get(url,headers: {
          'Authorization': 'Bearer $token',

  });

  final data = json.decode(response.body);
  return PatientListResponse.fromJson(data);
} catch (e) {
  throw Exception("failed to fetch patient list $e");
}


}



}