import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_api_dicoding/model/api_response.dart';
import 'package:story_api_dicoding/repository/auth_repository.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> _submitRegister(BuildContext context) async {
    AuthRepository authRepository = AuthRepository();

    try {
      ApiResponse apiResponse = await authRepository.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(apiResponse.message)));
      }

      if (apiResponse.error == false && context.mounted) {
        context.goNamed('login');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Screen')),
      body: Container(
        padding: const EdgeInsets.all(32),
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Register', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                obscuringCharacter: '*',
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    )
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await _submitRegister(context).then((_) {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Text('Register'),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 6),
                      ),
                    ),
                    onPressed: () {
                      context.goNamed('login');
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
