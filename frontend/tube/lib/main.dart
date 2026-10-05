import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tube/features/presentation/screens/home_multipleStateManage.dart';
//import 'package:tube/features/presentation/screens/home_screen.dart';
//import 'package:tube/features/presentation/screens/home_screen2.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
  print("runApp MyApp is running");
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(isDarkModeProvider);
    print("MyApp statelessWidget is runnung");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: current ? Brightness.dark : Brightness.light,
        ),
      ),
      home: const HomeMultiplestatemanage(),
    );
  }
}
