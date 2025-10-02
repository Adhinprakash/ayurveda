import 'package:ayurveda/model/treatment_list_model.dart';

class TreatmentSelection {
  final Treatment treatment;
  int maleCount;
  int femaleCount;

  TreatmentSelection({
    required this.treatment,
    this.maleCount = 0,
    this.femaleCount = 0,
  });

  double get total => (maleCount + femaleCount) * treatment.priceValue;
}
