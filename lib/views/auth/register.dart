import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/views/bottom%20nav/bottom_nav.dart';

import '../../logic/auth/bloc/sign_up_bloc.dart';
import '../../utils/color_theme.dart';
import '../../widgets/loading.dart';
import '../../widgets/my_button.dart';
import '../../widgets/my_textfield.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final registerFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final SignUpBloc signUpBloc = SignUpBloc();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                child: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05, vertical: 20),
              children: [
                Text(
                  "Register",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w500, color: ColorTheme.textColor),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: registerFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyTextField(
                        controller: firstNameController,
                        hintText: "First Name",
                        maxLines: 1,
                        radius: 6,
                        verticalPadding: 14,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Please enter your firstname";
                          } else if (containsSpecialCharOrNumber(val.trim())) {
                            return "Special characters or numbers not allowed";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyTextField(
                        controller: lastNameController,
                        hintText: "Last Name",
                        maxLines: 1,
                        radius: 6,
                        verticalPadding: 14,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Please enter your lastname";
                          } else if (containsSpecialCharOrNumber(val.trim())) {
                            return "Special characters or numbers not allowed";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyTextField(
                        controller: emailController,
                        hintText: "Email Address",
                        maxLines: 1,
                        radius: 6,
                        verticalPadding: 14,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Email address or mobile number is required";
                          } else if (!validateEmail(val.trim())) {
                            return "Please enter valid email address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyTextField(
                        controller: passwordController,
                        hintText: "Password",
                        maxLines: 1,
                        radius: 6,
                        isObscure: true,
                        verticalPadding: 14,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Password can not be empty";
                          } else if (!validatePassword(val.trim())) {
                            return "Your password must contain at least one uppercase letter, one symbol, and one digit.";
                          } else if (val.trim().length < 8) {
                            return "Password must be greater that 8 digit";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyTextField(
                        controller: confirmPassController,
                        hintText: "Confirm Password",
                        maxLines: 1,
                        radius: 6,
                        isObscure: true,
                        verticalPadding: 14,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Password can not be empty";
                          } else if (val.trim() !=
                              passwordController.text.trim()) {
                            return "Password does not match";
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocConsumer<SignUpBloc, SignUpState>(
                  bloc: signUpBloc,
                  listener: (context, state) {
                    if (state is SignUpLoading) {
                      Loading.showLoading(context);
                    } else if (state is SignUpSuccessfully) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BottomNavScreen()),
                          (Route<dynamic> route) => false);
                    } else if (state is SignUpError) {
                      Navigator.pop(context);
                      Loading.showSnackBar(context,
                          state.exception.message ?? "Something went wrong");
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: size.width,
                      height: 48,
                      child: MyElevatedButton(
                          onPress: () {
                            if (registerFormKey.currentState!.validate()) {
                              signUpBloc.add(SignUpWithEmailAndPass(
                                  email: emailController.text.trim(),
                                  pass: passwordController.text.trim(),
                                  fnmae: firstNameController.text.trim(),
                                  lname: lastNameController.text.trim()));
                            }
                          },
                          elevation: 0,
                          buttonContent: const Text(
                            "SIGN UP",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          )),
                    );
                  },
                ),
              ],
            )),
            Container(
              padding: const EdgeInsets.all(15),
              color: const Color.fromARGB(10, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi there...!",
                        style: TextStyle(color: Colors.black38),
                      ),
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                  MyElevatedButton(
                      onPress: () {
                        Navigator.pop(context);
                      },
                      elevation: 0,
                      buttonContent: Text(
                        'SIGN IN',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
