import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podlove_flutter/constants/api_endpoints.dart';
import 'package:podlove_flutter/data/services/api_services.dart';
import 'package:podlove_flutter/providers/global_providers.dart';
import 'package:podlove_flutter/providers/user/user_provider.dart';
import 'package:podlove_flutter/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyCodeState {
  final bool isLoading;
  final bool? isSuccess;
  final String? error;

  VerifyCodeState({
    this.isLoading = false,
    this.isSuccess,
    this.error,
  });

  factory VerifyCodeState.initial() {
    return VerifyCodeState(
      isLoading: false,
      isSuccess: null,
      error: null,
    );
  }

  VerifyCodeState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return VerifyCodeState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? error,
    );
  }
}

class VerifyCodeNotifier extends StateNotifier<VerifyCodeState> {
  final ApiServices apiService;
  final Ref ref;

  VerifyCodeNotifier(this.apiService, this.ref) : super(VerifyCodeState());

  final otpController = TextEditingController();

  Future<void> verifyCode(String status, String email) async {
    state = state.copyWith(isLoading: true);
    try {
      if (status == "EmailRecoveryVerify") {
        final recoveryCodeData = {
          "email": email,
          "recoveryOTP": otpController.text,
        };

        final response = await apiService.post(
          ApiEndpoints.emailRecoveryVerify,
          data: recoveryCodeData,
        );
        logger.i(response);
      } else if (status == "EmailActivationVerify") {
        final verifyCodeData = {
          "email": email,
          "verificationOTP": otpController.text,
        };

        final response = await apiService.post(
          ApiEndpoints.activate,
          data: verifyCodeData,
        );

        if (response.statusCode == 200) {
          final accessToken = response.data["data"]["accessToken"];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', accessToken);

          logger.i(prefs.getString('accessToken'));

          final userJson = response.data["data"]["user"];
          ref
              .read(userProvider.notifier)
              .initialize(userJson);
          state = state.copyWith(isSuccess: true, isLoading: false);
        }
      }
    } catch (e) {
      state = state.copyWith(
        isSuccess: false,
        error: "An unexpected error occurred. Please try again.",
        isLoading: false,
      );
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}

final verifyCodeProvider =
    StateNotifierProvider<VerifyCodeNotifier, VerifyCodeState>(
  (ref) {
    final apiService = ref.read(apiServiceProvider);
    return VerifyCodeNotifier(apiService, ref);
  },
);