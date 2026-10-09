import 'package:flutter/material.dart';

int age = 0;

class statelessWidget_widget extends StatelessWidget {
  const statelessWidget_widget({super.key});

  @override
  Widget build(BuildContext context) {
    print("statelessWidget_widget is bild");
    return Scaffold(
      appBar: AppBar(title: Text("why stateless widget")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('age is : $age'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                print("increase button is build ");
                age++;
                print(age);
              },
              child: Text("increase"),
            ),
          ],
        ),
      ),
    );
  }
}
