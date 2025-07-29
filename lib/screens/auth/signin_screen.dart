  import 'package:flutter/material.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:mood_meal/constant/app_colors.dart';
  import 'package:mood_meal/widget/app_bar.dart';

  import '../../router/routes.dart';
  import '../../widget/build_button.dart';
  import '../../widget/or_divider.dart';
  import '../../widget/text_field.dart';

  class SignInScreen extends StatefulWidget {
    const SignInScreen({super.key});

    @override
    State<SignInScreen> createState() => _SignInScreenState();
  }

  class _SignInScreenState extends State<SignInScreen> {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: AppColors.primary100,
        appBar: const CustomTopAppBar(isImage: true, label: ""),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),

                      // Card
                      Form(
                        key: formKey,
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(30),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Welcome Back !",
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.secondary1000,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Sign in to continue",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.secondary600,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),

                              CustomTextField(
                                label: 'Email Address',
                                hint: 'Enter your email address',
                                controller: emailController,
                                borderColor: Colors.grey.shade300,
                                textColor: Colors.black,
                              ),
                              const SizedBox(height: 10),

                              CustomTextField(
                                label: 'Password',
                                hint: 'Enter your password',
                                isPassword: true,
                                controller: passwordController,
                                borderColor: Colors.grey.shade300,
                                textColor: Colors.black,
                              ),
                              const SizedBox(height: 10),

                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.primary1000,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              buildButton(
                                text: "Sign In",
                                backgroundColor: AppColors.primary1000,
                                textColor: Colors.white,
                                onPressed: () {
                                  bool isValid = formKey.currentState!.validate();
                                  if (!isValid) {
                                    formKey.currentState!.validate();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      const OrDivider(text: "Or sign in with"),
                      const SizedBox(height: 16),

                      buildButton(
                        text: "Continue With Google",
                        isGoogle: true,
                        backgroundColor: AppColors.primary100,
                        onPressed: () {},
                      ),

                      Spacer(), // Pushes footer to bottom

                      const SizedBox(height: 20),
                      // Bottom Sign Up Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account ? ",
                            style: TextStyle(
                              color: AppColors.secondary400,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, Routes.signUp),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: AppColors.primary1000,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primary1000,
                                decorationThickness: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  // Center(
  // child: ElevatedButton(onPressed:() => Navigator.pushNamed(context, Routes.signUp), child: Text('signin')),
  // ),

  // onPressed: () {
  // bool isValid = formKey.currentState!.validate();
  // if(!isValid){
  // formKey.currentState!.validate();
  // }
  // },
