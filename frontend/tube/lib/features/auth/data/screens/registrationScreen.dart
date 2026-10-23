import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:tube/features/auth/data/authSessions/auth_sessions_provider.dart';
import 'package:tube/features/auth/data/models/registeredUser.model.dart';
import 'package:tube/features/auth/data/providers/registration_provider.dart';
//import 'package:tube/features/presentation/screens/home_screen.dart';

class Registrationscreen extends ConsumerStatefulWidget {
  const Registrationscreen({super.key});

  @override
  ConsumerState<Registrationscreen> createState() => _RegistrationscreenState();
}

class _RegistrationscreenState extends ConsumerState<Registrationscreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _picker = ImagePicker();

  XFile? _avatar;
  XFile? _coverImage;

  Future<void> _pickAvatar() async {
    print("_pickAvatar");
    final image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null && mounted) {
      setState(() {
        _avatar = image;
      });
    }
  }

  Future<void> _pickCoverImage() async {
    print("_pickCoverImage");
    final Image = await _picker.pickImage(source: ImageSource.gallery);

    if (Image != null && mounted) {
      setState(() {
        _coverImage = Image;
      });
    }
  }

  Future<void> _submit() async {
    print("_submit button is pressed");
    // validate Text fields.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // check required avatar.
    if (_avatar == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Select an Avatar")));
      return;
    }

    // send the input to the notifier
    await ref
        .read(registrationProvider.notifier)
        .register(
          fullName: _fullNameController.text,
          email: _emailController.text,
          userName: _userNameController.text,
          password: _passwordController.text,
          avatar: _avatar!,
          coverImage: _coverImage,
        );
  }

  @override
  Widget build(BuildContext context) {
    print("home build");
    // next.whenOrNull(
    //   data: (user) {
    //      Success handling
    //   },
    //   error: (error, stackTrace) {
    //      Error handling
    //   },
    // );

    // listen for one-time effects
    ref.listen<AsyncValue<RegisteredUser?>>(registrationProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        data: (user) {
          if (user == null) {
            return;
          }

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Welcome ${user.fullName}!')));

          context.go('/login');
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

    // watch the state to rebuild the UI

    final authState = ref.watch(registrationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Register", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),

            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/registerImage.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 16),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter Your Full Name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),

                  labelText: 'Email',
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) {
                    return 'Enter Your Email';
                  }
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                    return 'Enter a valid email';
                  }

                  return null;
                },
              ),

              SizedBox(height: 16),
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter Your User Name';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length < 8) {
                    return "Password must be 8 characters";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              OutlinedButton(
                onPressed: authState.isLoading ? null : _pickAvatar,
                child: Text(
                  _avatar == null
                      ? 'select avatar'
                      : 'avatar selected:${_avatar!.name}',
                ),
              ),

              SizedBox(height: 16),
              OutlinedButton(
                onPressed: authState.isLoading ? null : _pickCoverImage,
                child: Text(
                  _coverImage == null
                      ? 'select cover image (Optional)'
                      : 'cover image selected: ${_coverImage!.name}',
                ),
              ),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: authState.isLoading ? null : _submit,
                child: authState.isLoading
                    ? const CircularProgressIndicator()
                    : Text('Register'),
              ),

              SizedBox(height: 6),
              TextButton(
                onPressed: () {
                  context.go('/login');
                },
                child: Text("Login Now"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
