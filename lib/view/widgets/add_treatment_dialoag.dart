import 'package:ayurveda/controller/patient_registration.dart';
import 'package:ayurveda/controller/registration_provider.dart';
import 'package:ayurveda/model/treatment_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTreatmentDialog extends StatefulWidget {
  final TreatmentSelection? existingSelection;

  const AddTreatmentDialog({Key? key, this.existingSelection}) : super(key: key);

  @override
  State<AddTreatmentDialog> createState() => _AddTreatmentDialogState();
}

class _AddTreatmentDialogState extends State<AddTreatmentDialog> {
  Treatment? _selectedTreatment;
  int _maleCount = 0;
  int _femaleCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.existingSelection != null) {
      _selectedTreatment = widget.existingSelection!.treatment;
      _maleCount = widget.existingSelection!.maleCount;
      _femaleCount = widget.existingSelection!.femaleCount;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationProvider>();
final size=MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 350),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Treatment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Treatment>(
                isExpanded: true,
                value: _selectedTreatment,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                hint: const Text('Choose preferred treatment'),
                items: provider.treatments.map((treatment) {
                  return DropdownMenuItem(
                    value: treatment,
                    child: Text(treatment.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTreatment = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Add Patients',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              _buildPatientCounter('Male', _maleCount, (count) {
                setState(() {
                  _maleCount = count;
                });
              }),
              const SizedBox(height: 16),
              _buildPatientCounter('Female', _femaleCount, (count) {
                setState(() {
                  _femaleCount = count;
                });
              }),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: size.height*0.06,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedTreatment != null && (_maleCount > 0 || _femaleCount > 0)) {
                      context.read<RegistrationProvider>().addTreatment(
                            _selectedTreatment!,
                            _maleCount,
                            _femaleCount,
                          );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select treatment and add patients')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006837),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientCounter(String label, int count, Function(int) onChanged) {
    final size=MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (count > 0) onChanged(count - 1);
                },
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF006837),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(36, 36),
                ),
                icon: const Icon(Icons.remove, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Container(
                width: size.width*0.095,
                height: size.height*0.05,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Center(
                  child: Text(
                    count.toString(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () => onChanged(count + 1),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF006837),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(36, 36),
                ),
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
