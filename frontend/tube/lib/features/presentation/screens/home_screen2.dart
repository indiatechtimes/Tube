import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
//import 'package:tube/features/presentation/screens/home_screen.dart';

final userProvider = Provider<String>((ref) {
  return "Hello";
});

final ageProvider = StateProvider<int>((ref) {
  return 44;
});

class HomeScreen2 extends StatelessWidget {
  const HomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            final age = ref.watch(ageProvider);
            return Text(age.toString());
          },
        ),
      ),
    );
  }
}
