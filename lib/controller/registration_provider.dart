import 'package:ayurveda/controller/patient_registration.dart';
import 'package:ayurveda/model/branch_model.dart';
import 'package:ayurveda/model/treatment_list_model.dart';
import 'package:ayurveda/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistrationProvider extends ChangeNotifier{
  bool _isLoading = false;
  List<Treatment> _treatments = [];
  List<Branch> _branches = [];
  List<TreatmentSelection> _selectedTreatments = [];
  Branch? _selectedBranch;
  String _selectedLocation = 'Kozhikode';
  String _paymentOption = 'Cash';
  String? _errorMessage;

  double _totalAmount = 0;
  double _discountAmount = 0;
  double _advanceAmount = 0;
  double _balanceAmount = 0;
  DateTime _treatmentDate = DateTime.now();
  TimeOfDay _treatmentTime = TimeOfDay.now();


  String? get errorMessage => _errorMessage;


  bool get isLoading => _isLoading;
  List<Treatment> get treatments => _treatments;
  List<Branch> get branches => _branches;
  List<TreatmentSelection> get selectedTreatments => _selectedTreatments;
  Branch? get selectedBranch => _selectedBranch;
  String get selectedLocation => _selectedLocation;
  String get paymentOption => _paymentOption;
  double get totalAmount => _totalAmount;
  double get discountAmount => _discountAmount;
  double get advanceAmount => _advanceAmount;
  double get balanceAmount => _balanceAmount;
  DateTime get treatmentDate => _treatmentDate;
  TimeOfDay get treatmentTime => _treatmentTime;



  void setlocation(String location){
    _selectedLocation=location;
    notifyListeners();
  }

void setBranch(Branch branch){
  _selectedBranch=branch;
  notifyListeners();
}
  void setPaymentOption(String option) {
    _paymentOption = option;
    notifyListeners();
  }

  void setTreatmentDate(DateTime date) {
    _treatmentDate = date;
    notifyListeners();
  }

  void setTreatmentTime(TimeOfDay time) {
    _treatmentTime = time;
    notifyListeners();
  }


  void addTreatment(Treatment treatment, int maleCount, int femaleCount) {
    final existing = _selectedTreatments.firstWhere(
      (t) => t.treatment.id == treatment.id,
      orElse: () => TreatmentSelection(treatment: treatment),
    );

    if (!_selectedTreatments.contains(existing)) {
      existing.maleCount = maleCount;
      existing.femaleCount = femaleCount;
      _selectedTreatments.add(existing);
    } else {
      existing.maleCount = maleCount;
      existing.femaleCount = femaleCount;
    }

    _calculateTotal();
    notifyListeners();
  }

  
void setdiscount(double amount){
  _discountAmount=amount;
      _calculateTotal();

  notifyListeners();
}
void saveadvanceamount(double amount){
  _advanceAmount=amount;
  notifyListeners();
      _calculateTotal();

}

  void removeTreatment(int treatmentId) {
    _selectedTreatments.removeWhere((t) => t.treatment.id == treatmentId);
    _calculateTotal();
    notifyListeners();
  }

  void updateMaleCount(int treatmentId, int count) {
    final treatment = _selectedTreatments.firstWhere(
      (t) => t.treatment.id == treatmentId,
    );
    treatment.maleCount = count;
    _calculateTotal();
    notifyListeners();
  }

  void updateFemaleCount(int treatmentId, int count) {
    final treatment = _selectedTreatments.firstWhere(
      (t) => t.treatment.id == treatmentId,
    );
    treatment.femaleCount = count;
    _calculateTotal();
    notifyListeners();
  }

  void _calculateTotal() {
    _totalAmount = _selectedTreatments.fold(0, (sum, t) => sum + t.total);
    _balanceAmount = _totalAmount - _discountAmount - _advanceAmount;
  }



Future<void>fetchtreatmentDetails(String token)async{
  _isLoading=true;
  notifyListeners();
try {
  final data= await ApiServices.gerTreatmentlist(token);
_treatments=data.treatments;

} catch (e) {
        print('Error fetching treatments: $e');

}finally{
  _isLoading = false;
      notifyListeners();
}


}


  Future<void> fetchBranches(String token) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await ApiServices.getBranchList(token);
      _branches = response.branches;
    } catch (e) {
      print('Error fetching branches: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

 Map<String, dynamic> getFormData(String name, String phone, String address) {
    final dateTime = DateTime(
      _treatmentDate.year,
      _treatmentDate.month,
      _treatmentDate.day,
      _treatmentTime.hour,
      _treatmentTime.minute,
    );

    final formattedDateTime = DateFormat('dd/MM/yyyy-hh:mm a').format(dateTime);

    final maleIds = <String>[];
    final femaleIds = <String>[];

    for (var selection in _selectedTreatments) {
      for (int i = 0; i < selection.maleCount; i++) {
        maleIds.add(selection.treatment.id.toString());
      }
      for (int i = 0; i < selection.femaleCount; i++) {
        femaleIds.add(selection.treatment.id.toString());
      }
    }

    final treatmentIds = _selectedTreatments
        .map((t) => t.treatment.id.toString())
        .join(',');

    return {
      'name': name,
      'excecutive': 'Admin',
      'payment': _paymentOption.toLowerCase(),
      'phone': phone,
      'address': address,
      'total_amount': _totalAmount.toStringAsFixed(0),
      'discount_amount': _discountAmount.toStringAsFixed(0),
      'advance_amount': _advanceAmount.toStringAsFixed(0),
      'balance_amount': _balanceAmount.toStringAsFixed(0),
      'date_nd_time': formattedDateTime,
      'id': '',
      'male': maleIds.join(','),
      'female': femaleIds.join(','),
      'branch': _selectedBranch?.id.toString() ?? '',
      'treatments': treatmentIds,
    };
  }


  Future<bool>registerpatient(String name,String phone,String address,String token)async{
_isLoading=true;
_errorMessage=null;
notifyListeners();
try {
  final formdata=getFormData(name, phone, address);

        final response = await ApiServices.registerPatient(token, formdata);

        if(response['status']==true){

          
        notifyListeners();
return true;
        }else{
          _errorMessage = response['message'] ?? 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
        }
  
} catch (e) {
_errorMessage = 'Error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
}

  }

  void reset() {
    _selectedTreatments.clear();
    _selectedBranch = null;
    _totalAmount = 0;
    _discountAmount = 0;
    _advanceAmount = 0;
    _balanceAmount = 0;
    notifyListeners();
  }
}