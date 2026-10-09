import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final ageProvider = StateProvider<int>((ref) {
  return 0;
});

class consumer_widget extends ConsumerWidget {
  const consumer_widget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    print("consumer widget is build");
    return Scaffold(
      appBar: AppBar(title: Text("why ConsumerWidget")),
      body: Center(
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                print("text is build");
                final age = ref.watch(ageProvider);
                return Text('age is : $age');
              },
            ),
            
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("button is pressed");
                ref.read(ageProvider.notifier).state++;
              },
              child: Text("increase"),
            ),
          ],
        ),
      ),
    );
  }
}
