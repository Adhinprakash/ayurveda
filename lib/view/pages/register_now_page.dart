import 'package:ayurveda/controller/auth_controller.dart';
import 'package:ayurveda/controller/patient_registration.dart';
import 'package:ayurveda/controller/registration_provider.dart';
import 'package:ayurveda/main.dart';
import 'package:ayurveda/view/pages/pdf.dart';
import 'package:ayurveda/view/widgets/add_treatment_dialoag.dart';
import 'package:ayurveda/view/widgets/radio_option_widget.dart';
import 'package:ayurveda/view/widgets/register_page_dropdowns.dart';
import 'package:ayurveda/view/widgets/regiter_page_textfield.dart';
import 'package:ayurveda/view/widgets/treatment_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegisterNowPage extends StatefulWidget {
  const RegisterNowPage({super.key});

  @override
  State<RegisterNowPage> createState() => _RegisterNowPageState();
}

class _RegisterNowPageState extends State<RegisterNowPage> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = context.read<AuthProvider>().token;
      if (token != null) {
        context.read<RegistrationProvider>().fetchtreatmentDetails(token);
        context.read<RegistrationProvider>().fetchBranches(token);
      }
    });

  }


    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _phoneController = TextEditingController();
    final _addressController = TextEditingController();
    final _discountController = TextEditingController();
    final _advanceController = TextEditingController();
    final List<String> _locations = [
      'Kozhikode',
      'Kottayam',
      'Ernakulam',
      'Thiruvananthapuram'
    ];


    

    Future<void> _selectdate() async {
      final DateTime? picked = await showDatePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime(2026),
          initialDate: DateTime.now());

      if (picked != null) {
        context.read<RegistrationProvider>().setTreatmentDate(picked);
      }
    }

    
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      context.read<RegistrationProvider>().setTreatmentTime(picked);
    }
  }

  
  void _showAddTreatmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTreatmentDialog(),
    );
  }

  Future<void>_submitform()async{
    if(_formKey.currentState!.validate()){
      final token =context.read<AuthProvider>().token;
      final registerprovider=context.read<RegistrationProvider>();

      if(token==null){
        return;
      }
          if (registerprovider.selectedTreatments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one treatment')),
      );
      return;
    }

    final result= await registerprovider.registerpatient(_nameController.text, _phoneController.text, _addressController.text, token);

    if(result==true){

      await PdfService.generatePatientPdf(
            name: _nameController.text,
            address: _addressController.text,
            phone: _phoneController.text,
            bookedOn: DateFormat('dd/MM/yyyy | hh:mm a').format(DateTime.now()),
            treatmentDate: DateFormat('dd/MM/yyyy').format(registerprovider.treatmentDate),
            treatmentTime: registerprovider.treatmentTime.format(context),
            treatments: registerprovider.selectedTreatments,
            totalAmount: registerprovider.totalAmount,
            discount: registerprovider.discountAmount,
            advance: registerprovider.advanceAmount,
            balance: registerprovider.balanceAmount,
            branch: registerprovider.selectedBranch,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Patient registered successfully!'), backgroundColor: Colors.green),
          );
          registerprovider.reset();
          Navigator.pop(context);

    }else{
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(registerprovider.errorMessage ?? 'Registration failed')),
      );
    }
    }
  }

  @override
  Widget build(BuildContext context) {


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
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                  size: 30,
                ),
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
      body:  Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Register', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Divider(height: 2,),
              const SizedBox(height: 20),

              buildTextField('Name', _nameController, 'Enter your full name'),
              const SizedBox(height: 16),

              buildTextField('Whatsapp Number', _phoneController, 'Enter your Whatsapp number'),
              const SizedBox(height: 16),

              buildTextField('Address', _addressController, 'Enter your full address', maxLines: 3),
              const SizedBox(height: 16),

              Consumer<RegistrationProvider>(
                builder: (context, provider, _) {
                  return buildDropdown('Location', provider.selectedLocation, _locations,
                      (value) => provider.setlocation(value!));
                },
              ),
              const SizedBox(height: 16),

              Consumer<RegistrationProvider>(
                builder: (context, provider, _) {
                  return buildDropdown(
                    'Branch',
                    provider.selectedBranch?.name,
                    provider.branches.map((b) => b.name).toList(),
                    (value) {
                      final branch = provider.branches.firstWhere((b) => b.name == value);
                      provider.setBranch(branch);
                    },
                    hint: 'Select the branch',
                  );
                },
              ),
              const SizedBox(height: 16),

              const Text('Treatments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Consumer<RegistrationProvider>(
                builder: (context, provider, _) {
                  return Column(
                    children: [
                      ...provider.selectedTreatments.asMap().entries.map((entry) {
                        return buildTreatmentCard(entry.key + 1, entry.value, provider,context);
                      }).toList(),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap:()async{
                          _showAddTreatmentDialog();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text('+ Add Treatments',
                                style: TextStyle(color: Color(0xFF006837), fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              Consumer<RegistrationProvider>(
                builder: (context, provider, _) {
                  return buildTextField(
                    'Total Amount',
                    TextEditingController(text: '₹${provider.totalAmount.toStringAsFixed(0)}'),
                    '',
                    readOnly: true,
                  );
                },
              ),
              const SizedBox(height: 16),

              buildTextField(
                'Discount Amount',
                _discountController,
                '',
                onChanged: (value) {
                  final amount = double.tryParse(value) ?? 0;
                  context.read<RegistrationProvider>().setdiscount(amount);
                },
              ),
              const SizedBox(height: 16),

              const Text('Payment Option', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Consumer<RegistrationProvider>(
                builder: (context, provider, _) {
                  return Row(
                    children: [
                      buildRadioOption('Cash', provider.paymentOption == 'Cash', () {
                        provider.setPaymentOption('Cash');
                      }),
                      const SizedBox(width: 16),
                      buildRadioOption('Card', provider.paymentOption == 'Card', () {
                        provider.setPaymentOption('Card');
                      }),
                      const SizedBox(width: 16),
                      buildRadioOption('UPI', provider.paymentOption == 'UPI', () {
                        provider.setPaymentOption('UPI');
                      }),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              buildTextField(
                'Advance Amount',
                _advanceController,
                '',
                onChanged: (value) {
                  final amount = double.tryParse(value) ?? 0;
                  context.read<RegistrationProvider>().saveadvanceamount(amount);
                },
              ),
              const SizedBox(height: 16),

              Consumer<RegistrationProvider>(
                builder: (context, provider, _) {
                  return buildTextField(
                    'Balance Amount',
                    TextEditingController(text: '₹${provider.balanceAmount.toStringAsFixed(0)}'),
                    '',
                    readOnly: true,
                  );
                },
              ),
              const SizedBox(height: 16),

              Consumer<RegistrationProvider>(
                builder: (context, provider, _) {
                  return InkWell(
                    onTap: ()async{



                    
                      _selectdate();
                    },
                    child: IgnorePointer(
                      child: buildTextField(
                        'Treatment Date',
                        TextEditingController(
                          text: DateFormat('dd/MM/yyyy').format(provider.treatmentDate),
                        ),
                        '',
                        suffixIcon: Icons.calendar_today,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
          Text("Treatment time", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Consumer<RegistrationProvider>(
                builder: (context, provider, _) {
                  return Row(
                    children: [
                      
                      Expanded(
                        child: InkWell(
                          onTap: _selectTime,
                          child: IgnorePointer(
                            child: buildTextField(
                              '',
                              TextEditingController(text: provider.treatmentTime.hourOfPeriod.toString().padLeft(2, '0')),
                              'Hour',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: _selectTime,
                          child: IgnorePointer(
                            child: buildTextField(
                              '',
                              TextEditingController(text: provider.treatmentTime.minute.toString().padLeft(2, '0')),
                              'Minutes',
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: size.height*0.06,
                child: ElevatedButton(
                  onPressed:()async{
                    _submitform();
                  } ,
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

 



}


