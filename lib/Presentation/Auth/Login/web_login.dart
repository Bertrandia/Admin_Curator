import 'package:admin_curator/Presentation/Auth/Login/login_form.dart';
import 'package:admin_curator/Presentation/Auth/Widgets/display_image.dart';
import 'package:flutter/material.dart';

class WebLoginScreen extends StatefulWidget {
  const WebLoginScreen({super.key});

  @override
  State<WebLoginScreen> createState() => WebLoginScreenState();
}

class WebLoginScreenState extends State<WebLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Flexible(flex: 50, child: DisplayImage()),
              const Flexible(flex: 50, child: WebLoginForm()),
            ],
          );
        },
      ),
    );
  }
}
