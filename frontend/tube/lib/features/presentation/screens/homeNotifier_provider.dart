import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:tube/features/presentation/screens/home_screen.dart';
import 'package:tube/features/presentation/screens/state_widget/notifier_provider.dart';

class HomenotifierProvider extends ConsumerWidget {
  const HomenotifierProvider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("HomenotifierProvider is build");
    return Scaffold(
      appBar: AppBar(title: Text("NotifierProvider")),
      body: Center(
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                print("text is build");
                final Count = ref.watch(CounterProvider);
                return Text('$Count', style: TextStyle(fontSize: 30));
              },
            ),

            SizedBox(height: 20),

            Consumer(
              builder: (context, ref, child) {
                final isWinner = ref.watch(CounterProvider);
                return isWinner == 10
                    ? Text("You Win")
                    : const SizedBox.shrink();
              },
            ),

            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () {
                ref.read(CounterProvider.notifier).increment();
              },
              child: Icon(Icons.add),
            ),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () {
                ref.read(CounterProvider.notifier).decrement();
              },
              child: Text("Minus"),
            ),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () {
                ref.read(CounterProvider.notifier).multiple();
              },
              child: Text("multi"),
            ),

            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () {
                ref.read(CounterProvider.notifier).zero();
              },
              child: Text("zero"),
            ),
          ],
        ),
      ),
    );
  }
}
