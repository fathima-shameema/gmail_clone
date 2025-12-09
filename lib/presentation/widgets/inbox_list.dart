// lib/presentation/widgets/inbox_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/auth_bloc/auth_bloc.dart';
import 'package:gmail_clone/bloc/mail_bloc/mail_bloc.dart';
import 'package:gmail_clone/data/models/mail.dart';
import 'package:gmail_clone/presentation/widgets/custom_loader.dart';
import 'package:gmail_clone/presentation/widgets/inbox_data.dart';
import 'package:intl/intl.dart';

class InboxList extends StatelessWidget {
  const InboxList({super.key});

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) return DateFormat('h:mm a').format(dateTime);
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return DateFormat('EEEE').format(dateTime);
    return DateFormat('MMM d').format(dateTime);
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
        final userUid = activeUser?.uid ?? '';
        final userEmail = activeUser?.email ?? '';

        return BlocBuilder<MailBloc, MailState>(
          builder: (context, mailState) {
            bool isLoading = false;

            switch (mailState.filterType) {
              case DrawerFilterType.primary:
                isLoading = mailState.inboxLoading;
                break;
              case DrawerFilterType.allInboxes:
                isLoading = mailState.allInboxLoading;
                break;
              case DrawerFilterType.sent:
                isLoading = mailState.sentLoading;
                break;
              case DrawerFilterType.starred:
                isLoading = mailState.inboxLoading || mailState.sentLoading;
                break;
              case DrawerFilterType.important:
                isLoading = mailState.importantLoading;
                break;
              case DrawerFilterType.bin:
                isLoading = mailState.binLoading;
                break;
              default:
                isLoading = false;
            }

            if (isLoading) {
              return const Expanded(
                child: Center(child: CustomLoader()),
              );
            }

            List<MailModel> allMails = [];
            bool isBin = false;
            bool isSent = mailState.filterType == DrawerFilterType.sent;

            switch (mailState.filterType) {
              case DrawerFilterType.allInboxes:
                final allMailsMap = <String, MailModel>{};
                for (final mail in mailState.inbox) {
                  allMailsMap[mail.id] = mail;
                }
                allMails = allMailsMap.values.toList();
                break;
              case DrawerFilterType.primary:
                allMails =
                    mailState.inbox
                        .where(
                          (mail) =>
                              mail.to == userEmail && !mail.isDeleted(userUid),
                        )
                        .toList();
                break;
              case DrawerFilterType.promotions:
              case DrawerFilterType.social:
                allMails = [];
                break;
              case DrawerFilterType.starred:
                {
                  final map = <String, MailModel>{};
                  for (final m in mailState.inbox) {
                    if (m.isStarred(userUid)) map[m.id] = m;
                  }
                  for (final m in mailState.sent) {
                    if (m.isStarred(userUid)) map[m.id] = m;
                  }
                  allMails = map.values.toList();
                }
                break;
              case DrawerFilterType.important:
                allMails = mailState.important;
                break;
              case DrawerFilterType.sent:
                allMails = mailState.sent;
                break;
              case DrawerFilterType.spam:
                allMails = [];
                break;
              case DrawerFilterType.bin:
                allMails = mailState.bin;
                isBin = true;
                break;
            }

            allMails.sort((a, b) => b.timestamp.compareTo(a.timestamp));

            if (allMails.isEmpty) {
              return const Expanded(child: Center(child: Text("No emails")));
            }

            return InboxData(
              isSent: isSent,
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
