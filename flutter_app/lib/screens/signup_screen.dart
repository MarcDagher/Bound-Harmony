import 'package:bound_harmony/configurations/request.configuration.dart';
import 'package:bound_harmony/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bound_harmony/reusable%20widgets/text_input.dart';
import 'package:bound_harmony/reusable%20widgets/button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final dio = Dio();
  // input handleing
  bool empty = false;
  bool invalidEmailFormat = false;
  bool passwordIsShort = false;

  // response handleing
  bool emailTaken = false;
  bool success = false;

  Map<String, String> formData = {'username': "", 'email': "", 'password': ""};

  // void registerRequest(formData) async {
  //   try {
  //     final response = await dio.post(
  //       options: Options(contentType: "application/json"),
  //       '${Requests.baseUrl}/register',
  //       data: {
  //         "username": formData['username'],
  //         "email": formData['email'],
  //         "password": formData['password'],
  //         "birthdate": "15-01-2003"
  //       },
  //     );

  //     if (response.data['status'] == "success") {
  //       setState(() {
  //         success = true;
  //         emailTaken = false;
  //       });
  //       context.goNamed('Log In');
  //     }
  //   } on DioException catch (e) {
  //     if (e.response!.statusCode == 302) {
  //       setState(() {
  //         emailTaken = true;
  //         success = false;
  //       });
  //     }
  //   }
  // }

  void handleInput(String field, String newField) {
    setState(() {
      formData[field] = newField;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final isKeyboard = MediaQuery.of(context).viewInsets.bottom !=
    //     0; // check if keyboard is in the UI
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            ///////////////////// Column: Logo + Title ///////////////////////
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Image.asset(
                    "assets/logo.png",
                  ),
                ), // when keyboard appears hide logo
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 45,
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            ///////////////////// Column: INPUT FIELDs  ///////////////////////

            if (empty == true ||
                emailTaken == true ||
                success == true ||
                invalidEmailFormat == true ||
                passwordIsShort == true)
              const SizedBox(height: 30)
            else
              const SizedBox(
                height: 45,
              ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: TextInputField(
                      handleChange: (text) => handleInput("username", text),
                      placeholder: 'Username'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: TextInputField(
                      handleChange: (text) => handleInput("email", text),
                      placeholder: 'Email'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TextInputField(
                      handleChange: (text) => handleInput('password', text),
                      placeholder: 'Password'),
                ),

                // if not all input fields are filled
                if (empty == true)
                  const Text(
                    "All fields are required",
                    style: TextStyle(color: Colors.red),
                  ),

                // if email format is wrong
                if (invalidEmailFormat == true)
                  const Text(
                    "Invalid email format.",
                    style: TextStyle(color: Colors.red),
                  ),

                // if password is too short
                if (passwordIsShort == true)
                  const Text(
                    "Password must be at least 6 characters.",
                    style: TextStyle(color: Colors.red),
                  ),

                // if username exists in DB
                if (emailTaken == true)
                  const Text(
                    "Email has already been used",
                    style: TextStyle(color: Colors.red),
                  ),

                // if user created successfully
                if (success == true)
                  const Text(
                    "Account created successfully",
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),

            ///////////////////// Column: BUTTON + Text ///////////////////////
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 45, bottom: 10),
                  child: Button(
                    text: 'Create Account',
                    // check for empty input fields
                    handlePressed: () async {
                      // if a field is empty
                      if (formData['username'] == "" ||
                          formData['email'] == "" ||
                          formData['password'] == "") {
                        setState(() {
                          empty = true;
                        });

                        // if email format is invalid
                      } else if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@(hotmail\.com|gmail\.com|yahoo\.com|outlook\.com)$')
                          .hasMatch(formData['email']!)) {
                        setState(() {
                          empty = false;
                          invalidEmailFormat = true;
                        });

                        // if password too short
                      } else if (formData['password']!.length < 6) {
                        setState(() {
                          empty = false;
                          invalidEmailFormat = false;
                          passwordIsShort = true;
                        });

                        // clear all inout error messages
                      } else {
                        setState(() {
                          empty = false;
                          invalidEmailFormat = false;
                          passwordIsShort = false;
                        });

                        // send request
                        final result = await context
                            .read<AuthProvider>()
                            .signUpRequest(formData['username']!,
                                formData['email']!, formData['password']!);

                        setState(() {
                          success = result[1];
                          emailTaken = result[0];
                        });
                        if (success == true) {
                          Navigator.popAndPushNamed(
                              context, "Connection Setup");
                        }
                        // print(context.watch<AuthProvider>().emailTaken);
                        // print(context.watch<AuthProvider>().success);
                        // print("success: $success, emailTaken: $emailTaken");
                        print(
                            "success: ${result[1]}, emailTaken: ${result[0]}");
                      }
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () => context.goNamed('Log In'),
                  child: Text(
                    "If you have an account Sign In",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}
