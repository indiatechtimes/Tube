import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final nameProvider = StateProvider<String>((ref) {
  return "dart";
});
final ageProvider = StateProvider<int>((ref) {
  return 44;
});
final studentProvider = StateProvider<bool>((ref) {
  return true;
});

class HomeMultiplestatemanage2 extends ConsumerWidget {
  const HomeMultiplestatemanage2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("HomeMultiplestatemanage2 is build");
    final name = ref.watch(nameProvider);
   
    return Scaffold(
      appBar: AppBar(title: Text("Tube")),

      body: Column(
        children: [
          Row(
            children: [
              Text('   name : $name     '),
              Consumer(
                builder: (context, ref, child) {
                  final age = ref.watch(ageProvider);
                  return Text('Age : $age      ');
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  final isStudent = ref.watch(studentProvider);
                  return Text('is_Student : $isStudent ');
                },
              ),
            ],
          ),
          Consumer(builder: (context,ref,child){
            final isStudent=ref.watch(studentProvider);
            return Text(isStudent ? 'yes i am student' : 'No i am not student');
          }),

          SizedBox(height: 10),

          Row(
            children: [
              IconButton(
                onPressed: () {
                  print("plus");

                  ref.read(ageProvider.notifier).state++;
                },
                icon: Icon(Icons.plus_one),
              ),
              IconButton(
                onPressed: () {
                  print("minus");
                  ref.read(ageProvider.notifier).state--;
                },
                icon: Icon(Icons.exposure_minus_1_outlined),
              ),

              Consumer(
                builder: (context, ref, child) {
                  final isStudent = ref.watch(studentProvider);
                  //ref.watch(studentProvider);
                  return Switch(
                    value: isStudent,
                    onChanged: (value) {
                      print("switch");
                      ref.read(studentProvider.notifier).state = !isStudent;
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
