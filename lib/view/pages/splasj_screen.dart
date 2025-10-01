import 'package:ayurveda/controller/auth_controller.dart';
import 'package:ayurveda/view/pages/login_page.dart';
import 'package:ayurveda/view/pages/patient_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  Future<void>checkLoginstatus()async{
    final authprovider=context.read<AuthProvider>();

    await authprovider.loadToken();
    await Future.delayed(Duration(seconds: 3));
    if(mounted){
      if(authprovider.isAuthenticated){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PatientListScreen()),
        );
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) =>  LoginPage()),
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoginstatus();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/ayurveda splash.png",
        fit: BoxFit.contain,
        height: double.infinity,
        width: double.infinity,
        ),
      )
      
    );
  }
}