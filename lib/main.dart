import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'pages/login_page.dart';


void main() {
  runApp(const LevelerApp());
}


class LevelerApp extends StatelessWidget {
  const LevelerApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Leveler',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}
