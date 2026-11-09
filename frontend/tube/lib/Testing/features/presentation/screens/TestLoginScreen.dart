import 'package:flutter/material.dart';

class Testloginscreen extends StatelessWidget {
  const Testloginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SafeArea(child: Column(
        children: [
          Text("Hello"),
        ],
      )),
    );
  }
}