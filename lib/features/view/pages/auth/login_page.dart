import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/cubit/auth/auth_cubit.dart';
import 'package:socio_chat/cubit/cred/cred_cubit.dart';
import 'package:socio_chat/global-widgets/app_elevated_button.dart';
import 'package:socio_chat/global-widgets/app_scaffold.dart';
import 'package:socio_chat/global-widgets/app_text_form_field.dart';
import 'package:socio_chat/global-widgets/bottom-nav/bottom_nav_index_pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscure = true;
  bool isLoading = false;
  void Function()? showPassword() {
    setState(() {
      obscure = !obscure;
    });
    return null;
  }

  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    // showPassword();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      isLoading = true;
    });
    BlocProvider.of<CredCubit>(context)
        .submitSignIn(
      email: emailController.text,
      pass: passwordController.text,
    )
        .then((value) {
      setState(() {
        emailController.clear();
        passwordController.clear();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.backgroundColor,
      body: BlocConsumer<CredCubit, CredState>(
        listener: (context, credState) {
          if (credState is CredentialSuccess) {
            // TO pass the ID to authenticated state.
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }
          if (credState is CredentialFailure) {
            Fluttertoast.showToast(msg: "Check your credentials again.");
          }
        },
        builder: (context, credState) {
          if (credState is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authstate) {
                if (authstate is AuthenticatedState) {
                  return BottomNavIndexPage(uid: authstate.uid);
                } else {
                  return bodyWidget();
                }
              },
            );
          }
          return bodyWidget();
        },
      ),
    );
  }

  Widget bodyWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 170.h),
            SizedBox(
              height: 60.h,
              width: 250.w,
              child: Image.asset(
                "assets/logo.png",
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
              ),
            ),
            SizedBox(height: 60.h),
            AppTextFormField(
              controller: emailController,
              borderColor: AppColor.monoAlt,
              hintText: "Enter email",
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                child: Icon(
                  Icons.email_outlined,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              focusedBorder: InputBorder.none,
            ),
            SizedBox(height: 10.h),
            AppTextFormField(
              controller: passwordController,
              borderColor: AppColor.monoAlt,
              textInputAction: TextInputAction.done,
              hintText: "Enter password",
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              onEditingComplete: _signIn,
              obscureText: obscure,
              suffixIcon: InkWell(
                onTap: showPassword,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                  child: Icon(
                    !obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ),
            ),
            SizedBox(height: 60.h),
            Center(
              child: AppElevatedButton(
                height: 45.h,
                width: double.maxFinite,
                title: "Login",
                color: AppColor.secondaryDark,
                isValid: true,
                isLoading: isLoading,
                radius: 15.r,
                isUpperCase: true,
                style: Get.textTheme.headlineSmall!.copyWith(
                  color: AppColor.monoWhite,
                ),
                onPressed: _signIn,
                // Nav.popAndPushNamed(Routes.bottomNav),
              ),
            ),
            SizedBox(height: 25.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Don't have an account?".tr,
                    style: Get.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      color: AppColor.monoEmphasis,
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              Navigator.pushNamed(context, Routes.signupView),
                        // Nav.pushNamed(Routes.signupview),
                        text: " SignUp".tr,
                        style: Get.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: AppColor.secondaryDark),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
