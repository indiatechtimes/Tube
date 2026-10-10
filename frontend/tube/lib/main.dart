import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tube/features/presentation/screens/homeNotifier_provider.dart';
import 'package:tube/features/presentation/screens/home_multipleStateManage.dart';
//import 'package:tube/features/presentation/screens/state_widget/consumerStatefullWidget.dart';
//import 'package:tube/features/presentation/screens/state_widget/consumer_widget.dart';
//import 'package:tube/features/presentation/screens/state_widget/stateful_widget.dart';
//import 'package:tube/features/presentation/screens/home_multipleStateManage2.dart';
//import 'package:tube/features/presentation/screens/state_widget/stateless_widget.dart';
//import 'package:tube/features/presentation/screens/home_screen.dart';
//import 'package:tube/features/presentation/screens/home_screen2.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
  print("runApp MyApp is build");
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(isDarkModeProvider);
    print("MyApp statelessWidget is build");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: current ? Brightness.dark : Brightness.light,
        ),
      ),
      home: const HomenotifierProvider(),
    );
  }
}
