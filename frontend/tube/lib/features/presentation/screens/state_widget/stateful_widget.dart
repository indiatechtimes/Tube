import 'package:flutter/material.dart';

int age = 0;
bool isSecure = false;

class Stf extends StatefulWidget {
  const Stf({super.key});

  @override
  State<Stf> createState() => _StfState();
}

class _StfState extends State<Stf> {
  @override
  Widget build(BuildContext context) {
    print("stf is build");
    return Scaffold(
      appBar: AppBar(title: Text("why Statefull widget")),

      body: Column(
        children: [
          TextField(
            obscureText: isSecure,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isSecure = !isSecure;
                  });
                },
                icon: Icon(isSecure ? Icons.visibility : Icons.visibility_off),
              ),
            ),
          ),
          SizedBox(height: 20),

          Text('age is $age'),

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              print("button is pressed");
              setState(() {
                age++;
              });
              print(age);
            },
            child: Text("increase"),
          ),
        ],
      ),
    );
  }
}
