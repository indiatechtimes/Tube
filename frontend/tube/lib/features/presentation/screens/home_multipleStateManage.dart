import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

final quantityProvider = StateProvider<int>((ref) {
  return 1;
});

final isSelectedProvider = StateProvider<bool>((ref) {
  return false;
});

final isDarkModeProvider = StateProvider<bool>((ref) {
  return false;
});

final price = 120000;

class HomeMultiplestatemanage extends ConsumerWidget {
  const HomeMultiplestatemanage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(isSelectedProvider);
    final quantity = ref.watch(quantityProvider);
    final total = isSelected ? price * quantity : 0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Tube"),
        actions: [
          IconButton(
            onPressed: () {
              final current = ref.read(isDarkModeProvider);
              ref.read(isDarkModeProvider.notifier).state = !current;
            },
            icon: Icon(Icons.brightness_6_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.account_circle_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () {
                  ref.read(isDarkModeProvider.notifier).state = true;
                },
                child: Icon(Icons.dark_mode),
              ),
              SizedBox(width: 20),
              FloatingActionButton(
                onPressed: () {
                  ref.read(isDarkModeProvider.notifier).state = false;
                },
                child: Icon(Icons.light_mode),
              ),
            ],
          ),

          SizedBox(height: 10),

          CheckboxListTile(
            title: Text("Iphone 18 "),
            subtitle: Text('price: 120000'),
            value: isSelected,
            onChanged: (value) {
              ref.read(isSelectedProvider.notifier).state = value ?? false;
            },
          ),

          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  quantity > 1
                      ? ref.read(quantityProvider.notifier).state--
                      : null;
                },
                icon: Icon(Icons.remove),
              ),
              SizedBox(width: 10),
              Text('Quantity : $quantity'),
              IconButton(
                onPressed: () {
                  ref.read(quantityProvider.notifier).state++;
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),

          SizedBox(height: 50),

          Text('Total : $total'),
        ],
      ),
    );
  }
}
