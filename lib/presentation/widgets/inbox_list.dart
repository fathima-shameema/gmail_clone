import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/auth_bloc/auth_bloc.dart';
import 'package:gmail_clone/bloc/mail_bloc/mail_bloc.dart';
import 'package:gmail_clone/data/models/mail.dart';
import 'package:gmail_clone/presentation/widgets/inbox_data.dart';
import 'package:intl/intl.dart';

class InboxList extends StatelessWidget {
  const InboxList({super.key});

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat('h:mm a').format(dateTime);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(dateTime);
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }

  String _getInitials(String text) {
    if (text.isEmpty) return "?";
    return text[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final systemTheme = MediaQuery.of(context).platformBrightness;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final activeUser = authState.activeUser;
        // final allAccounts = authState.accounts;
        // final allAccountEmails = allAccounts.map((acc) => acc.email).toSet();

        return BlocBuilder<MailBloc, MailState>(
          builder: (context, mailState) {
            List<MailModel> allMails = [];
            bool isBin = false;

            switch (mailState.filterType) {
              case DrawerFilterType.allInboxes:
                final allMailsMap = <String, MailModel>{};
                for (final mail in mailState.inbox) {
                  allMailsMap[mail.id] = mail;
                }
                allMails = allMailsMap.values.toList();
                break;
              case DrawerFilterType.primary:
                if (activeUser != null) {
                  allMails =
                      mailState.inbox
                          .where((mail) => mail.to == activeUser.email)
                          .toList();
                }
                break;
              case DrawerFilterType.promotions:
              case DrawerFilterType.social:
                allMails = [];
                break;
              case DrawerFilterType.starred:
                if (activeUser != null) {
                  allMails =
                      mailState.inbox
                          .where(
                            (mail) =>
                                mail.to == activeUser.email &&
                                mail.starred == true,
                          )
                          .toList();
                }
                break;
              case DrawerFilterType.important:
                allMails = [];
                break;

              case DrawerFilterType.sent:
                if (activeUser != null) {
                  allMails = List<MailModel>.from(mailState.sent);
                }
                break;

              case DrawerFilterType.spam:
                allMails = [];
                break;

              case DrawerFilterType.bin:
                if (activeUser != null) {
                  allMails = List<MailModel>.from(mailState.bin);
                  isBin = true;
                }
                break;
            }

            allMails.sort((a, b) => b.timestamp.compareTo(a.timestamp));

            if (allMails.isEmpty) {
              return Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No emails",
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              );
            }

            return InboxData(
              isBin: isBin,
              allMails: allMails,
              systemTheme: systemTheme,
              getInitials: _getInitials,
              formatTime: _formatTime,
              activeUser: activeUser,
            );
          },
        );
      },
    );
  }
}
