import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
//import 'package:tube/features/auth/data/authSessions/auth_sessions_provider.dart';
import 'package:tube/features/auth/data/models/loginUser.model.dart';
import 'package:tube/features/auth/data/providers/login_provider.dart';
//import 'package:tube/features/presentation/screens/home_screen.dart';

class Loginscreen extends ConsumerStatefulWidget {
  const Loginscreen({super.key});

  @override
  ConsumerState<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends ConsumerState<Loginscreen> {
  final _formKey = GlobalKey<FormState>();

  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref
        .read(loginProvider.notifier)
        .loginUser(
          userName: _userNameController.text,
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<LoginUser?>>(loginProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user == null) {
            return;
          }

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Welcome ${user.userName}!')));

          
        },

        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString().replaceFirst('Exception: ', "")),
            ),
          );
        },
      );
    });

    final loginState = ref.watch(loginProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: TextStyle(fontWeight: FontWeight.bold)),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(20),

            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/registerImage.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),

                  labelText: 'UernName',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'enter UserName ';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),

                  labelText: 'email',
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'enter email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password',
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'enter password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              ElevatedButton(
                onPressed: loginState.isLoading?null:_submit,
                child: loginState.isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        'Login',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),

              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.go('/register');
                },
                child: Text("Register Now"),
              ),
            ],
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
