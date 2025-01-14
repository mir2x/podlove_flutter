import 'package:flutter/material.dart';
import 'package:podlove_flutter/routes/route_path.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_round_button.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Approach extends StatelessWidget {
  const Approach({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Our Approach"),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w)
              .copyWith(top: 20.h, bottom: 44.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),
              SizedBox(
                width: 250.w,
                child: Image.asset(
                  "assets/images/podLove.png",
                  width: 200.w,
                  height: 50.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                "Our Approach to Love",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,

                ),
              ),
              SizedBox(height: 30.h),
              Expanded(
                child: Text(
                  "PodLove is grounded in fostering authentic, meaningful connections beyond surface-level preferences. While we understand some people have specific preferences, our goal is to help you find love where it might be least expected.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              CustomRoundButton(
                text: "Next",
                backgroundColor: const Color(0xFF2757A6),
                onPressed: () => Get.toNamed(RouterPath.expectationFromApp),
              ),
              SizedBox(height: 44.h),
            ],
          ),
        ),
      ),
    );
  }
}