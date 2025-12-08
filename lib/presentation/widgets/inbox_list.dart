import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/auth_bloc/auth_bloc.dart';
import 'package:gmail_clone/bloc/mail_bloc/mail_bloc.dart';
import 'package:gmail_clone/data/models/mail.dart';
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
        final allAccounts = authState.accounts;
        final allAccountEmails = allAccounts.map((acc) => acc.email).toSet();

        return BlocBuilder<MailBloc, MailState>(
          builder: (context, mailState) {
            List<MailModel> allMails = [];

            // Filter mails based on selected drawer filter
            switch (mailState.filterType) {
              case DrawerFilterType.allInboxes:
                // Show all mails from all accounts (deduplicate by ID)
                final allMailsMap = <String, MailModel>{};
                for (final mail in mailState.inbox) {
                  allMailsMap[mail.id] = mail;
                }
                allMails = allMailsMap.values.toList();
                break;
              case DrawerFilterType.primary:
                // Simple: Show only mails where to field matches active user's email
                if (activeUser != null) {
                  allMails =
                      mailState.inbox
                          .where((mail) => mail.to == activeUser.email)
                          .toList();
                }
                break;
              case DrawerFilterType.promotions:
              case DrawerFilterType.social:
                // Leave blank for now
                allMails = [];
                break;
              case DrawerFilterType.starred:
                // Show only starred mails
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
              case DrawerFilterType.sent:
              case DrawerFilterType.spam:
              case DrawerFilterType.bin:
                // Will be implemented later
                allMails = [];
                break;
            }

            // Sort by timestamp (newest first)
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

            return Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
                itemCount: allMails.length,
                separatorBuilder: (c, i) => const SizedBox(height: 5),
                itemBuilder: (context, index) {
                  final mail = allMails[index];

                  final isSent =
                      activeUser != null && mail.from == activeUser.email;
                  final displayName = isSent ? mail.to : mail.from;
                  final displayEmail = displayName;

                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.vertical(
                        top: Radius.circular(index == 0 ? 25 : 0),
                        bottom: Radius.circular(
                          index == allMails.length - 1 ? 25 : 0,
                        ),
                      ),
                    ),
                    tileColor:
                        systemTheme == Brightness.dark
                            ? Colors.grey[900]
                            : Colors.grey[100],
                    leading: CircleAvatar(
                      backgroundColor:
                          isSent ? Colors.blue.shade400 : Colors.red.shade400,
                      child: Text(
                        _getInitials(displayName),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            displayEmail,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isSent)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.send,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                    subtitle: Text(
                      mail.subject.isEmpty ? "(No subject)" : mail.subject,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatTime(mail.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            context.read<MailBloc>().add(
                              ToggleStarEvent(mail.id, !mail.starred),
                            );
                          },
                          child: Icon(
                            mail.starred ? Icons.star : Icons.star_border,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed('/Mail details', arguments: mail);
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
