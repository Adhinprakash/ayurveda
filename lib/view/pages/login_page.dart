import 'package:ayurveda/controller/auth_controller.dart';
import 'package:ayurveda/view/pages/patient_list_page.dart';
import 'package:ayurveda/view/widgets/custom_button.dart';
import 'package:ayurveda/view/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
    final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
   LoginPage({super.key});



Future<void>handleLogin(BuildContext context)async{
if(_formKey.currentState!.validate()){
final authprovider =context.read<AuthProvider>();

final success= await authprovider.login(_emailController.text.trim(), _passwordController.text);

if(success){
    ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PatientListScreen()));

}else{
   ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authprovider.errorMessage ?? 'Login failed'),
              backgroundColor: Colors.red,
            ),
          );
}
}
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:Column(
          children: [
            Stack(
              children: [
                 Container(
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:const AssetImage('assets/images/login back image ayurveda.jpg'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child:Container(
                          height: 30,
                          width: 40,
                          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/app logo ayurveda.png"))),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Login Form Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key:_formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Login Or Register To Book',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        'Your Appointments',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 32),
                         CustomTextField(
                        label: 'Email',
                        placeholder: 'Enter your email',
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      CustomTextField(
                        label: 'Password',
                        placeholder: 'Enter password',
                        controller: _passwordController,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 80),

                      Consumer<AuthProvider>(builder: (context,authprovider,child){
                        return CustomButton(
                          isLoading: authprovider.isLoading,
                          text: "Login", onPressed: ()async{
                          handleLogin(context);
                        });
                      }),

                      const SizedBox(height: 130),


Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                            children: [
                              const TextSpan(
                                text: 'By creating or logging into an account you are agreeing\nwith our ',
                              ),
                              TextSpan(
                                text: 'Terms and Conditions',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
              ],
                  )))
          ]
        ) ,
      ),
    );
  }
}