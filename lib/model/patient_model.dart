
class PatientListResponse {
  final bool status;
  final String message;
  final List<Patient> patients;

  PatientListResponse({
    required this.status,
    required this.message,
    required this.patients,
  });

  factory PatientListResponse.fromJson(Map<String, dynamic> json) {
    return PatientListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      patients: (json['patient'] as List?)
              ?.map((e) => Patient.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Patient {
  final int id;
  final String name;
  final String phone;
  final String address;
  final String payment;
  final double totalAmount;
  final double discountAmount;
  final double advanceAmount;
  final double balanceAmount;
  final DateTime dateTime;
  final List<PatientDetail> patientDetails;

  Patient({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.payment,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.dateTime,
    required this.patientDetails,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      payment: json['payment'] ?? 'cash',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      advanceAmount: (json['advance_amount'] ?? 0).toDouble(),
      balanceAmount: (json['balance_amount'] ?? 0).toDouble(),
      dateTime: DateTime.parse(json['date_nd_time'] ?? DateTime.now().toIso8601String()),
      patientDetails: (json['patientdetails_set'] as List?)
              ?.map((e) => PatientDetail.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PatientDetail {
  final int id;
  final String male;
  final String female;
  final int? treatment;

  PatientDetail({
    required this.id,
    required this.male,
    required this.female,
    this.treatment,
  });

  factory PatientDetail.fromJson(Map<String, dynamic> json) {
    return PatientDetail(
      id: json['id'] ?? 0,
      male: json['male'] ?? '',
      female: json['female'] ?? '',
      treatment: json['treatment'],
    );
  }
}
