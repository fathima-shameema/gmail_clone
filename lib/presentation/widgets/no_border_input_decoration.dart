  import 'package:flutter/material.dart';

InputDecoration noBorderDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 20),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
      isDense: true,
    );
  }