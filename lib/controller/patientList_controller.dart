import 'package:ayurveda/model/patient_model.dart';
import 'package:ayurveda/services/api_services.dart';
import 'package:flutter/material.dart';

class PatientlistController extends ChangeNotifier{
bool _isLoading=false;
List<Patient>_patient=[];
   String _errorMessage="";

   bool get isloading=>_isLoading;
   List<Patient>get patient=>_patient;
   String get errorMessage=>_errorMessage;



   Future<void>fetchpatientlist(String token)async{
  
_isLoading=true;
_errorMessage="";
notifyListeners();


try {
  final response= await ApiServices.getPatientList(token);

  if(response.status){
    _patient=response.patients;
    // notifyListeners()
  }else{
 _errorMessage=response.message;
  }
} catch (e) {
     _errorMessage="Failed to load patients";
}finally{
  _isLoading=false;
  notifyListeners();
}



   }




}