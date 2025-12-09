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
  Size get preferredSize => Size(double.infinity, 80);

  @override
  Widget build(BuildContext context) {
    final mailData = currentMail ?? widget.mail;

    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 23),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (mailData != null)
          mailData.isDeleted
              ? SizedBox.shrink()
              : IconButton(
                icon: const Icon(Icons.delete_outline, size: 23),
                onPressed: () {
                  context.read<MailBloc>().add(DeleteMailEvent(mailData.id));
                  Navigator.pop(context);
                },
              ),
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
                        mailData!.important
                            ? Icons.label_important
                            : Icons.label_important_outline,
                        size: 20,
                      ),
                      SizedBox(width: 15),
                      Text(
                        mailData.important
                            ? "Mark as not important"
                            : "Mark as important",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  onTap: () {
                    final newValue = !mailData.important;
                    final bloc = context.read<MailBloc>();
                    final auth = context.read<AuthBloc>().state;

                    bloc.add(ToggleImportantEvent(mailData.id, newValue));

                    Future.delayed(Duration(milliseconds: 150), () {
                      if (bloc.state.filterType == DrawerFilterType.important) {
                        bloc.add(LoadInboxEvent(auth.activeUser!.email));
                      }
                    });
                  },
                ),
              ],
          icon: const Icon(Icons.more_vert, size: 23),
        ),
      ],
    );
  }
}
