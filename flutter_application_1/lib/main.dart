import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/home.dart';
import 'package:flutter_application_1/views/login_view.dart';
import 'package:flutter_application_1/views/movie_view.dart';
import 'package:flutter_application_1/views/register_view.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/register',
    routes: {
      '/register':(context)=>RegisterView(),
      '/login':(context)=>LoginView(),
      '/home':(context)=>Home(),
      '/movie':(context)=>MovieView(),
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
