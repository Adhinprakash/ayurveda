import 'package:ayurveda/controller/auth_controller.dart';
import 'package:ayurveda/controller/patientList_controller.dart';
import 'package:ayurveda/view/pages/register_now_page.dart';
import 'package:ayurveda/view/widgets/patient_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PatientListScreen extends StatefulWidget {
  const PatientListScreen({Key? key}) : super(key: key);

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final TextEditingController _searchController = TextEditingController();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = context.read<AuthProvider>().token;
      if (token != null) {
        context.read<PatientlistController>().fetchpatientlist(token);
      }
    });
  }
  

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshPatientList() async {
  final token = context.read<AuthProvider>().token;
  if (token != null) {
    await context.read<PatientlistController>().fetchpatientlist(token);
  }
}

  @override
  Widget build(BuildContext context) {

    final patientProvider = context.watch<PatientlistController>();
final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.black,size: 30,),
                onPressed: () {},
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: size.height*0.05  ,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for treatments',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (value) {
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                            height: size.height*0.05  ,
 
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF006837),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sort by :',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                    height: size.height*0.05  ,

                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text("Date")
                      ,
                      DropdownButton<String>(
                    
                    underline: const SizedBox(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: ['Date', 'Name'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                      }
                    },
                  )
                    ],
                  ),
                ),
              ],
            ),
          ),

           SizedBox(height: 16),
           const Divider(color: Colors.grey,),

          Expanded(
            
            child: patientProvider.isloading
            ?Center(child: CircularProgressIndicator(),)
            :patientProvider.patient.isEmpty
            ?const Center(child: Text("No patients found"),)
            :
                     RefreshIndicator(
                      onRefresh: _refreshPatientList,
                       child: ListView.builder(
                        
                        itemCount: patientProvider.patient.length,
                          padding:  EdgeInsets.symmetric(horizontal: 16),
                                 
                          itemBuilder: (context, index) {
                            final patient =patientProvider.patient[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PatientCard(
                                patient: patient,
                                index: index+1,
                              ),
                            );
                          },
                        ),
                     ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterNowPage()));

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006837),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Register Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}