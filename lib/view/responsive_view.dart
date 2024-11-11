import 'package:flutter/material.dart';
import 'package:frontend/view/mobile/auth/login_screen_mobile.dart';
import 'package:frontend/view/web/auth/login_screen_web.dart';
import 'package:frontend/widgets/responsive_builders.dart';

class ResponsiveView extends StatelessWidget {
  const ResponsiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        mobileView: LoginScreenMobile(), desktopView: LoginScreenWeb());
  }
}
