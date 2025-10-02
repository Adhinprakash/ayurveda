import 'package:ayurveda/model/patient_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatientCard extends StatelessWidget {
  final int index;
  final Patient patient;
  PatientCard({
    super.key,
    required this.index,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    // final dateFormat = DateFormat('dd/MM/yyyy');

    String formattedDate = "";

    final treatmentname = patient.patientDetails.isNotEmpty
        ? patient.patientDetails.first.treatmentName
        : 'Couple Combo Package (Rejuven...)';


final dateFormat = DateFormat('dd/MM/yyyy'); 

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(233, 237, 242, 247),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$index .",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    treatmentname,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 16, color: Colors.red[300]),
                      const SizedBox(width: 6),
                      Text(
                        dateFormat.format(patient.dateTime),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.person_outline,
                          size: 16, color: Colors.red[300]),
                      const SizedBox(width: 6),
                      Text(
                        'Jithesh',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'View Booking details',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 18, color: Colors.green[700]),
                    ],
                  ),
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}
