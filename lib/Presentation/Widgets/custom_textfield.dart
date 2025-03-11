import 'package:admin_curator/Constants/app_colors.dart';
import 'package:admin_curator/Constants/app_styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String header;
  final String hintText;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final double width;
  final bool? readOnly;

  const CustomTextField({
    super.key,
    required this.header,
    required this.hintText,
    required this.textEditingController,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.width = 400,
    this.validator,
    this.readOnly,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_validateOnFocusChange);
  }

  void _validateOnFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() {
        _errorText = widget.validator?.call(widget.textEditingController.text);
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.header,
                style: AppStyles.subHeadingMobile.copyWith(
                  color: AppColors.orange,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '*',
                style: AppStyles.subHeadingMobile.copyWith(
                  color: AppColors.orange,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: widget.textEditingController,
            focusNode: _focusNode,
            readOnly: widget.readOnly ?? false,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword,
            validator: widget.validator,
            style: AppStyles.subHeadingMobile.copyWith(color: Colors.black),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppStyles.subHeadingMobile.copyWith(
                color: AppColors.grey,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 12,
              ),
              errorText: _errorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
