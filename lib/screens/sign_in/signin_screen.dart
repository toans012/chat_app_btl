import 'package:chat_customer/constants/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_event.dart';
import '../../bloc/authentication/authentication_state.dart';
import '../../services/auth_service.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  final _resetKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _resetController = TextEditingController();
  final AuthService _authService = AuthService();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) async {
          if (state is AuthenticationAuthenticated) {
            await _authService.setLoggedIn(true);
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is AuthenticationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Image.asset(
                        'assets/chat-app-logo-icon.png',
                        fit: BoxFit.cover,
                      )),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            const Text(
                              'Wellcome to Appchat',
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * .9,
                                child: TextFormField(
                                  validator: (value) => value!.isEmpty
                                      ? "Email cannot be empty."
                                      : null,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("Email"),
                                  ),
                                )),
                            const SizedBox(height: 10),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * .9,
                                child: TextFormField(
                                  validator: (value) => value!.length < 8
                                      ? "Password should have atleast 8 characters."
                                      : null,
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("Password"),
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: const Text(
                                                    "Reset Password"),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                        "Please enter your email we will send a recovery link."),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Form(
                                                      key: _resetKey,
                                                      child: TextFormField(
                                                        controller:
                                                            _resetController,
                                                        validator: (value) =>
                                                            value!.isEmpty
                                                                ? "Please enter a valid email."
                                                                : null,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          label: Text("Email"),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text("Cancel")),
                                                  TextButton(
                                                      onPressed: () async {
                                                        await auth
                                                            .sendPasswordResetEmail(
                                                                email:
                                                                    _resetController
                                                                        .text)
                                                            .then((value) {
                                                          showSnackBar(context, 'We have send you the reset password link to your email ');
                                                        })
                                                            .onError((error,
                                                                stackTrace) {
                                                              showSnackBar(context, error.toString());
                                                        });
                                                      },
                                                      child:
                                                          const Text("Reset")),
                                                ],
                                              ));
                                    },
                                    child: Text(
                                      "Forget Password",
                                      style: TextStyle(
                                          color: Colors.blue.shade700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                                height: 65,
                                width: MediaQuery.of(context).size.width * .9,
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthenticationBloc>().add(
                                              SignInRequested(
                                                _emailController.text,
                                                _passwordController.text,
                                              ),
                                            );
                                      }
                                    },
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(fontSize: 17),
                                    ))),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have and account?"),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/sign-up");
                                    },
                                    child: const Text("Sign Up"))
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
