import 'package:flutter/material.dart';
import 'package:podlove_flutter/ui/widgets/custom_app_bar.dart';
import 'package:podlove_flutter/ui/widgets/custom_round_button.dart';
import 'package:podlove_flutter/ui/widgets/custom_text.dart';
import 'package:podlove_flutter/ui/widgets/photo_uploader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadPhoto extends StatelessWidget {
  const UploadPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(375, 812), minTextAdapt: true);

    return Scaffold(
      appBar: CustomAppBar(title: "Upload Photo"),
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.h),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/podLove.png",
                        width: 250.w,
                        height: 50.h,
                      ),
                      SizedBox(height: 25.h),
                      CustomText(
                        text: "Upload your photo",
                        color: Color.fromARGB(255, 51, 51, 51),
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 12.h),
                      CustomText(
                        text:
                            "We'd love to see you. Upload a photo for your dating journey.",
                        color: Color.fromARGB(255, 51, 51, 51),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
                PhotoUploader(),
                SizedBox(height: 30.h),
                CustomRoundButton(
                  text: "Continue",
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}