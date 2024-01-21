import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/global-widgets/app_appbar.dart';
import 'package:socio_chat/global-widgets/app_scaffold.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appBar: AppNewAppBar(
            params: AppAppBarModel(
                title: "Terms and Conditions",
                titleStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.monoDark,
                ))),
        body: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.h),
              child: Text(
                '''Terms and Conditions for SOCIO\n\nAcceptance of Terms: By accessing or using the Socio application ("Socio"), you agree to abide by these terms and conditions. If you do not agree with any part of these terms, please refrain from using Socio.

Eligibility: Socio is intended solely for university students. By using Socio, you confirm that you are a university student or possess explicit permission from a university to use the application on its behalf.

User Conduct: Users are prohibited from posting any content that is unlawful, harmful, threatening, abusive, harassing, vulgar, or otherwise objectionable. All shared content should adhere to university guidelines and standards of conduct.

Intellectual Property: All user-generated content shared on Socio remains the intellectual property of its creator. By sharing content, you grant Socio a non-exclusive, royalty-free, and worldwide license to use, display, and distribute said content within the application.

Privacy: Socio respects the privacy of its users. Personal data collected by Socio, such as email addresses and phone numbers, will not be shared or sold to third parties. However, publicly shared content can be viewed by all Socio users.

Disputes: Any disputes arising from or relating to Socio shall be resolved in accordance with the laws of the jurisdiction where the university is located.

Limitation of Liability: Socio and its developers will not be held liable for any direct, indirect, incidental, special, consequential, or exemplary damages arising from the use or inability to use the service.

Amendments: We reserve the right to modify these terms at any time. It's the user's responsibility to review the terms regularly.

Contact: For any queries regarding these terms, please reach out to our support team at support@socio.com.
 ''',
                style: TextStyle(
                  color: AppColor.monoDark,
                  fontSize: 16.sp,
                ),
                softWrap: true,
                // overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ));
  }
}
