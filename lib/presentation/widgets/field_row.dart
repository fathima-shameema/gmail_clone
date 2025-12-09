import 'package:flutter/material.dart';
import 'package:gmail_clone/presentation/widgets/no_border_input_decoration.dart';

class FieldRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const FieldRow({super.key, required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(width: 20),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: noBorderDecoration(""),
            ),
          ),
        ],
      ),
    );
  }
}
