import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
//import 'package:riverpod/riverpod.dart';

// THIS IS STATIC PROVIDER
final user = Provider<String>((ref) {
  return "Hello This is Mohammad";
});
final age = Provider<int>((ref) {
  return 23;
});

final count = StateProvider<int>((ref) {
  return 0;
});

final swit = StateProvider<bool>((ref) {
  return false;
});
// FOR THE STATEFULLWIDGET-------->>>>>> PROVIDER(SIMPLE)

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final myUser = ref.watch(user);
//     final myage = ref.watch(age);
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           children: [Text("Hello"), Text(myUser), Text(myage.toString())],
//         ),
//       ),
//     );
//   }
// }

// FOR THE STATELESSWIDGET------------------>>>>>>>>>>>PROVIDER(SIMPLE)

// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     print("consumerwidget is runnung");
//     final myUser = ref.watch(user);
//     final myage = ref.watch(age);
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           children: [Text("Hello"), Text(myUser), Text(myage.toString())],
//         ),
//       ),
//     );
//   }
// }

//  STATEPROVIDER
// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     print("consumer main widget is build");
//     final myCount = ref.watch(count);
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(myCount.toString(), style: TextStyle(fontSize: 50)),

//             SizedBox(height: 50),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 FloatingActionButton(
//                   onPressed: () {
//                     ref.read(count.notifier).state--;
//                   },
//                   child: Icon(Icons.exposure_minus_1_outlined),
//                 ),

//                 SizedBox(width: 50),
//                 FloatingActionButton(
//                   onPressed: () {
//                     ref.read(count.notifier).state++;
//                   },
//                   child: Icon(Icons.plus_one),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("consumer main widget is build");

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer(
              builder: (context, ref, child) {
                print("only one widget is build");

                final myCount = ref.watch(count);
                return Text(myCount.toString(), style: TextStyle(fontSize: 50));
              },
            ),

            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    ref.read(count.notifier).state--;
                  },
                  child: Icon(Icons.exposure_minus_1_outlined),
                ),

                SizedBox(width: 50),
                FloatingActionButton(
                  onPressed: () {
                    ref.read(count.notifier).state++;
                  },
                  child: Icon(Icons.plus_one),
                ),
              ],
            ),
            SizedBox(height: 20),

            Consumer(
              builder: (context, ref, child) {
                print("switch widget is build");
                final swi = ref.watch(swit);
                return Switch(
                  value: swi,
                  onChanged: (value) {
                    ref.read(swit.notifier).state = value;
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
