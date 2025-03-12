import 'package:admin_curator/Constants/app_colors.dart';
import 'package:admin_curator/Constants/app_strings.dart';
import 'package:admin_curator/Constants/app_styles.dart';
import 'package:admin_curator/Core/Notifiers/auth_notifier.dart';
import 'package:admin_curator/Presentation/Widgets/custom_textfield.dart';
import 'package:admin_curator/Presentation/Widgets/global_btn.dart';
import 'package:admin_curator/Presentation/Widgets/logo.dart';
import 'package:admin_curator/Providers/providers.dart';
import 'package:admin_curator/Providers/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebLoginForm extends ConsumerStatefulWidget {
  const WebLoginForm({super.key});

  @override
  ConsumerState<WebLoginForm> createState() => _WebLoginFormState();
}

class _WebLoginFormState extends ConsumerState<WebLoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    final email = ref.watch(emailControllerProvider);
    final password = ref.watch(passwordControllerProvider);

    return Container(
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Row(children: [LogoWidget(height: 80)]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.login,
                    style: AppStyles.subHeading.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    header: "Email Address",
                    hintText: "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                    textEditingController: email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email can't be empty";
                      } else if (!RegExp(
                        r'^[^@]+@[^@]+\.[^@]+',
                      ).hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    header: "Enter your password",
                    hintText: "Enter your password",
                    textEditingController: password,
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password can't be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 70),
                  authState.isLoading
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                      : GlobalButton(
                        text: AppStrings.login,
                        onPressed:
                            () => handleLogin(authNotifier, email, password),
                        height: 35,
                        width: 250,
                      ),
                  const SizedBox(height: 20),
                  if (authState.errorMessage.isNotEmpty)
                    Text(authState.errorMessage, style: AppStyles.errorText),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleLogin(
    AuthNotifier authNotifier,
    TextEditingController email,
    TextEditingController password,
  ) async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await authNotifier.signIn(
        email.text.trim(),
        password.text.trim(),
      );

      if (success) {
        email.clear();
        password.clear();
      }
    }
  }
}
