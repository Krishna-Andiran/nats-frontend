import 'package:flutter/material.dart';

class LoginForm {
  static Widget emailTextfield(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(hintText: "Email Address"),
    );
  }

  static Widget passwordTextfield(TextEditingController controller) {
    return TextField(
      obscureText: true,
      controller: controller,
      decoration: const InputDecoration(
          suffixIcon: Icon(Icons.visibility_off), hintText: "Password"),
    );
  }

  static Widget submit(String text, {required void Function() onPressed}) {
    return Align(
      alignment: Alignment.center, // Centers the button horizontally
      child: SizedBox(
        width: 140, // Fixed width
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fixedSize: const Size(140, 45), // Ensures fixed height
          ),
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
}
