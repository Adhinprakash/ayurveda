
class TreatmentListResponse {
  final bool status;
  final String message;
  final List<Treatment> treatments;

  TreatmentListResponse({
    required this.status,
    required this.message,
    required this.treatments,
  });

  factory TreatmentListResponse.fromJson(Map<String, dynamic> json) {
    return TreatmentListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      treatments: (json['treatments'] as List?)
              ?.map((e) => Treatment.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Treatment {
  final int id;
  final String name;
  final String duration;
  final String price;
  final bool isActive;
  final List<TreatmentBranch> branches;

  Treatment({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.isActive,
    required this.branches,
  });

  double get priceValue => double.tryParse(price) ?? 0.0;

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      duration: json['duration'] ?? '',
      price: json['price']?.toString() ?? '0',
      isActive: json['is_active'] ?? true,
      branches: (json['branches'] as List?)
              ?.map((e) => TreatmentBranch.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TreatmentBranch {
  final int id;
  final String name;
  final int patientsCount;
  final String location;
  final String phone;
  final String mail;
  final String address;
  final String gst;
  final bool isActive;

  TreatmentBranch({
    required this.id,
    required this.name,
    required this.patientsCount,
    required this.location,
    required this.phone,
    required this.mail,
    required this.address,
    required this.gst,
    required this.isActive,
  });

  factory TreatmentBranch.fromJson(Map<String, dynamic> json) {
    return TreatmentBranch(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      patientsCount: json['patients_count'] ?? 0,
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      mail: json['mail'] ?? '',
      address: json['address'] ?? '',
      gst: json['gst'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }
}