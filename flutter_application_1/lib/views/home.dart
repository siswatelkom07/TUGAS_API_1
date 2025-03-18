import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/login_model.dart';
import 'package:flutter_application_1/widgets/bottom_nav.dart';


class Home extends StatefulWidget {
  const Home({super.key});


  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  UserLogin userLogin = UserLogin();
  String? nama;
  String? role;
  getUserLogin() async {
    var user = await userLogin.getUserLogin();
    if (user.status != false) {
      setState(() {
        nama = user.nama_user;
        role = user.role;
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLogin();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/login');
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(child: Text("Selamat Datang $nama role anda $role")),
      bottomNavigationBar: BottomNav(0),
    );
  }
}
