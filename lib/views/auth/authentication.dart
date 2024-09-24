import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/auth/bloc/sign_in_bloc.dart';
import 'package:quiz_app/views/bottom%20nav/bottom_nav.dart';
import '../../utils/color_theme.dart';
import '../../utils/constant_assets.dart';
import '../../widgets/loading.dart';
import '../../widgets/my_button.dart';
import '../../widgets/my_textfield.dart';
import 'register.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final loginFormKey = GlobalKey<FormState>();
  final SignInBloc signInBloc = SignInBloc();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                  "Login",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w500, color: ColorTheme.textColor),
                ),
                Text(
                  "Add your email and password",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: ColorTheme.textColor.withOpacity(0.5)),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: loginFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(right: 10),
                  width: MediaQuery.of(context).size.width,
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Forgot Password?',
                            style: TextStyle(
                                fontSize: 14,
                                color: ColorTheme.textColor,
                                fontWeight: FontWeight.w500),
                            recognizer: TapGestureRecognizer()..onTap = () {}),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocConsumer<SignInBloc, SignInState>(
                  bloc: signInBloc,
                  listener: (context, state) {
                    if (state is SignInLoading) {
                      Loading.showLoading(context);
                    } else if (state is SignInSuccessfully) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BottomNavScreen()),
                          (Route<dynamic> route) => false);
                    } else if (state is SignInError) {
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
                            if (loginFormKey.currentState!.validate()) {
                              signInBloc.add(SignInWithEmailAndPass(
                                  email: emailController.text.trim(),
                                  pass: passwordController.text.trim()));
                            }
                          },
                          elevation: 0,
                          buttonContent: const Text(
                            "SIGN IN",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          )),
                    );
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          height: 1,
                          color: ColorTheme.hintColor,
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: const Text("OR")),
                      Expanded(
                        child: Divider(
                          height: 1,
                          color: ColorTheme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                BlocConsumer<SignInBloc, SignInState>(
                  bloc: signInBloc,
                  listener: (context, state) {
                    if (state is SignInLoading) {
                      Loading.showLoading(context);
                    } else if (state is SignInSuccessfully) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BottomNavScreen()),
                          (Route<dynamic> route) => false);
                    } else if (state is SignInError) {
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
                          buttonColor: Colors.white,
                          border: BorderSide(color: ColorTheme.lightGrey),
                          onPress: () {
                            signInBloc.add(SignInWithGoogle());
                          },
                          elevation: 0,
                          buttonContent: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage(ConstantAssets.google),
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Continue with google",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: ColorTheme.textColor),
                              ),
                            ],
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
                        "New here?",
                        style: TextStyle(color: Colors.black38),
                      ),
                      Text(
                        "Create an account",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                  MyElevatedButton(
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegisterUserScreen()));
                      },
                      elevation: 0,
                      buttonContent: Text(
                        'SIGN UP',
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
