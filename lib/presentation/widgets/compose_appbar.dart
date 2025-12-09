import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/compose_bloc/compose_bloc.dart';

class ComposeAppbar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(BuildContext) onSent;
  const ComposeAppbar({super.key, required this.onSent});
  @override
  Size get preferredSize => Size(double.infinity, 80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.4,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 23),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.send_outlined, size: 23),
                onPressed: () {
                  final isSending = context.read<ComposeBloc>().state.isSending;
                  if (!isSending) onSent(context);
                },
              ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, size: 23),
          onPressed: () {},
        ),
      ],
    );
  }
}
