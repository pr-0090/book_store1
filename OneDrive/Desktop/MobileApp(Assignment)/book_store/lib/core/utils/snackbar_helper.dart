import 'package:flutter/material.dart';

void showMySnackBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
