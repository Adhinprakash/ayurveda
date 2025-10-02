  import 'package:ayurveda/controller/patient_registration.dart';
import 'package:ayurveda/controller/registration_provider.dart';
import 'package:ayurveda/view/widgets/add_treatment_dialoag.dart';
import 'package:flutter/material.dart';

Widget buildTreatmentCard(
    int index,
    TreatmentSelection selection,
    RegistrationProvider provider,
    BuildContext context
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$index. ${selection.treatment.name}',
                  style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 17),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20, color: Color(0xFF006837)),
                    onPressed: () {
                      showDialog(
                        context:context ,
                        builder: (_) => AddTreatmentDialog(existingSelection: selection),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: Colors.red),
                    onPressed: () {
                      provider.removeTreatment(selection.treatment.id);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text('Male', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color.fromARGB(255, 4, 83, 9)!),
                      ),
                      child: Text('${selection.maleCount}'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Text('Female', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color.fromARGB(255, 4, 83, 9)!),
                      ),
                      child: Text('${selection.femaleCount}'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }