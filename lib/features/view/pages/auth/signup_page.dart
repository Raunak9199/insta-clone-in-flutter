import 'dart:developer';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/cubit/auth/auth_cubit.dart';
import 'package:socio_chat/cubit/cred/cred_cubit.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/image_display_widget.dart';
import 'package:socio_chat/features/view/widgets/terms_and_cond.dart';
import 'package:socio_chat/global-widgets/app_elevated_button.dart';
import 'package:socio_chat/global-widgets/app_scaffold.dart';
import 'package:socio_chat/global-widgets/app_text_form_field.dart';
import 'package:socio_chat/global-widgets/bottom-nav/bottom_nav_index_pages.dart';
import 'package:socio_chat/global-widgets/global_widgets.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool obscure = true;
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  showPassword() => setState(() {
        obscure = !obscure;
      });

  void _signup() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      isLoading = true;
    });
    BlocProvider.of<CredCubit>(context)
        .submitSignUp(
      user: UserEntity(
        email: _emailController.text,
        password: _passController.text,
        userName: _userNameController.text,
        about: _bioController.text,
        totalConnections: 0,
        totalFriends: 0,
        connections: const [],
        friends: const [],
        imgFile: imageFile,
        name: _nameController.text,
        profileUrl: imageFile!.path,
        totalPosts: 0,
        uid: "",
      ),
      // profUrl: imageFile!.path,
    )
        .then((value) {
      setState(() {
        // To clear the textfields after register
        _userNameController.clear();
        _passController.clear();
        _bioController.clear();
        _emailController.clear();
        _nameController.clear();
        isLoading = false;
      });
    });
  }

  final getIt = GetIt.instance;
// Pick image to upload for register account
  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  Future chooseImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 100,
      );
      setState(() {
        if (pickedFile != null) {
          Navigator.pop(context);
          imageFile = File(
            pickedFile.path,
          );
        } else {
          log("No file selected to upload");
        }
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error!! \n $e", gravity: ToastGravity.BOTTOM);
    }
  }

// Dialog to select image from gallery or click from camera
  openPhotoDialog() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            width: double.maxFinite,
            height: 90.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                AppElevatedButton(
                  title: "Gallery",
                  width: MediaQuery.of(context).size.width * 0.4,
                  onPressed: () => chooseImage(source: ImageSource.gallery),
                  isValid: true,
                  color: AppColor.secondaryDark,
                ),
                AppElevatedButton(
                  title: "Camera",
                  width: MediaQuery.of(context).size.width * 0.4,
                  onPressed: () => chooseImage(source: ImageSource.camera),
                  isValid: true,
                  color: AppColor.secondaryDark,
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  // Dispose the controllers to avoid memory leaks

  @override
  void dispose() {
    _bioController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _userNameController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredCubit, CredState>(
      listener: (context, credState) {
        if (credState is CredentialSuccess) {
          // TO pass the ID to authenticated state.
          BlocProvider.of<AuthCubit>(context).loggedIn();
        }
        if (credState is CredentialFailure) {
          Fluttertoast.showToast(
            msg: "Error.\n Check your credentials again.",
            gravity: ToastGravity.BOTTOM,
          );
        }
      },
      builder: (context, credState) {
        if (credState is CredentialSuccess) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authstate) {
              if (authstate is AuthenticatedState) {
                return BottomNavIndexPage(
                  uid: authstate.uid,
                );
              } else {
                return body();
              }
            },
          );
        }
        return body();
      },
    );
  }

  Widget body() {
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.backgroundColor,
      bottomNavigationBar: const TermsAndCond(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h)
            .copyWith(bottom: 5.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 35.h),
              SizedBox(
                height: 60.h,
                width: 250.w,
                child: const AppImage(
                  "assets/logo.png",
                  fit: BoxFit.fill,
                  // filterQuality: FilterQuality.high,
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: Stack(
                  children: [
                    SizedBox(
                      height: 70.h,
                      width: 70.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: ImageDisplayWidget(
                          imagFile: imageFile,
                          // imgUrl: imageFile!.path,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -12.w,
                      bottom: -14.h,
                      child: IconButton(
                        onPressed: () => openPhotoDialog(),
                        icon: Icon(
                          Icons.add_a_photo_rounded,
                          size: 28.h,
                          color: AppColor.monoDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              AppTextFormField(
                controller: _userNameController,
                readOnly: isLoading == true,
                borderColor: AppColor.monoAlt,
                hintText: "Enter your username",
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.next,
                prefixIcon: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                  child: Icon(
                    Icons.person,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                focusedBorder: InputBorder.none,
              ),
              SizedBox(height: 10.h),
              AppTextFormField(
                controller: _nameController,
                readOnly: isLoading == true,
                borderColor: AppColor.monoAlt,
                textInputAction: TextInputAction.next,
                hintText: "Enter your name",
                prefixIcon: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                  child: Icon(
                    Icons.person,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                focusedBorder: InputBorder.none,
              ),
              SizedBox(height: 10.h),
              AppTextFormField(
                controller: _emailController,
                borderColor: AppColor.monoAlt,
                textCapitalization: TextCapitalization.none,
                hintText: "Enter email",
                textInputAction: TextInputAction.next,
                readOnly: isLoading == true,
                prefixIcon: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                  child: Icon(
                    Icons.email_outlined,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                focusedBorder: InputBorder.none,
              ),
              SizedBox(height: 10.h),
              AppTextFormField(
                controller: _bioController,
                readOnly: isLoading == true,
                borderColor: AppColor.monoAlt,
                hintText: "Write your bio",
                textInputAction: TextInputAction.next,
                prefixIcon: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                  child: Icon(
                    Icons.account_box_outlined,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                focusedBorder: InputBorder.none,
              ),
              SizedBox(height: 10.h),
              AppTextFormField(
                controller: _passController,
                readOnly: isLoading == true,
                borderColor: AppColor.monoAlt,
                hintText: "Enter password",
                textCapitalization: TextCapitalization.none,
                prefixIcon: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                obscureText: obscure,
                textInputAction: TextInputAction.done,
                onEditingComplete: _signup,
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
              SizedBox(height: 40.h),
              Center(
                child: AppElevatedButton(
                  height: 45.h,
                  width: double.maxFinite,
                  title: "Sign Up",
                  color: AppColor.secondaryDark,
                  isValid: true,
                  isLoading: isLoading,
                  radius: 15.r,
                  isUpperCase: true,
                  style: Get.textTheme.headlineSmall!.copyWith(
                    color: AppColor.monoWhite,
                  ),
                  onPressed: () => _signup(),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Already have an account?",
                      style: Get.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        color: AppColor.monoEmphasis,
                      ),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pop(context),
                          text: " Login",
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
      ),
    );
  }
}
/* {
                          showBottomSheet(
                            context: context,
                            builder: (context) => const Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppElevatedButton(
                                        title: "Camera",
                                        isValid: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: AppElevatedButton(
                                        title: "Gallery",
                                        isValid: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }, */
