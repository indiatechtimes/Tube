import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: ListView(
            padding: EdgeInsets.all(20),

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
            ],
          ),
        ),
      ),
    );
  }
}
