import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterNotifier extends Notifier<int> {
  @override
  int build() {
    print("CounterNotifier is build");
    return 0;
  }

  void increment() {
    print("increment function is called");
    state++;
  }

  void decrement() {
    if (state > 0) {
      state--;
    }
  }

  void multiple() {
    if (state > 0) {
      state = state * 2;
    }
  }

  void zero() {
    state = 0;
  }

  
}

final CounterProvider = NotifierProvider<CounterNotifier, int>(
  CounterNotifier.new,
);
