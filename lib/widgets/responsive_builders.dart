import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget mobileView;
  final Widget desktopView;

  const ResponsiveBuilder({
    super.key,
    required this.mobileView,
    required this.desktopView,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 600 ? mobileView : desktopView;
  }
}
