import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/register_view.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/register',
    routes: {
      '/register':(context)=>RegisterView()
    },
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
     
    );
  }
}
