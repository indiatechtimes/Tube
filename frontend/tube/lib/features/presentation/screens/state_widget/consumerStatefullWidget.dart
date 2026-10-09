import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

int age = 0;

final umarProvider = StateProvider<int>((ref) {
  print("umar provider is created");
  return 0;
});

class csfw extends ConsumerStatefulWidget {
  const csfw({super.key});

  @override
  ConsumerState<csfw> createState() => _csfwState();
}

class _csfwState extends ConsumerState<csfw> {
  @override
  Widget build(BuildContext context) {
    // final umar=ref.watch(umarProvider);
    print("csfw widget is build");
    return Scaffold(
      appBar: AppBar(title: Text("Why ConsumerStatefullWidget")),
      body: Center(
        child: Column(
          children: [
            Text('age is $age', style: TextStyle(fontSize: 30)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("button is pressed");
                setState(() {
                  age++;
                });
              },
              child: Text("increase"),
            ),

            ElevatedButton(
              onPressed: () {
                print("button is pressed");
                setState(() {
                  age = 0;
                });
              },
              child: Text("zero"),
            ),

            SizedBox(height: 30),
            //Text('your umar is $umar'),
            Consumer(
              builder: (context, ref, child) {
                final umar = ref.watch(umarProvider);
                return Text('your umar is $umar');
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                print("umar button is pressed");
                ref.read(umarProvider.notifier).state++;
              },
              child: Text("Increase umar"),
            ),
          ],
        ),
      ),
    );
  }
}
