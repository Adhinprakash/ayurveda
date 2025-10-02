import 'package:ayurveda/controller/auth_controller.dart';
import 'package:ayurveda/controller/patientList_controller.dart';
import 'package:ayurveda/controller/registration_provider.dart';
import 'package:ayurveda/view/pages/login_page.dart';
import 'package:ayurveda/view/pages/splasj_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: 
    [
ChangeNotifierProvider(create: (_)=>AuthProvider()),
ChangeNotifierProvider(create: (_)=>PatientlistController()),
ChangeNotifierProvider(create: (_)=>RegistrationProvider())

    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme
       ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  SplashScreen()
    )
    );
  }
}
