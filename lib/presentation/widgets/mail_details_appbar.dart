// lib/presentation/widgets/mail_details_appbar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/auth_bloc/auth_bloc.dart';
import 'package:gmail_clone/bloc/mail_bloc/mail_bloc.dart';
import 'package:gmail_clone/data/models/mail.dart';
import 'package:gmail_clone/presentation/screens/home/mail_details_screen.dart';

class MailDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MailDetailsAppBar({
    super.key,
    required this.currentMail,
    required this.widget,
  });

  final MailModel? currentMail;
  final MailDetailsScreen widget;

  @override
  Size get preferredSize => const Size(double.infinity, 80);

  @override
  Widget build(BuildContext context) {
    final mailData = currentMail ?? widget.mail;
    final uid = context.read<AuthBloc>().state.activeUser?.uid ?? '';

    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 23),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (mailData != null)
          mailData.isDeleted(uid)
              ? const SizedBox.shrink()
              : IconButton(
                icon: const Icon(Icons.delete_outline, size: 23),
                onPressed: () {
                  context.read<MailBloc>().add(
                    DeleteMailEvent(mailData.id, uid),
                  );
                  Navigator.pop(context);
                  context.read<MailBloc>().add(ResetMailStateEvent());
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Deleted')));
                },
              ),
        if (mailData != null)
          PopupMenuButton(
            position: PopupMenuPosition.under,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(
                          mailData.isImportant(uid)
                              ? Icons.label_important
                              : Icons.label_important_outline,
                          size: 20,
                        ),
                        const SizedBox(width: 15),
                        Text(
                          mailData.isImportant(uid)
                              ? "Mark as not important"
                              : "Mark as important",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    onTap: () {
                      context.read<MailBloc>().add(
                        ToggleImportantEvent(
                          mailData.id,
                          uid,
                          !mailData.isImportant(uid),
                        ),
                      );
                    },
                  ),
                ],
            icon: const Icon(Icons.more_vert, size: 23),
          ),
      ],
    );
  }
}
