import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tube/Testing/features/data/models/testLoginUser.model.dart';
import 'package:tube/Testing/features/presentation/providers/testlogin_provider.dart';

class Testloginscreen extends ConsumerStatefulWidget {
  const Testloginscreen({super.key});

  @override
  ConsumerState<Testloginscreen> createState() => _TestloginscreenState();
}

class _TestloginscreenState extends ConsumerState<Testloginscreen> {
  final _formKey = GlobalKey<FormState>();

  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    print('formkey state=${_formKey.currentState}');
    if (!_formKey.currentState!.validate()) {
      return;
    }
    await ref
        .read(testLoginProvider.notifier)
        .testloginUser(
          userName: _userNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );

    print('login provider state=${ref.watch(testLoginRepositoryProvider)}');
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<Testloginuser?>>(testLoginProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          print('user is = $user');
          if (user == null) {
            return;
          }

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Welcome ${user.userName}')));
        },
        error: (error, stackTrace) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Something went wrong'),
              content: Text('SomeThing Went Wrong!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      );
    });
    final loginState = ref.watch(testLoginProvider);

    print('LoginState=$loginState');
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'UserName',
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'UserName is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'email',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'emai is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,

                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    helperText: 'password',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'password is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    print('presed');
                    loginState.isLoading ? null : _submit();
                    print("submit button is pressed");
                  },
                  child: loginState.isLoading
                      ? CircularProgressIndicator()
                      : Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
