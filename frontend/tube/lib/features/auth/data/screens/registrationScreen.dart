










// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';

// import 'package:tube/features/auth/data/models/registeredUser.model.dart';
// import 'package:tube/features/auth/data/providers/register_provider.dart';
// //import 'package:tube/features/auth/presentation/providers/register_provider.dart';

// class RegistrationScreen extends ConsumerStatefulWidget {
//   const RegistrationScreen({super.key});

//   @override
//   ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _userNameController = TextEditingController();
//   final _passwordController = TextEditingController();

//   final _imagePicker = ImagePicker();

//   File? _avatar;
//   File? _coverImage;

//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _userNameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   String? _validateRequired(String? value, String fieldName) {
//     if (value == null || value.trim().isEmpty) {
//       return '$fieldName is required';
//     }

//     return null;
//   }

//   String? _validateEmail(String? value) {
//     final requiredError = _validateRequired(value, 'Email');

//     if (requiredError != null) {
//       return requiredError;
//     }

//     final email = value!.trim();
//     final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

//     if (!emailPattern.hasMatch(email)) {
//       return 'Enter a valid email address';
//     }

//     return null;
//   }

//   String? _validatePassword(String? value) {
//     final requiredError = _validateRequired(value, 'Password');

//     if (requiredError != null) {
//       return requiredError;
//     }

//     if (value!.length < 8) {
//       return 'Password must contain at least 8 characters';
//     }

//     return null;
//   }

//   Future<void> _pickImage({required bool isAvatar}) async {
//     try {
//       final pickedFile = await _imagePicker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 85,
//       );

//       if (!mounted || pickedFile == null) {
//         return;
//       }

//       setState(() {
//         if (isAvatar) {
//           _avatar = File(pickedFile.path);
//         } else {
//           _coverImage = File(pickedFile.path);
//         }
//       });
//     } catch (error) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Unable to select the image.')),
//       );
//     }
//   }

//   Future<void> _submit() async {
//     FocusScope.of(context).unfocus();

//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     if (_avatar == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Please select an avatar.')));
//       return;
//     }

//     await ref
//         .read(RegisterNotifierProvider.notifier)
//         .register(
//           fullName: _fullNameController.text.trim(),
//           email: _emailController.text.trim(),
//           userName: _userNameController.text.trim(),
//           password: _passwordController.text,
//           avatar: _avatar!,
//           coverImage: _coverImage,
//         );
//   }

//   String _errorMessage(Object error) {
//     return error.toString().replaceFirst('Exception: ', '');
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Listen for success and error side effects.
//     ref.listen<AsyncValue<RegisteredUser?>>(RegisterNotifierProvider, (previous, next) {
//       next.when(
//         data: (user) {
//           if (user == null) return;

//           ScaffoldMessenger.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(
//               SnackBar(
//                 content: Text(
//                   'Account created successfully. '
//                   'Welcome ${user.fullName}!',
//                 ),
//                 backgroundColor: Colors.green,
//               ),
//             );
//         },
//         loading: () {},
//         error: (error, stackTrace) {
//           ScaffoldMessenger.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(
//               SnackBar(
//                 content: Text(_errorMessage(error)),
//                 backgroundColor: Colors.red,
//               ),
//             );
//         },
//       );
//     });

//     // Watch the AsyncNotifier state.
//     final registration = ref.watch(RegisterNotifierProvider);
//     final isLoading = registration.isLoading;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Create Account'), centerTitle: true),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const Text(
//                   'Create your account',
//                   style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Enter your details to get started.',
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurfaceVariant,
//                   ),
//                 ),
//                 const SizedBox(height: 28),

//                 // Full name
//                 TextFormField(
//                   controller: _fullNameController,
//                   enabled: !isLoading,
//                   textCapitalization: TextCapitalization.words,
//                   autofillHints: const [AutofillHints.name],
//                   decoration: const InputDecoration(
//                     labelText: 'Full name',
//                     hintText: 'Enter your full name',
//                     prefixIcon: Icon(Icons.person_outline),
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) => _validateRequired(value, 'Full name'),
//                 ),
//                 const SizedBox(height: 16),

//                 // Email
//                 TextFormField(
//                   controller: _emailController,
//                   enabled: !isLoading,
//                   keyboardType: TextInputType.emailAddress,
//                   autofillHints: const [AutofillHints.email],
//                   autocorrect: false,
//                   decoration: const InputDecoration(
//                     labelText: 'Email',
//                     hintText: 'you@example.com',
//                     prefixIcon: Icon(Icons.email_outlined),
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: _validateEmail,
//                 ),
//                 const SizedBox(height: 16),

//                 // Username
//                 TextFormField(
//                   controller: _userNameController,
//                   enabled: !isLoading,
//                   autocorrect: false,
//                   decoration: const InputDecoration(
//                     labelText: 'Username',
//                     hintText: 'Choose a username',
//                     prefixIcon: Icon(Icons.alternate_email),
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) => _validateRequired(value, 'Username'),
//                 ),
//                 const SizedBox(height: 16),

//                 // Password
//                 TextFormField(
//                   controller: _passwordController,
//                   enabled: !isLoading,
//                   obscureText: _obscurePassword,
//                   autocorrect: false,
//                   autofillHints: const [AutofillHints.newPassword],
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     hintText: 'At least 8 characters',
//                     prefixIcon: const Icon(Icons.lock_outline),
//                     border: const OutlineInputBorder(),
//                     suffixIcon: IconButton(
//                       onPressed: isLoading
//                           ? null
//                           : () {
//                               setState(() {
//                                 _obscurePassword = !_obscurePassword;
//                               });
//                             },
//                       icon: Icon(
//                         _obscurePassword
//                             ? Icons.visibility_outlined
//                             : Icons.visibility_off_outlined,
//                       ),
//                     ),
//                   ),
//                   validator: _validatePassword,
//                 ),
//                 const SizedBox(height: 28),

//                 // Required avatar
//                 const Text(
//                   'Profile avatar *',
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(height: 12),
//                 Center(
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 52,
//                         backgroundColor: Theme.of(
//                           context,
//                         ).colorScheme.surfaceContainerHighest,
//                         backgroundImage: _avatar == null
//                             ? null
//                             : FileImage(_avatar!),
//                         child: _avatar == null
//                             ? const Icon(Icons.person, size: 48)
//                             : null,
//                       ),
//                       const SizedBox(height: 12),
//                       OutlinedButton.icon(
//                         onPressed: isLoading
//                             ? null
//                             : () => _pickImage(isAvatar: true),
//                         icon: const Icon(Icons.add_a_photo_outlined),
//                         label: Text(
//                           _avatar == null ? 'Choose avatar' : 'Change avatar',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 28),

//                 // Optional cover image
//                 const Text(
//                   'Cover image (optional)',
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(height: 12),
//                 Container(
//                   height: 160,
//                   width: double.infinity,
//                   clipBehavior: Clip.antiAlias,
//                   decoration: BoxDecoration(
//                     color: Theme.of(
//                       context,
//                     ).colorScheme.surfaceContainerHighest,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: _coverImage == null
//                       ? const Center(
//                           child: Icon(Icons.image_outlined, size: 48),
//                         )
//                       : Image.file(
//                           _coverImage!,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return const Center(
//                               child: Text('Unable to preview image'),
//                             );
//                           },
//                         ),
//                 ),
//                 const SizedBox(height: 12),
//                 OutlinedButton.icon(
//                   onPressed: isLoading
//                       ? null
//                       : () => _pickImage(isAvatar: false),
//                   icon: const Icon(Icons.image_search_outlined),
//                   label: Text(
//                     _coverImage == null
//                         ? 'Choose cover image'
//                         : 'Change cover image',
//                   ),
//                 ),
//                 if (_coverImage != null)
//                   TextButton.icon(
//                     onPressed: isLoading
//                         ? null
//                         : () {
//                             setState(() {
//                               _coverImage = null;
//                             });
//                           },
//                     icon: const Icon(Icons.delete_outline),
//                     label: const Text('Remove cover image'),
//                   ),
//                 const SizedBox(height: 28),

//                 // Submit button
//                 SizedBox(
//                   height: 52,
//                   child: ElevatedButton(
//                     onPressed: isLoading ? null : _submit,
//                     child: isLoading
//                         ? const SizedBox(
//                             width: 24,
//                             height: 24,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                         : const Text(
//                             'Create Account',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
